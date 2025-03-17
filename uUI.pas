unit uUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,
  Helper,
  Dialogs, uBaseFrame, Ex_Grid, ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmUI = class(TBaseFrame)
    Panel1: TPanel;
    cbOldFormat: TCheckBox;
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
    FComments: array [0..7] of String;
    function GetComments: String;override;
    procedure SetComments(const Value: String);override;
    function  GetParams:String;override;
    function GetValues: String;override;
    procedure SetParams(const Value: String);override;
    procedure SetValues(const Value: String);override;

    { Private declarations }
  public
    { Public declarations }
    //величина девиации по рандому
    RandomCorrectValues: array [0..7] of Single;
    //значения границ имитации
    RandomRanges: array [0..7] of Longint;
    controller:TModuleUI;
  end;

var
  frmUI: TfrmUI;

implementation

{$R *.dfm}

{ TfrmUI }

function TfrmUI.GetParams: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d',[
         RandomRanges[0],
         RandomRanges[1],
         RandomRanges[2],
         RandomRanges[3],
         RandomRanges[4],
         RandomRanges[5],
         RandomRanges[6],
         RandomRanges[7],
         ord(cbOldFormat.Checked)
         ]);
end;

function TfrmUI.GetValues: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d',[
         Controller.InputValues[0],
         Controller.InputValues[1],
         Controller.InputValues[2],
         Controller.InputValues[3],
         Controller.InputValues[4],
         Controller.InputValues[5],
         Controller.InputValues[6],
         Controller.InputValues[7]
         ])
end;

procedure TfrmUI.SetParams(const Value: String);
begin
   RandomRanges[0]:=StrToIntDef(PartOfStr(Value,1),0);
   RandomRanges[1]:=StrToIntDef(PartOfStr(Value,2),0);
   RandomRanges[2]:=StrToIntDef(PartOfStr(Value,3),0);
   RandomRanges[3]:=StrToIntDef(PartOfStr(Value,4),0);
   RandomRanges[4]:=StrToIntDef(PartOfStr(Value,5),0);
   RandomRanges[5]:=StrToIntDef(PartOfStr(Value,6),0);
   RandomRanges[6]:=StrToIntDef(PartOfStr(Value,7),0);
   RandomRanges[7]:=StrToIntDef(PartOfStr(Value,8),0);
   cbOldFormat.Checked:=StrToIntDef(PartOfStr(Value,9),0)>0;
end;

procedure TfrmUI.SetValues(const Value: String);
begin
   Controller.InputValues[0]:=StrToIntDef(PartOfStr(Value,1),0);
   Controller.InputValues[1]:=StrToIntDef(PartOfStr(Value,2),0);
   Controller.InputValues[2]:=StrToIntDef(PartOfStr(Value,3),0);
   Controller.InputValues[3]:=StrToIntDef(PartOfStr(Value,4),0);
   Controller.InputValues[4]:=StrToIntDef(PartOfStr(Value,5),0);
   Controller.InputValues[5]:=StrToIntDef(PartOfStr(Value,6),0);
   Controller.InputValues[6]:=StrToIntDef(PartOfStr(Value,7),0);
   Controller.InputValues[7]:=StrToIntDef(PartOfStr(Value,8),0);
end;

procedure TfrmUI.gvTableGetCellColors(Sender: TObject; Cell: TGridCell;
  Canvas: TCanvas);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..8: begin
         //значения
         case cell.Row of
         0: begin
              if Controller.InputValues[cell.Col-1]>10 then
                Canvas.Font.Color:=clGreen
              else
                Canvas.Font.Color:=clBlack;
            end;
          1: Canvas.Font.Color:=clBlack;
          2: Canvas.Font.Color:=clGray;
         end;
       end;
    end;
end;

procedure TfrmUI.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    0: begin
         //название параметров
         Value:=gvParamNames[cell.Row];
       end;
    1..8: begin
         //значения
         case cell.Row of
         0: begin
              Value:=Format('%f',[Controller.InputValues[cell.Col-1]/100+RandomCorrectValues[
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

procedure TfrmUI.gvTableGetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..8: begin
         //значения
         case cell.Row of
         0: begin
              Value:=Format('%f',[Controller.InputValues[cell.Col-1]/100]);
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

procedure TfrmUI.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    if Assigned(Controller) then
    case cell.Col of
    1..8: begin
         //значения
         case cell.Row of
         0: begin
              Controller.InputValues[cell.Col-1]:=Round(StrToFloatDef(Value,0)*100);
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

function TfrmUI.CmdIsValid(aCMD: String): boolean;
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
    Result := (Length(aCMD) = 6) and (CheckForChkCr(aCMD));
   end;
end;

// новый
//>+00.0000+00.0001+00.0002+00.0003+04.1521+04.0011+00.0003+00.000325<CR>
// InputValues[i] := StrToInt(Copy(response, 2 + i*8, 3))*10000 + StrToInt(Copy(response, 6 + i*8, 4));
//  старый
// InputValues[7-i] := StrToInt(Copy(response, 2 + i*7, 3))*1000 + StrToInt(Copy(response, 6 + i*7, 3)); oldUI
//>+00.000+00.000+04.072+04.042+00.000+00.000+00.000+00.0009D<CR>
function TfrmUI.GenerateAnswer: String;
var i:integer;
    tmpF:Single;
begin
  result:='>';
  for i:=0 to 7 do
  begin
    tmpF:=Controller.InputValues[i]/100+RandomCorrectValues[i];
    if cbOldFormat.Checked then
    begin
      //старый формат
      if tmpF>0 then
         result:=result+'+'+FormatFloat('00.000',tmpF)
      else
         result:=result+'-'+FormatFloat('00.000',tmpF);
    end
    else begin
      //новый формат
      if tmpF>0 then
         result:=result+'+'+FormatFloat('00.0000',tmpF)
      else
         result:=result+'-'+FormatFloat('00.0000',tmpF);
    end
  end;
  result:=AddChkCr(result);
end;

function TfrmUI.GetComments: String;
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

procedure TfrmUI.SetComments(const Value: String);
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

procedure TfrmUI.Update;
var i:integer;
begin
    if Assigned(Controller) then
    begin
      for i:=0 to 7 do
        RandomCorrectValues[i]:=Random(RandomRanges[i])/100;
      gvTable.Invalidate;
    end;
end;

end.
