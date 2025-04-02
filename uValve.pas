unit uValve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,
  Helper,
  StrUtils,
  Dialogs, uBaseFrame, Ex_Grid, ComCtrls;
const
  cValveIncDecStep=5;
  gvOpenCloseNames:array[boolean] of String=('0','1');
  gvStateNames:array[0..3] of String=(
  'СТОП',
  'ОТКР.',
  'ЗАКР.',
  'ОСТАНОВ');
  gvParamNames:array[0..4] of String=(
  'Входы',
  'Выходы',
  'Привязка',
  'Позиция',
  'Состояние'
  );

type
  TfrmValve = class(TBaseFrame)
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure gvTableGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableGetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure Update;override;
    procedure gvTableDblClick(Sender: TObject);
  private
    { Private declarations }
    FComments: array [0..9] of String;
    function GetComments: String;override;
    procedure SetComments(const Value: String);override;
    function  GetParams:String;override;
    function GetValues: String;override;
    procedure SetParams(const Value: String);override;
    procedure SetValues(const Value: String);override;
    function GetInputs: word;
    function GetOutputs: word;
  public

    //0 - стоит 1 открывается 2 - закрывается
    ValveStates:array [0..2] of byte;
    ValveCommandPosition:array [0..2] of word;
    { Public declarations }
    Controller:TModuleValve;
    property Inputs:word read GetInputs;
    property Outputs:word read GetOutputs;
  end;

var
  frmValve: TfrmValve;

implementation

{$R *.dfm}

{ TfrmValve }

function TfrmValve.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  len:integer;
  Addr:byte;
  Status,Control:boolean;
begin
  //проверяем ответ
  Result := false;
  // Функция определяет, ответ на какую именно команду проверяется, а затем проверяет его.
  Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
  if (
      (aCMD[1]='#') and
      (Addr=Controller.Address)
     ) then
   begin
     Result := CheckForChkCr(aCMD);
   end;
end;

function TfrmValve.GenerateAnswer: String;
var
   N:byte;
   T:byte;
   Position:word;
begin
  if (ReceivedCmd[4]='S') then
      result := AddChkCr('!'+IntToHex(Controller.Address, 2)+IntToHex(Inputs, 4)+IntToHex(Outputs, 4)+
          RightStr('000' + IntToStr(Controller.ValvePositions[0]), 4)+
          RightStr('000' + IntToStr(Controller.ValvePositions[1]), 4)+
          RightStr('000' + IntToStr(Controller.ValvePositions[2]), 4))
  else if (ReceivedCmd[1]='#') then
  begin
      //реагируем на команду
      if (ReceivedCmd[4]='B') then
      begin
         //останавливаем движение на выбранной задвижке
         N:=ord(ReceivedCmd[5])-ord('0');
         if N in [0..2] then
            ValveStates[N]:=3;
      end;
      if (ReceivedCmd[4]='O') then
      begin
         //выставляем на выбранном выходе значение
         if (ReceivedCmd[5] in ['1'..'9']) then
            Controller.OutputValues[ord(ReceivedCmd[5])-ord('1')]:=ReceivedCmd[6]='1';

      end;
      if (ReceivedCmd[4] in ['0'..'2']) then
      begin
         //выставляем позицию на требуемой задвижке
          Position:=StrToInt(copy(ReceivedCmd,5,4));
          N:=ord(ReceivedCmd[4])-ord('0');
          ValveCommandPosition[N]:=Position;
          if Controller.ValvePositions[N]>Position then
            //закрываем до позиции
            ValveStates[N]:=2
          else if Controller.ValvePositions[N]<Position then
            //открываем до позиции
            ValveStates[N]:=1;
      end;
      //формируем ответ
      result := AddChkCr('!'+IntToHex(Controller.Address, 2));
  end
  else if (ReceivedCmd[1]='$') then
  begin
      //запуск калибровки!
      result := AddChkCr('$'+IntToHex(Controller.Address, 2));
  end;
end;

function TfrmValve.GetComments: String;
begin
  result:=Format('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',[
         FComments[0],
         FComments[1],
         FComments[2],
         FComments[3],
         FComments[4],
         FComments[5],
         FComments[6],
         FComments[7],
         FComments[8],
         FComments[9]
         ]);

end;

function TfrmValve.GetInputs: word;
var i:byte;
begin
  result:=0;
  for i:=0 to 9 do
    if Controller.InputValues[i] then
       result:=result+(1 shl i);
end;

function TfrmValve.GetOutputs: word;
var i:byte;
begin
  result:=0;
  for i:=0 to 9 do
    if Controller.OutputValues[i] then
       result:=result+(1 shl i);
end;

function TfrmValve.GetParams: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',[
         Ord(Controller.OutputValues[0]),
         Ord(Controller.OutputValues[1]),
         Ord(Controller.OutputValues[2]),
         Ord(Controller.OutputValues[3]),
         Ord(Controller.OutputValues[4]),
         Ord(Controller.OutputValues[5]),
         Ord(Controller.OutputValues[6]),
         Ord(Controller.OutputValues[7]),
         Ord(Controller.OutputValues[8]),
         Ord(Controller.OutputValues[9]),
         Ord(Controller.OutputValues[9]),
         Controller.ValvePositions[0],
         Controller.ValvePositions[1],
         Controller.ValvePositions[2],
         ValveCommandPosition[0],
         ValveCommandPosition[1],
         ValveCommandPosition[2]
         ])
end;

function TfrmValve.GetValues: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',[
         Ord(Controller.InputValues[0]),
         Ord(Controller.InputValues[1]),
         Ord(Controller.InputValues[2]),
         Ord(Controller.InputValues[3]),
         Ord(Controller.InputValues[4]),
         Ord(Controller.InputValues[5]),
         Ord(Controller.InputValues[6]),
         Ord(Controller.InputValues[7]),
         Ord(Controller.InputValues[8]),
         Ord(Controller.InputValues[9]),
         ValveStates[0],
         ValveStates[1],
         ValveStates[2]
         ])
end;

procedure TfrmValve.SetComments(const Value: String);
begin
   FComments[0]:=PartOfStr(Value,1);
   FComments[1]:=PartOfStr(Value,2);
   FComments[2]:=PartOfStr(Value,3);
   FComments[3]:=PartOfStr(Value,4);
   FComments[4]:=PartOfStr(Value,5);
   FComments[5]:=PartOfStr(Value,6);
   FComments[6]:=PartOfStr(Value,7);
   FComments[7]:=PartOfStr(Value,8);
   FComments[8]:=PartOfStr(Value,9);
   FComments[9]:=PartOfStr(Value,10);
end;

procedure TfrmValve.SetParams(const Value: String);
begin
   Controller.OutputValues[0]:=StrToIntDef(PartOfStr(Value,1),0)>0;
   Controller.OutputValues[1]:=StrToIntDef(PartOfStr(Value,2),0)>0;
   Controller.OutputValues[2]:=StrToIntDef(PartOfStr(Value,3),0)>0;
   Controller.OutputValues[3]:=StrToIntDef(PartOfStr(Value,4),0)>0;
   Controller.OutputValues[4]:=StrToIntDef(PartOfStr(Value,5),0)>0;
   Controller.OutputValues[5]:=StrToIntDef(PartOfStr(Value,6),0)>0;
   Controller.OutputValues[6]:=StrToIntDef(PartOfStr(Value,7),0)>0;
   Controller.OutputValues[7]:=StrToIntDef(PartOfStr(Value,8),0)>0;
   Controller.OutputValues[8]:=StrToIntDef(PartOfStr(Value,9),0)>0;
   Controller.OutputValues[9]:=StrToIntDef(PartOfStr(Value,10),0)>0;
   Controller.ValvePositions[0]:=StrToIntDef(PartOfStr(Value,11),0);
   Controller.ValvePositions[1]:=StrToIntDef(PartOfStr(Value,12),0);
   Controller.ValvePositions[2]:=StrToIntDef(PartOfStr(Value,13),0);
   ValveCommandPosition[0]:=StrToIntDef(PartOfStr(Value,14),0);
   ValveCommandPosition[1]:=StrToIntDef(PartOfStr(Value,15),0);
   ValveCommandPosition[2]:=StrToIntDef(PartOfStr(Value,16),0);
end;

procedure TfrmValve.SetValues(const Value: String);
begin
   Controller.InputValues[0]:=StrToIntDef(PartOfStr(Value,1),0)>0;
   Controller.InputValues[1]:=StrToIntDef(PartOfStr(Value,2),0)>0;
   Controller.InputValues[2]:=StrToIntDef(PartOfStr(Value,3),0)>0;
   Controller.InputValues[3]:=StrToIntDef(PartOfStr(Value,4),0)>0;
   Controller.InputValues[4]:=StrToIntDef(PartOfStr(Value,5),0)>0;
   Controller.InputValues[5]:=StrToIntDef(PartOfStr(Value,6),0)>0;
   Controller.InputValues[6]:=StrToIntDef(PartOfStr(Value,7),0)>0;
   Controller.InputValues[7]:=StrToIntDef(PartOfStr(Value,8),0)>0;
   Controller.InputValues[8]:=StrToIntDef(PartOfStr(Value,9),0)>0;
   Controller.InputValues[9]:=StrToIntDef(PartOfStr(Value,10),0)>0;
   ValveStates[0]:=StrToIntDef(PartOfStr(Value,11),0);
   ValveStates[1]:=StrToIntDef(PartOfStr(Value,12),0);
   ValveStates[2]:=StrToIntDef(PartOfStr(Value,13),0);
end;

procedure TfrmValve.gvTableGetCellColors(Sender: TObject; Cell: TGridCell;
  Canvas: TCanvas);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..10: begin
         //значения
         case cell.Row of
         0: begin
              if Controller.InputValues[cell.Col-1] then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
         1: begin
              if Controller.OutputValues[cell.Col-1] then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
         2: begin
              Canvas.Font.Color:=clGray;
            end;
         3: begin
              if cell.Col in [1..3] then
              begin
                if Controller.ValvePositions[cell.Col-1]>0 then
                  Canvas.Font.Color:=clGreen
                else
                  Canvas.Font.Color:=clBlack;
              end;
            end;
         4: begin
              if cell.Col in [1..3] then
              begin
                if ValveCommandPosition[cell.Col-1]=1 then
                  Canvas.Font.Color:=clGreen
                else if ValveCommandPosition[cell.Col-1]=2 then
                  Canvas.Font.Color:=clRed
                else
                  Canvas.Font.Color:=clBlack;
              end;
            end;
       end;
      end;
    end;
end;

procedure TfrmValve.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         if cell.Row in [0..4] then
         Value:=gvParamNames[cell.Row];
       end;
    1..10: begin
         //значения
         case cell.Row of
         0: begin
              Value:=gvOpenCloseNames[Controller.InputValues[cell.Col-1]];
            end;
         1: begin
              Value:=gvOpenCloseNames[Controller.OutputValues[cell.Col-1]];
            end;
         2: begin
              Value:=FComments[cell.Col-1];
            end;
         3: begin
              if cell.Col in [1..3] then
                 Value:=FloatToStr(Controller.ValvePositions[cell.Col-1]/10)+'%'
              else
                 Value:='---';
            end;
         4: begin
              if cell.Col in [1..3] then
              begin
                 Value:=gvStateNames[ValveStates[cell.Col-1]];
              end
              else
                 Value:='---';
            end;
         end;
       end;
    end;
end;

procedure TfrmValve.gvTableGetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         if cell.Row in [0..2] then
         Value:=gvParamNames[cell.Row];
       end;
    1..10: begin
         //значения
         case cell.Row of
         0: begin
              Value:=gvOpenCloseNames[Controller.InputValues[cell.Col-1]];
            end;
         1: begin
              Value:=gvOpenCloseNames[Controller.OutputValues[cell.Col-1]];
            end;
         2: begin
              Value:=FComments[cell.Col-1];
            end;
         3: begin
              if cell.Col in [1..3] then
                 Value:=FloatToStr(Controller.ValvePositions[cell.Col-1]/10)
              else
                 Value:='';
            end;
         4: begin
              if cell.Col in [1..3] then
              begin
                 Value:=gvStateNames[ValveStates[cell.Col-1]];
              end
              else
                 Value:='';
            end;
         end;
       end;
    end;
end;

procedure TfrmValve.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..10: begin
         //значения
         case cell.Row of
         0: begin
              if (UpperCase(Value)='TRUE') or (UpperCase(Value)=UpperCase(gvOpenCloseNames[true]))  or (Value='1') then
                 Controller.InputValues[cell.Col-1]:=true
              else
                 Controller.InputValues[cell.Col-1]:=false;
            end;
         1: begin
              if (UpperCase(Value)='TRUE') or (UpperCase(Value)=UpperCase(gvOpenCloseNames[true]))  or (Value='1') then
                 Controller.OutputValues[cell.Col-1]:=true
              else
                 Controller.OutputValues[cell.Col-1]:=false;
            end;
         2: begin
              FComments[cell.Col-1]:=Value;
            end;
         3: begin
              if cell.Col in [1..3] then
                 Controller.ValvePositions[cell.Col-1]:=Round(StrToIntDef(Value,0)*10);
            end;
         4: begin
              if (UpperCase(Value)=gvStateNames[0]) or (Value='0') then
                 ValveStates[cell.Col-1]:=0
              else if (UpperCase(Value)=gvStateNames[1]) or (Value='1') then
                 ValveStates[cell.Col-1]:=1
              else if (UpperCase(Value)=gvStateNames[2]) or (Value='2') then
                 ValveStates[cell.Col-1]:=2
              else
                 ValveStates[cell.Col-1]:=0;
            end;
         end;
       end;
    end;
end;

procedure TfrmValve.Update;
begin
  //
  // Задвижка 1
  //
  if ValveStates[0]=1 then
  begin
    //идет открытие первой задвижки
    Controller.OutputValues[0]:=True;
    Controller.InputValues[1]:=False;
    if not Controller.InputValues[0] then
    begin
      if Controller.ValvePositions[0]<1000 then
      begin
         if Controller.ValvePositions[0]<ValveCommandPosition[0] then
            Inc(Controller.ValvePositions[0],cValveIncDecStep)
         else
            ValveStates[0]:=3;//останов
         if Controller.ValvePositions[0]>1000 then Controller.ValvePositions[0]:=1000;
      end
      else
         Controller.InputValues[0]:=True;
    end
    else
      Controller.ValvePositions[0]:=1000;
  end
  else if ValveStates[0]=2 then
  begin
    //идет закрытие первой задвижки
    Controller.OutputValues[1]:=True;
    Controller.InputValues[0]:=False;
    if not Controller.InputValues[1] then
    begin
      if Controller.ValvePositions[0]>0 then
      begin
         if Controller.ValvePositions[0]>ValveCommandPosition[0] then
            Dec(Controller.ValvePositions[0],cValveIncDecStep)
         else
            ValveStates[0]:=3;//останов
         if (Controller.ValvePositions[0]<0) or (Controller.ValvePositions[0]>1000) then Controller.ValvePositions[0]:=0;
      end
      else begin
         Controller.InputValues[1]:=True;
      end;
    end
    else
      Controller.ValvePositions[0]:=0;
  end
  else if ValveStates[0]=3 then
  begin
    //останов
    ValveStates[0]:=0;
    Controller.OutputValues[0]:=False;
    Controller.OutputValues[1]:=False;
    ValveCommandPosition[0]:=Controller.ValvePositions[0];
  end;


  //
  // Задвижка 2
  //
  if ValveStates[1]=1 then
  begin
    //идет открытие первой задвижки
    Controller.OutputValues[2]:=True;
    Controller.InputValues[3]:=False;
    if not Controller.InputValues[2] then
    begin
      if Controller.ValvePositions[1]<1000 then
      begin
         if Controller.ValvePositions[1]<ValveCommandPosition[1] then
            Inc(Controller.ValvePositions[1],cValveIncDecStep)
         else
            ValveStates[1]:=3;//стоп
         if (Controller.ValvePositions[1]>1000) then Controller.ValvePositions[1]:=1000;
      end
      else begin
         Controller.InputValues[2]:=True;
      end;
    end
    else
      Controller.ValvePositions[1]:=1000;
  end else if ValveStates[1]=2 then
  begin
    //идет закрытие первой задвижки
    Controller.OutputValues[3]:=True;
    Controller.InputValues[2]:=False;
    if not Controller.InputValues[3] then
    begin
      if Controller.ValvePositions[1]>0 then
      begin
         if Controller.ValvePositions[1]>ValveCommandPosition[1] then
            Dec(Controller.ValvePositions[1],cValveIncDecStep)
         else
            ValveStates[1]:=3;//стоп
         if (Controller.ValvePositions[1]<0) or (Controller.ValvePositions[1]>1000) then Controller.ValvePositions[1]:=0;
      end
      else begin
         Controller.InputValues[3]:=True;
      end;
    end
    else
      Controller.ValvePositions[1]:=0;
  end else if ValveStates[1]=3 then
  begin
    //останов
    ValveStates[1]:=0;
    Controller.OutputValues[2]:=False;
    Controller.OutputValues[3]:=False;
    ValveCommandPosition[1]:=Controller.ValvePositions[1];
  end;


  //
  // Задвижка 3
  //
  if ValveStates[2]=1 then
  begin
    //идет открытие первой задвижки
    Controller.OutputValues[4]:=True;
    Controller.InputValues[5]:=False;
    if not Controller.InputValues[4] then
    begin
      if Controller.ValvePositions[2]<1000 then
      begin
         if Controller.ValvePositions[2]<ValveCommandPosition[2] then
            Inc(Controller.ValvePositions[2],cValveIncDecStep)
         else
            ValveStates[2]:=3;//стоп
         if (Controller.ValvePositions[2]>1000) then Controller.ValvePositions[2]:=1000;
      end
      else begin
         Controller.InputValues[4]:=True;
      end;
    end
    else begin
      Controller.ValvePositions[2]:=1000;
      ValveStates[2]:=3;
    end;
  end else if ValveStates[2]=2 then
  begin
    //идет закрытие первой задвижки
    Controller.OutputValues[5]:=True;
    Controller.InputValues[4]:=False;
    if not Controller.InputValues[5] then
    begin
      if Controller.ValvePositions[2]>0 then
      begin
         if Controller.ValvePositions[2]>ValveCommandPosition[2] then
            Dec(Controller.ValvePositions[2],cValveIncDecStep)
         else
            ValveStates[2]:=3;//стоп
         if (Controller.ValvePositions[2]<0) or (Controller.ValvePositions[2]>1000) then Controller.ValvePositions[2]:=0;
      end
      else begin
         Controller.InputValues[5]:=True;
      end;
    end
    else
      Controller.ValvePositions[2]:=0;
  end else if ValveStates[2]=3 then
  begin
    //останов
    ValveStates[2]:=0;
    Controller.OutputValues[4]:=False;
    Controller.OutputValues[5]:=False;
    ValveCommandPosition[2]:=Controller.ValvePositions[2];
  end;
  gvTable.Invalidate;
end;

procedure TfrmValve.gvTableDblClick(Sender: TObject);
begin
   case SelectedCell.Row of
   0: begin
           Controller.InputValues[SelectedCell.Col-1]:=not Controller.InputValues[SelectedCell.Col-1];
      end;
   1: begin
           Controller.OutputValues[SelectedCell.Col-1]:=not Controller.OutputValues[SelectedCell.Col-1];
      end;
   end;
end;

end.
