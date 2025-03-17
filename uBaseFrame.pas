unit uBaseFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,uProcedures,
  Dialogs, Ex_Grid, ComCtrls;

const
  gvParamNames:array[0..2] of String=(
  'Входы',
  'Девиация',
  'Привязка'
  );
type
  TBaseFrame = class(TFrame)
    gvTable: TGridView;
    sbIO: TStatusBar;
    function  GetParams:String;virtual;abstract;
    procedure SetParams(const Value: String);virtual;abstract;
    function GetValues: String;virtual;abstract;
    procedure SetValues(const Value: String);virtual;abstract;
    procedure SetReceivedCmd(const Value: String);
    function GenerateAnswer: String;virtual;
    function GetComments: String;virtual;
    procedure SetComments(const Value: String);virtual;abstract;
    procedure gvTableCellClick(Sender: TObject; Cell: TGridCell;
      Shift: TShiftState; X, Y: Integer);
  private
    FAnswer:String;
    FReceivedCmd: String;
    FOnAnswerReceived: TAnswerReceiveEvent;
    FSelectedCell: TGridCell;
    FDisassembled: Boolean;
    procedure SetAnswer(const Value: String);
    procedure SetSelectedCell(const Value: TGridCell);
    procedure SetDisassembled(const Value: Boolean);
    { Private declarations }
  public
    procedure Update;virtual;
    function CmdIsValid(aCMD: String): boolean;virtual;
    property Params:String read GetParams write SetParams;
    property Values:String read GetValues write SetValues;
    property Comments:String read GetComments write SetComments;
    property ReceivedCmd:String read FReceivedCmd write SetReceivedCmd;
    property OnAnswerReceived:TAnswerReceiveEvent read FOnAnswerReceived write FOnAnswerReceived;
    property Answer:String read FAnswer write SetAnswer;
    property SelectedCell:TGridCell read FSelectedCell write SetSelectedCell;
    property Disassembled:Boolean read FDisassembled write SetDisassembled;

  end;

implementation

uses
  uCHILDWIN, uMAIN;

{$R *.dfm}

procedure TBaseFrame.SetReceivedCmd(const Value: String);
begin
  FReceivedCmd := Value;
  try
    sbIO.Panels[0].Text:=TimeToStr(Now);
    sbIO.Panels[1].Text:=Value;
    //сформировать ответ
    //и сгенерить событие с ответным сообщением
    Disassembled:=True;
    Answer:=GenerateAnswer();
  except
    on e:exception do
    begin
       MainForm.ToTerminal('Ошибка:'+e.message,[fsBold,fsItalic],clRed);
    end;
  end;
end;


function TBaseFrame.CmdIsValid(aCMD: String): boolean;
begin
  result:=False;
end;

function TBaseFrame.GenerateAnswer: String;
begin
  result:='';
end;



procedure TBaseFrame.SetAnswer(const Value: String);
begin
  FAnswer := Value;
  sbIO.Panels[0].Text:=TimeToStr(Now);
  sbIO.Panels[2].Text:=Value;
  if Assigned(OnAnswerReceived) then
     OnAnswerReceived(self,Value);
end;

function TBaseFrame.GetComments: String;
begin
  result:='';
end;





procedure TBaseFrame.gvTableCellClick(Sender: TObject; Cell: TGridCell;
  Shift: TShiftState; X, Y: Integer);
begin
   FSelectedCell:=Cell;
end;

procedure TBaseFrame.SetSelectedCell(const Value: TGridCell);
begin
  FSelectedCell := Value;
end;

procedure TBaseFrame.Update;
begin
  gvTable.Invalidate;
end;

procedure TBaseFrame.SetDisassembled(const Value: Boolean);
begin
  FDisassembled := Value;
  if Value then
  begin
    sbIO.Color:=clMoneyGreen;
  end
  else begin
    sbIO.Color:=clBtnFace;
  end;

end;

end.
