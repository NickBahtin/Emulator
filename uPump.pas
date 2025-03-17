unit uPump;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid;

type
  TfrmPump = class(TBaseFrame)
  private
    { Private declarations }
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
  public
    { Public declarations }
  end;

var
  frmPump: TfrmPump;

implementation

{$R *.dfm}

{ TfrmPump }

function TfrmPump.CmdIsValid(aCMD: String): boolean;
begin
  //провер€ем ответ
  Result := false;
  // ‘ункци€ определ€ет, ответ на какую именно команду провер€етс€, а затем провер€ет его.
  Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
  len:=Length(aCMD);
  if (
      (aCMD[1]='#') and
      (Addr=Controller.Address) and
      (aCMD[4] in ['A'..'C','V','s'])
     ) then
   begin
       Result := CheckForChkCr(aCMD);
   end;
end;

function TfrmPump.GenerateAnswer: String;
begin
  //
end;

end.
