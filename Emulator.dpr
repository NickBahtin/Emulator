program Emulator;

uses
  Forms,
  uMAIN in 'uMAIN.pas' {MainForm},
  uCHILDWIN in 'uCHILDWIN.pas' {MDIChild},
  uAbout in 'uAbout.pas' {AboutForm},
  uBaseFrame in 'uBaseFrame.pas' {BaseFrame: TFrame},
  uTemp6 in 'uTemp6.pas' {frmTemp6: TFrame},
  uUI in 'uUI.pas' {frmUI: TFrame},
  uSuperBio in 'uSuperBio.pas' {frmSuperBio: TFrame},
  uValve in 'uValve.pas' {frmValve: TFrame},
  uBalance in 'uBalance.pas' {frmBalance: TFrame},
  uFCD in 'uFCD.pas' {frmFCD: TFrame},
  uCounterX in 'uCounterX.pas' {frmCounterX: TFrame},
  uVLT600 in 'uVLT600.pas' {fVLT6000: TFrame},
  uCounter in 'uCounter.pas' {frmCounter: TFrame},
  uBio in 'uBio.pas' {frmBio: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
