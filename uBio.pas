unit uBio;

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
  TfrmBio = class(TBaseFrame)
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
    FComments: array [0..1] of String;
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
    Controller:TModuleBIO;
    property Inputs:word read GetInputs;
    property Outputs:word read GetOutputs;

  end;

var
  frmBio: TfrmBio;

implementation

{$R *.dfm}

function TfrmBio.GetParams: String;
begin
  result:=Format('%d,%d,%d',[
         Ord(Controller.OutputValues[0]),
         Ord(Controller.OutputValues[1]),
         ord(cbInputDublicateState.Checked)
         ])
end;

function TfrmBio.GetValues: String;
begin
  result:=Format('%d,%d',[
         Ord(Controller.InputValues[0]),
         Ord(Controller.InputValues[1])
         ])
end;

procedure TfrmBio.gvTableGetCellColors(Sender: TObject;
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

procedure TfrmBio.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         if cell.Row in [0..2] then
         Value:=gvPnevmoParamNames[cell.Row];
       end;
    1..2: begin
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

procedure TfrmBio.SetParams(const Value: String);
begin
   Controller.OutputValues[0]:=StrToIntDef(PartOfStr(Value,1),0)>0;
   Controller.OutputValues[1]:=StrToIntDef(PartOfStr(Value,2),0)>0;
   cbInputDublicateState.Checked:=StrToIntDef(PartOfStr(Value,14),0)>0;
end;

procedure TfrmBio.SetValues(const Value: String);
begin
   Controller.InputValues[0]:=StrToIntDef(PartOfStr(Value,1),0)>0;
   Controller.InputValues[1]:=StrToIntDef(PartOfStr(Value,2),0)>0;
end;

procedure TfrmBio.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
     case cell.Col of
    1..2: begin
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

procedure TfrmBio.gvTableGetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..2: begin
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

function TfrmBio.CmdIsValid(aCMD: String): boolean;
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
     Status:=((aCMD[4]='S') and (len >= 7));
     Control:=(len >= 8) and (aCMD[4] in ['0'..'9','A'..'C','S']) and (aCMD[5] in ['0','1']);
    //длина # + Addr + S +CRC + CR = 7
    //длина # + Addr + N + T + CRC + CR = 8
    if status or control then
       Result := CheckForChkCr(aCMD)
    else
       Result := False;
   end;
end;

// оманда чтени€ состо€ни€
//07:52:57:524) <-- #C0SE9<CR>
//07:52:57:540) --> !C00008000824<CR>
//#A3SEA
//!A35CA
// оманда установки выхода 1 в активное состо€ние
//09:08:12:693) <-- #C011F8<CR>
//09:08:12:708) --> !C094<CR>
function TfrmBio.GenerateAnswer: String;
var
   N:byte;
   T:byte;
begin
  if (ReceivedCmd[4]='S') then
      result := AddChkCr('!'+IntToHex(Controller.Address, 2)+IntToHex((Outputs and $03)+(((Inputs and 3)shl 2)), 1))
  else begin
      //разбираем команду
      N:=StrToInt('$'+ReceivedCmd[4])-10; //B=0 //A=1
      T:=StrToInt('$'+ReceivedCmd[5]);

      Controller.OutputValues[N]:=T>0;
      if cbInputDublicateState.checked then
         Controller.InputValues[N]:=T>0;
      //формируем ответ
      result := AddChkCr('!'+IntToHex(Controller.Address, 2));
  end;
end;



function TfrmBio.GetInputs: word;
var i:byte;
begin
  result:=0;
  if Controller.InputValues[0] then result:=result or 2;
  if Controller.InputValues[1] then result:=result or 1;
end;

function TfrmBio.GetOutputs: word;
var i:byte;
begin
  result:=0;
  if Controller.OutputValues[0] then result:=result or 2;
  if Controller.OutputValues[1] then result:=result or 1;
end;


function TfrmBio.GetComments: String;
begin
  result:=Format('%s,%s',[
         FComments[0],
         FComments[1]
         ]);
end;

procedure TfrmBio.SetComments(const Value: String);
begin
   FComments[0]:=PartOfStr(Value,1);
   FComments[1]:=PartOfStr(Value,2);
end;

procedure TfrmBio.Update;
begin
  if Assigned(Controller) then
     gvTable.Invalidate;
end;


procedure TfrmBio.gvTableDblClick(Sender: TObject);
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
