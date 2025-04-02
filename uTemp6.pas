unit uTemp6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid, ExtCtrls, StdCtrls, Spin, ComCtrls;

type                                
  TfrmTemp6 = class(TBaseFrame)
    pnl1: TPanel;
    edtAnswerFormat: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    seChannelCount: TSpinEdit;
    cbPreambula: TComboBox;
    procedure gvTemperatureGetCellColors(Sender: TObject; Cell: TGridCell;
      Canvas: TCanvas);
    procedure gvTemperatureGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTemperatureGetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTemperatureSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure Update;override;
    procedure seChannelCountChange(Sender: TObject);
  private
    FComments: array [0..7] of String;
    function GetComments: String;override;
    procedure SetComments(const Value: String);override;
    function  GetParams:String;override;
    function GetValues: String;override;
    procedure SetParams(const Value: String);override;
    procedure SetValues(const Value: String);override;

    { Private declarations }
  public
    //величина девиации по рандому
    RandomCorrectValues: array [0..7] of Single;
    //значения границ имитации
    RandomRanges: array [0..7] of Longint;
    { Public declarations }
    Controller:TModuleTemp6;
  end;

var
  frmTemp6: TfrmTemp6;

implementation

{$R *.dfm}

{ TfTemp6 }

(*
14:47:19:676 COM3 mtTemp6(0x20) <-- #2085<CR>
14:47:19:706 COM3 mtTemp6(0x20) --> >+020.38+020.22+020.38-241.96+000.00+000.002C<CR>
*)
function TfrmTemp6.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  ch1,ch2:char;
begin
  //проверяем ответ
  Result := false;
  // Функция определяет, ответ на какую именно команду проверяется, а затем проверяет его.
  ch1:=chr((Controller.Address SHR $4)+ord('0'));
  ch2:=chr((Controller.Address and $0F)+ord('0'));
  if (
      (aCMD[1]='#') and
      (aCMD[2]=ch1) and
      (aCMD[3]=ch2)
     ) then
   begin
    //длина # + Addr + CRC +CR = 6
    Result := (Length(aCMD) in [6,7]) and (CheckForChkCr(aCMD));
   end;
end;

//>+020.38+020.22+020.38-241.96+000.00+000.002C<CR>
function TfrmTemp6.GenerateAnswer: String;
var i:integer;
    tmpF:Single;
begin
  result:=Format(cbPreambula.Text,[Controller.Address]);
  for i:=0 to seChannelCount.Value-1 do
  begin
    tmpF:=Controller.Temperatures[i]/100+RandomCorrectValues[i];
    if tmpF>0 then
       result:=result+'+'+FormatFloat(edtAnswerFormat.Text,tmpF)
    else
       result:=result+'-'+FormatFloat(edtAnswerFormat.Text,tmpF)
  end;
  result:=AddChkCr(result);
end;

function TfrmTemp6.GetComments: String;
begin
  result:=Format('%s,%s,%s,%s,%s,%s,%s,%s',[
         FComments[0],
         FComments[1],
         FComments[2],
         FComments[3],
         FComments[4],
         FComments[5],
         FComments[6],
         FComments[7]
         ]);
end;

function TfrmTemp6.GetParams: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%s,%d',[
         RandomRanges[0],
         RandomRanges[1],
         RandomRanges[2],
         RandomRanges[3],
         RandomRanges[4],
         RandomRanges[5],
         RandomRanges[6],
         RandomRanges[7],
         seChannelCount.value,
         edtAnswerFormat.text,
         cbPreambula.ItemIndex
         ]);
end;


function TfrmTemp6.GetValues: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d',[
         Controller.Temperatures[0],
         Controller.Temperatures[1],
         Controller.Temperatures[2],
         Controller.Temperatures[3],
         Controller.Temperatures[4],
         Controller.Temperatures[5],
         Controller.Temperatures[6],
         Controller.Temperatures[7]
         ])
end;

procedure TfrmTemp6.gvTemperatureGetCellColors(Sender: TObject;
  Cell: TGridCell; Canvas: TCanvas);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..8: begin
         //значения
         case cell.Row of
         0: begin
              if Controller.Temperatures[cell.Col-1]>10 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
         1:
            Canvas.Font.Color:=clBlack;
         2:
            Canvas.Font.Color:=clGray;
         end;
       end;
    end;

end;

procedure TfrmTemp6.gvTemperatureGetCellText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         Value:=gvParamNames[cell.Row];
       end;
    1..6: begin
         //значения
         case cell.Row of
         0: begin
              Value:=Format('%f',[Controller.Temperatures[cell.Col-1]/100+RandomCorrectValues[
                cell.Col-1]]);
            end;
         1: begin
              Value:=Format('%d',[RandomRanges[cell.Col-1]]);
            end;
         2: begin
              Value:=FComments[cell.Col-1];
            end;
         end;
       end;
    end;
end;

procedure TfrmTemp6.gvTemperatureGetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..6: begin
         //значения
         case cell.Row of
         0: begin
              Value:=Format('%f',[Controller.Temperatures[cell.Col-1]/100]);
            end;
         1: begin
              Value:=Format('%d',[RandomRanges[cell.Col-1]]);
            end;
         2: begin
              Value:=FComments[cell.Col-1];
            end;
         end;
       end;
    end;
end;

procedure TfrmTemp6.gvTemperatureSetEditText(Sender: TObject;
  Cell: TGridCell; var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..6: begin
         //значения
         case cell.Row of
         0: begin
              Controller.Temperatures[cell.Col-1]:=Round(StrToFloatDef(Value,0)*100);
            end;
         1: begin
              RandomRanges[cell.Col-1]:=StrToIntDef(Value,0);
            end;
         2: begin
              FComments[cell.Col-1]:=Value;
            end;
         end;
       end;
    end;
end;

procedure TfrmTemp6.SetComments(const Value: String);
begin
   FComments[0]:=PartOfStr(Value,1);
   FComments[1]:=PartOfStr(Value,2);
   FComments[2]:=PartOfStr(Value,3);
   FComments[3]:=PartOfStr(Value,4);
   FComments[4]:=PartOfStr(Value,5);
   FComments[5]:=PartOfStr(Value,6);
   FComments[6]:=PartOfStr(Value,7);
   FComments[7]:=PartOfStr(Value,8);
end;

procedure TfrmTemp6.SetParams(const Value: String);
begin
   RandomRanges[0]:=StrToIntDef(PartOfStr(Value,1),0);
   RandomRanges[1]:=StrToIntDef(PartOfStr(Value,2),0);
   RandomRanges[2]:=StrToIntDef(PartOfStr(Value,3),0);
   RandomRanges[3]:=StrToIntDef(PartOfStr(Value,4),0);
   RandomRanges[4]:=StrToIntDef(PartOfStr(Value,5),0);
   RandomRanges[5]:=StrToIntDef(PartOfStr(Value,6),0);
   RandomRanges[6]:=StrToIntDef(PartOfStr(Value,7),0);
   RandomRanges[7]:=StrToIntDef(PartOfStr(Value,8),0);
   seChannelCount.value:=StrToIntDef(PartOfStr(Value,9),6);
   edtAnswerFormat.text:=PartOfStr(Value,10);
   cbPreambula.ItemIndex:=StrToIntDef(PartOfStr(Value,11),0);

end;


procedure TfrmTemp6.SetValues(const Value: String);
begin
   Controller.Temperatures[0]:=StrToIntDef(PartOfStr(Value,1),0);
   Controller.Temperatures[1]:=StrToIntDef(PartOfStr(Value,2),0);
   Controller.Temperatures[2]:=StrToIntDef(PartOfStr(Value,3),0);
   Controller.Temperatures[3]:=StrToIntDef(PartOfStr(Value,4),0);
   Controller.Temperatures[4]:=StrToIntDef(PartOfStr(Value,5),0);
   Controller.Temperatures[5]:=StrToIntDef(PartOfStr(Value,6),0);
   Controller.Temperatures[6]:=StrToIntDef(PartOfStr(Value,7),0);
   Controller.Temperatures[7]:=StrToIntDef(PartOfStr(Value,8),0);
end;


procedure TfrmTemp6.Update;
var i:integer;
begin
  if Assigned(Controller) then
  begin
    for i:=0 to seChannelCount.Value-1 do
      RandomCorrectValues[i]:=Random(RandomRanges[i])/100;
    gvTable.Invalidate;
  end;
end;

procedure TfrmTemp6.seChannelCountChange(Sender: TObject);
var i:integer;
begin
  inherited;
  for i:=1 to 8 do
  begin
      if i<=seChannelCount.Value then
         gvTable.Columns[i].DefWidth:=40
      else
         gvTable.Columns[i].DefWidth:=0;
  end;
end;

end.
