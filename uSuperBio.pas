unit uSuperBio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,
  Helper,
  Dialogs, uBaseFrame, Ex_Grid, StdCtrls, ExtCtrls, ComCtrls;
const
  gvOpenCloseNames:array[boolean] of String=('0','1');
  gvPnevmoParamNames:array[0..2] of String=(
  '¬ходы',
  '¬ыходы',
  'ѕрив€зка'
  );
type
  TfrmSuperBio = class(TBaseFrame)
    Panel1: TPanel;
    cbInputDublicateState: TCheckBox;
    procedure gvTableGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableGetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure Update;override;
    procedure gvTableDblClick(Sender: TObject);
  private
    { Private declarations }
    FComments: array [0..12] of String;
    function GetComments: String;override;
    procedure SetComments(const Value: String);override;
    function  GetParams:String;override;
    procedure SetParams(const Value: String);override;
    function GetValues: String;override;
    procedure SetValues(const Value: String);override;
    function GetInputs: word;
    function GetOutputs: word;
  public
    { Public declarations }
    Controller:TModuleSuperBIO;
    property Inputs:word read GetInputs;
    property Outputs:word read GetOutputs;

  end;

var
  frmSuperBio: TfrmSuperBio;

implementation

{$R *.dfm}

function TfrmSuperBio.GetParams: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',[
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
         Ord(Controller.OutputValues[10]),
         Ord(Controller.OutputValues[11]),
         Ord(Controller.OutputValues[12]),
         ord(cbInputDublicateState.Checked)

         ])
end;

function TfrmSuperBio.GetValues: String;
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
         Ord(Controller.InputValues[10]),
         Ord(Controller.InputValues[11]),
         Ord(Controller.InputValues[12])
         ])
end;

procedure TfrmSuperBio.gvTableGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..13: begin
         //значени€
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
         2:
            Canvas.Font.Color:=clGray;
         end;
       end;
    end;
end;

procedure TfrmSuperBio.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         if cell.Row in [0..2] then
         Value:=gvPnevmoParamNames[cell.Row];
       end;
    1..13: begin
         //значени€
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
         end;
       end;
    end;
end;

procedure TfrmSuperBio.SetParams(const Value: String);
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
   Controller.OutputValues[10]:=StrToIntDef(PartOfStr(Value,11),0)>0;
   Controller.OutputValues[11]:=StrToIntDef(PartOfStr(Value,12),0)>0;
   Controller.OutputValues[12]:=StrToIntDef(PartOfStr(Value,13),0)>0;
   cbInputDublicateState.Checked:=StrToIntDef(PartOfStr(Value,14),0)>0;
end;

procedure TfrmSuperBio.SetValues(const Value: String);
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
   Controller.InputValues[10]:=StrToIntDef(PartOfStr(Value,11),0)>0;
   Controller.InputValues[11]:=StrToIntDef(PartOfStr(Value,12),0)>0;
   Controller.InputValues[12]:=StrToIntDef(PartOfStr(Value,13),0)>0;
end;

procedure TfrmSuperBio.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
     case cell.Col of
    1..13: begin
         //значени€
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
         end;
       end;
    end;
end;

procedure TfrmSuperBio.gvTableGetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..13: begin
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
         end;
       end;
    end;
end;

// оманда чтени€ состо€ни€
//07:52:57:524) <-- #C0SE9<CR>
//07:52:57:540) --> !C00008000824<CR>
// оманда установки выхода 1 в активное состо€ние
//09:08:12:693) <-- #C011F8<CR>
//09:08:12:708) --> !C094<CR>

function TfrmSuperBio.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  len:integer;
  Addr:byte;
  Status,Control:boolean;
begin
  //провер€ем ответ
  Result := false;
  // ‘ункци€ определ€ет, ответ на какую именно команду провер€етс€, а затем провер€ет его.
  Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
  len:=Length(aCMD);
  if (
      (aCMD[1]='#') and
      (Addr=Controller.Address)
     ) then
   begin
     Status:=((aCMD[4]='S') and (len = 7));
     Control:=(len = 8) and (aCMD[4] in ['0'..'9','A'..'C']) and (aCMD[5] in ['0','1']);
    //длина # + Addr + S +CRC + CR = 7
    //длина # + Addr + N + T + CRC + CR = 8
    if status or control then
       Result := CheckForChkCr(aCMD);
   end;
end;

// оманда чтени€ состо€ни€
//07:52:57:524) <-- #C0SE9<CR>
//07:52:57:540) --> !C00008000824<CR>
// оманда установки выхода 1 в активное состо€ние
//09:08:12:693) <-- #C011F8<CR>
//09:08:12:708) --> !C094<CR>
function TfrmSuperBio.GenerateAnswer: String;
var
   N:byte;
   T:byte;
begin
  if (ReceivedCmd[4]='S') then
      result := AddChkCr('!'+IntToHex(Controller.Address, 2)+IntToHex(Inputs, 4)+IntToHex(Outputs, 4))
  else begin
      //разбираем команду
      N:=StrToInt('$'+ReceivedCmd[4]);
      T:=StrToInt('$'+ReceivedCmd[5]);

      Controller.OutputValues[N]:=T>0;
      if cbInputDublicateState.checked then
         Controller.InputValues[N]:=T>0;
      //формируем ответ
      result := AddChkCr('!'+IntToHex(Controller.Address, 2));
  end;
end;



function TfrmSuperBio.GetInputs: word;
var i:byte;
begin
  result:=0;
  for i:=0 to 12 do
    if Controller.InputValues[i] then
       result:=result+(1 shl i);
end;

function TfrmSuperBio.GetOutputs: word;
var i:byte;
begin
  result:=0;
  for i:=0 to 12 do
    if Controller.OutputValues[i] then
       result:=result+(1 shl i);
end;


function TfrmSuperBio.GetComments: String;
begin
  result:=Format('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',[
         FComments[0],
         FComments[1],
         FComments[2],
         FComments[3],
         FComments[4],
         FComments[5],
         FComments[6],
         FComments[7],
         FComments[8],
         FComments[9],
         FComments[10],
         FComments[11],
         FComments[12]
         ]);
end;

procedure TfrmSuperBio.SetComments(const Value: String);
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
   FComments[10]:=PartOfStr(Value,11);
   FComments[11]:=PartOfStr(Value,12);
   FComments[12]:=PartOfStr(Value,13);
end;

procedure TfrmSuperBio.Update;
begin
  if Assigned(Controller) then
     gvTable.Invalidate;
end;


procedure TfrmSuperBio.gvTableDblClick(Sender: TObject);
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
