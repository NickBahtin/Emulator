unit uBalance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,
  Helper,
  Dialogs, uBaseFrame, Ex_Grid, StdCtrls, ExtCtrls, ComCtrls;
const
  gvParamNames:array[0..4] of String=(
  'Датчик',
  'Нулевое значение',
  'Коэффициент',
  'Вес',
  'Отклонение'
  );

type
  TfrmBalance = class(TBaseFrame)
    procedure gvTableGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableGetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure Update;override;
  private
    { Private declarations }
    FNulls: array [0..3] of longint;
    //величина девиации по рандому
    RandomCorrectValues: array [0..5] of Single;
    RandomRanges: array [0..3] of longint;
    FKoeffs: array [0..3] of Single;
    function  GetParams:String;override;
    function GetValues: String;override;
    procedure SetParams(const Value: String);override;
    procedure SetValues(const Value: String);override;
    function GetWeight(idx: integer): single;
    procedure SetWeight(idx: integer; const Value: single);
  public
    { Public declarations }
    Controller:TModuleScales;
    property Weight[idx:integer]:single read GetWeight write SetWeight;
  end;

var
  frmBalance: TfrmBalance;

implementation

{$R *.dfm}

function TfrmBalance.GetParams: String;
var s:string;
begin
  s:=Format('%d,%d,%d,%d,%f,%f,%f,%f',[
         FNulls[0],
         FNulls[1],
         FNulls[2],
         FNulls[3],
         FKoeffs[0],
         FKoeffs[1],
         FKoeffs[2],
         FKoeffs[3]
         ]);
  result:=s;
end;

function TfrmBalance.GetValues: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d',[
         Controller.ScalesValues[0],
         Controller.ScalesValues[1],
         Controller.ScalesValues[2],
         Controller.ScalesValues[3],
         RandomRanges[0],
         RandomRanges[1],
         RandomRanges[2],
         RandomRanges[3]
         ])

end;

function TfrmBalance.GetWeight(idx: integer): single;
begin
  result:=Controller.ScalesValues[idx]*FKoeffs[idx]-FNulls[Idx]*FKoeffs[idx];
end;

procedure TfrmBalance.gvTableGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..4: begin
         //значения
         case cell.Row of
         0: begin
              if Controller.ScalesValues[cell.Col-1]<>0 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
         1: begin
              if FNulls[cell.Col-1]>0 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
         2:
              if FKoeffs[cell.Col-1]>1 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
         3:
              if FKoeffs[cell.Col-1]>1 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
         4:
              if RandomRanges[cell.Col-1]>1 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
         end;
       end;
    end;
end;

procedure TfrmBalance.SetWeight(idx: integer; const Value: single);
begin
  if FKoeffs[idx]=0 then FKoeffs[idx]:=1;
  Controller.ScalesValues[idx]:=Round(FNulls[Idx]*FKoeffs[idx]+Value/FKoeffs[idx]);

end;

procedure TfrmBalance.SetParams(const Value: String);
begin
   FNulls[0]:=StrToIntDef(PartOfStr(Value,1),0);
   FNulls[1]:=StrToIntDef(PartOfStr(Value,2),0);
   FNulls[2]:=StrToIntDef(PartOfStr(Value,3),0);
   FNulls[3]:=StrToIntDef(PartOfStr(Value,4),0);
   FKoeffs[0]:=StrToFloatDef(PartOfStr(Value,5),1);
   FKoeffs[1]:=StrToFloatDef(PartOfStr(Value,6),1);
   FKoeffs[2]:=StrToFloatDef(PartOfStr(Value,7),1);
   FKoeffs[3]:=StrToFloatDef(PartOfStr(Value,8),1);
end;

procedure TfrmBalance.SetValues(const Value: String);
begin
   Controller.ScalesValues[0]:=StrToIntDef(PartOfStr(Value,1),0);
   Controller.ScalesValues[1]:=StrToIntDef(PartOfStr(Value,2),0);
   Controller.ScalesValues[2]:=StrToIntDef(PartOfStr(Value,3),0);
   Controller.ScalesValues[3]:=StrToIntDef(PartOfStr(Value,4),0);
   RandomRanges[0]:=StrToIntDef(PartOfStr(Value,5),0);
   RandomRanges[1]:=StrToIntDef(PartOfStr(Value,6),0);
   RandomRanges[2]:=StrToIntDef(PartOfStr(Value,7),0);
   RandomRanges[3]:=StrToIntDef(PartOfStr(Value,8),0);
end;

procedure TfrmBalance.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         if cell.Row in [0..4] then
         Value:=gvParamNames[cell.Row];
       end;
    1..4: begin
         //значения
         case cell.Row of
         0: begin
              Value:=IntToStr(Controller.ScalesValues[cell.Col-1]);
            end;
         1: begin
              Value:=IntToStr(FNulls[cell.Col-1]);
            end;
         2: begin
              Value:=FloatToStr(FKoeffs[cell.Col-1]);
            end;
         3: begin
              Value:=FloatToStr(Weight[cell.Col-1]);
            end;
         4: begin
              Value:=IntToStr(RandomRanges[cell.Col-1]);
            end;
         end;
       end;
    end;
end;

procedure TfrmBalance.gvTableGetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..4: begin
         //значения
         case cell.Row of
         0: begin
              Value:=IntToStr(Controller.ScalesValues[cell.Col-1]);
            end;
         1: begin
              Value:=IntToStr(FNulls[cell.Col-1]);
            end;
         2: begin
              Value:=FloatToStr(FKoeffs[cell.Col-1]);
            end;
         3: begin
              Value:=FloatToStr(Weight[cell.Col-1]);
            end;
         4: begin
              Value:=IntToStr(RandomRanges[cell.Col-1]);
            end;
         end;
       end;
    end;
end;

procedure TfrmBalance.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..4: begin
         //значения
         case cell.Row of
         0: begin
              Controller.ScalesValues[cell.Col-1]:=StrToIntDef(Value,0);
            end;
         1: begin
              FNulls[cell.Col-1]:=StrToIntDef(Value,0);
            end;
         2: begin
              FKoeffs[cell.Col-1]:=StrToFloatDef(Value,1);
            end;
         3: begin
              Weight[cell.Col-1]:=StrToFloatDef(Value,1);
            end;
         4: begin
              RandomRanges[cell.Col-1]:=StrToIntDef(Value,1);
            end;
         end;
       end;
    end;
    gvTable.Invalidate;
end;

function TfrmBalance.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  len:integer;
  Addr:byte;
begin
  //проверяем ответ
  Result := false;
  // Функция определяет, ответ на какую именно команду проверяется, а затем проверяет его.
  Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
  len:=Length(aCMD);
  if (
      (aCMD[1]='#') and
      (aCMD[4]='A') and
      (Addr=Controller.Address)
     ) then
  begin
    Result := CheckForChkCr(aCMD);
  end;
end;

//#80ACC<CR>
//!808B20D78F5F518DBEEA000000E8<CR>
//8B20D7
//8F5F51
//8DBEEA
//000000
function TfrmBalance.GenerateAnswer: String;
begin
  result := AddChkCr('!'+IntToHex(Controller.Address, 2)+
            IntToHex(Controller.ScalesValues[0], 6)+
            IntToHex(Controller.ScalesValues[1], 6)+
            IntToHex(Controller.ScalesValues[2], 6)+
            IntToHex(Controller.ScalesValues[3], 6)
  )
end;

procedure TfrmBalance.Update;
var i:integer;
begin
  if Assigned(Controller) then
  begin
    for i:=0 to 3 do
    begin
      RandomCorrectValues[i]:=Random(RandomRanges[i])/100;
      Controller.ScalesValues[i]:=Round(Controller.ScalesValues[i]+RandomCorrectValues[i]);
    end;
    gvTable.Invalidate;
  end;
end;

end.
