unit uCHILDWIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ComCtrls, Spin,
  Helper,uMain,Dialogs,
  ClipBrd,
  ExtCtrls, Ex_Grid,OoMisc, Buttons, ToolWin,
  CPortCtl, CPort, Messages,
  Modules, DateUtils,uAbout,
  RichEdit, Menus, RxRichEd, uBaseFrame,uUI, uTemp6, uSuperBio, uBio, HexEdits,
  KbdHelper,
  uValve, uBalance, uFCD, uCounterX, uVLT600, uCounter;
(*
'mtCounter','mtCounterEx','mtFCD',
   'mtFCD2','mtProver','mtScales','mtScalesMT','mtSuperBIO','mtT','mtTemp2','mtTemp6','mtUI',
   'mtOldUI','mtValve','mtVLT6000','mtATV312','mtDAC_I702X','mtWarm','mtPrem','mtFastwelUI','mtVirt',
   'mtIVTM','mtHeat', 'mtAgat','mtSWITCH','mtTEXT','mtKM5','mtRT2','mtVLTModbus

*)



type
  //��� ����������� � pcControllers
  TEmulModuleType = (emtCounter, emtCounterEx,emtFCD2, emtScales,emtSuperBIO, emtTemp6, emtUI,
    emtValve, emtVLT6000,emtIVTM, emtKM5,emtRT2,emtBIO);

  //����� ����
  TEmulMode = (emController, emTerminal);

  TMDIChild = class(TForm)
    pcMain: TPageControl;
    TabSheet1: TTabSheet;
    pcControllers: TPageControl;
    tsCounter: TTabSheet;
    tsCounterEx: TTabSheet;
    tsFCD2: TTabSheet;
    tsScales: TTabSheet;
    tsSuperBIO: TTabSheet;
    tsTemp6: TTabSheet;
    tsUI: TTabSheet;
    tsValve: TTabSheet;
    tsVLT600: TTabSheet;
    tsIVTM: TTabSheet;
    tsKM5: TTabSheet;
    tsRT2: TTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    cbTypeOfController: TComboBox;
    TabSheet2: TTabSheet;
    ToolBar2: TToolBar;
    tbOpenPort: TToolButton;
    tbClosePort: TToolButton;
    tbSetupPort: TToolButton;
    pnlSend: TPanel;
    CRBtn: TSpeedButton;
    LFBtn: TSpeedButton;
    edtSend: TEdit;
    btnSend: TButton;
    ComPort1: TComPort;
    ToolButton1: TToolButton;
    ComTerminal: TRxRichEdit;
    tbSaveLog: TToolButton;
    ToolButton3: TToolButton;
    SaveDialog1: TSaveDialog;
    tbCleatLog: TToolButton;
    fTemp6: TfrmTemp6;
    fUI: TfrmUI;
    fSuperBio: TfrmSuperBio;
    tbSUMM: TToolButton;
    tbSUMM16: TToolButton;
    tbSUMMKM: TToolButton;
    tbSummMB: TToolButton;
    Label1: TLabel;
    seNetAddr: THexEdit;
    fValve: TfrmValve;
    fScales: TfrmBalance;
    fFCD: TfrmFCD;
    fCounterEx: TfrmCounterX;
    fVLT6000: TfVLT6000;
    fCounter: TfrmCounter;
    sMacros: TSplitter;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    gbMacros: TGroupBox;
    lbMacros: TListBox;
    ToolButton2: TToolButton;
    HEXBtn: TToolButton;
    ScrollBtn: TToolButton;
    DopInfoBtn: TToolButton;
    StatusBar1: TStatusBar;
    edtMacros: TEdit;
    tsBIO: TTabSheet;
    fBIO: TfrmBio;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbTypeOfControllerChange(Sender: TObject);
    procedure seNetAddrChange(Sender: TObject);
    procedure tbOpenPortClick(Sender: TObject);
    procedure tbSetupPortClick(Sender: TObject);
    procedure tbClosePortClick(Sender: TObject);
    procedure ComPort1AfterOpen(Sender: TObject);
    procedure ComPort1AfterClose(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure tbSaveLogClick(Sender: TObject);
    procedure tbCleatLogClick(Sender: TObject);
    procedure tbSUMMClick(Sender: TObject);
    procedure ComPort1Error(Sender: TObject; Errors: TComErrors);
    procedure ComPort1Exception(Sender: TObject;
      TComException: TComExceptions; ComportMessage: String;
      WinError: Int64; WinMessage: String);
    procedure HEXBtnClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure lbMacrosDblClick(Sender: TObject);
    procedure lbMacrosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbMacrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sMacrosCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure edtMacrosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtMacrosExit(Sender: TObject);
    procedure edtMacrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    CounterModule:TModuleCounter;
    CounterExModule:TModuleCounterEx;
    PnevmoModule:TModuleSuperBIO;
    BIOModule:TModuleBIO;
    ElectroModule:TModuleValve;
    AnalogModule:TModuleUI;
    AnalogModuleOld:TModuleOldUI;
    ScalesModule:TModuleScales;
    FCDModule:TModuleFCD2;
    AgatModule:TModuleAgat;
    FValues: String;
    FSettings: String;
    FParams: String;
    FMode: integer;
    FReceivedCmd: String;
    FComments: String;
    procedure SetParams(const Value: String);
    procedure SetSettings(const Value: String);
    procedure SetValues(const Value: String);
    procedure SetMode(const Value: integer);
    procedure UpdateConsole;
    function GetPortNumber: integer;
    procedure SetReceivedCmd(const Value: String);
    procedure CheckScroll;
    procedure ToTerminal(const Value: String;Attr:TFontStyles;AColor:TColor=clBlack);
    procedure SetComments(const Value: String);
    procedure SendCMD(Value: String);
    procedure DoMoveListItem(AKind: Boolean);
    function lbMacrosSelectedIndex: integer;
  public
    { Public declarations }
    procedure WMDeviceChange();
    function CmdIsValid(const Value: String):boolean;
    procedure Update(Sender: TObject);
    procedure DoAnswerReceived(Sender: TObject; const Value: String);
    procedure UpdateSettings;
    procedure DisassembleSettings;
    procedure UpdateValues;
    procedure DisassembleValues;
    procedure UpdateParams;
    procedure UpdateComments;
    procedure DisassembleParams;
    procedure DisassembleComments;
    property Mode:integer read FMode write SetMode;
    property Settings:String read FSettings write SetSettings;//����� ���������
    property Values:String read FValues write SetValues;//��������
    property Params:String read FParams write SetParams;//���. ���������
    property Comments:String read FComments write SetComments;//��������
    property PortNumber:integer read GetPortNumber;
//    property ReceivedCmd:String read FReceivedCmd write SetReceivedCmd;//�������� �������
  end;

implementation

{$R *.dfm}

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  ComPort1.Close;
end;

procedure TMDIChild.FormCreate(Sender: TObject);
var i:integer;
begin
  //�������� ��� �������� ����������
  for i:=0 to pcControllers.PageCount-1 do
  begin
    pcControllers.Pages[i].TabVisible:=False;
  end;
  for i:=0 to pcMain.PageCount-1 do
  begin
    pcMain.Pages[i].TabVisible:=False;
  end;
  fTemp6.Controller:=TModuleTemp6.Create($20,115200,nil);
  fTemp6.OnAnswerReceived:=DoAnswerReceived;
  fUI.Controller:=TModuleUI.Create($04,115200,nil);
  fUI.OnAnswerReceived:=DoAnswerReceived;
  fSuperBio.Controller:=TModuleSuperBIO.Create($C0,115200,nil);
  fSuperBio.OnAnswerReceived:=DoAnswerReceived;
  fBio.Controller:=TModuleBIO.Create($A0,115200,nil);
  fBio.OnAnswerReceived:=DoAnswerReceived;
  fValve.Controller:=TModuleValve.Create($50,115200,nil);
  fValve.OnAnswerReceived:=DoAnswerReceived;
  fScales.Controller:=TModuleScales.Create($80,38400,nil);
  fScales.OnAnswerReceived:=DoAnswerReceived;
  fFCD.Controller:=TModuleFCD2.Create($90,38400,nil);
  fFCD.OnAnswerReceived:=DoAnswerReceived;
  fCounterEx.Controller:=TModuleCounterEx.Create($0001,115200,nil);
  fCounterEx.OnAnswerReceived:=DoAnswerReceived;
  fCounter.Controller:=TModuleCounter.Create($01,115200,nil);
  fCounter.OnAnswerReceived:=DoAnswerReceived;
  fVLT6000.Controller:=TModuleVLT6000.Create($01,9600,nil);
  fVLT6000.OnAnswerReceived:=DoAnswerReceived;
  SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
end;

procedure TMDIChild.cbTypeOfControllerChange(Sender: TObject);
begin
  //��������� ����������
  if not (TEmulModuleType(cbTypeOfController.ItemIndex)
     in [emtCounter,emtCounterEx,emtScales,emtValve,emtSuperBio,emtBio,emtTemp6, emtUI,emtFCD2,emtVLT6000]) then
  begin
     cbTypeOfController.ItemIndex:=ord(emtTemp6);
     Application.MessageBox('������ ��� ������� ����������',
       '��� �����������', MB_OK + MB_ICONWARNING);
  end;
  pcControllers.ActivePageIndex:=cbTypeOfController.ItemIndex;
  Caption:=pcControllers.ActivePage.Caption+' (0x'+IntToHex(Self.seNetAddr.Value,2)+')';
end;

procedure TMDIChild.seNetAddrChange(Sender: TObject);
begin
  try
    if seNetAddr.Value<>0 then
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtTemp6: begin
        if Assigned(fTemp6.Controller) then
           fTemp6.Controller.Address:=seNetAddr.Value;
       end;
    emtUI:begin
        if Assigned(fUI.Controller) then
           fUI.Controller.Address:=seNetAddr.Value;
       end;
    emtSuperBIO:begin
        if Assigned(fSuperBio.Controller) then
           fSuperBio.Controller.Address:=seNetAddr.Value;
       end;
    emtBIO:begin
        if Assigned(fBio.Controller) then
           fBio.Controller.Address:=seNetAddr.Value;
       end;
    emtValve:begin
        if Assigned(fValve.Controller) then
           fValve.Controller.Address:=seNetAddr.Value;
       end;
    emtScales:begin
        if Assigned(fScales.Controller) then
           fScales.Controller.Address:=seNetAddr.Value;
       end;
    emtFCD2:begin
        if Assigned(fFCD.Controller) then
           fFCD.Controller.Address:=seNetAddr.Value;
       end;
    emtCounterEx:begin
        if Assigned(fCounterEx.Controller) then
           fCounterEx.Controller.Address:=seNetAddr.Value;
       end;
    emtCounter:begin
        if Assigned(fCounter.Controller) then
           fCounter.Controller.Address:=seNetAddr.Value;
       end;
    emtVLT6000:begin
        if Assigned(fVLT6000.Controller) then
           fVLT6000.Controller.Address:=seNetAddr.Value;
       end;
    end;
  finally
  end;
end;

procedure TMDIChild.Update(Sender: TObject);
var i:Integer;
begin
  case TEmulModuleType(cbTypeOfController.ItemIndex) of
  emtTemp6: begin
              if Assigned(fTemp6) then
                 fTemp6.Update;
            end;
  emtUI:    begin
              if Assigned(fUI) then
                 fUI.Update;
            end;
  emtSuperBIO:    begin
              if Assigned(fSuperBio) then
                 fSuperBio.Update;
            end;
  emtBIO:    begin
              if Assigned(fBio) then
                 fBio.Update;
            end;
  emtValve:    begin
              if Assigned(fValve) then
                 fValve.Update;
            end;
  emtScales:begin
              if Assigned(fScales) then
                 fScales.Update;
            end;
  emtFCD2:begin
              if Assigned(fFCD) then
                 fFCD.Update;
            end;
  emtCounterEx:begin
            if Assigned(fCounterEx) then
               fCounterEx.Update;
            end;
  emtCounter:begin
            if Assigned(fCounterEx) then
               fCounter.Update;
            end;
  emtVLT6000:begin
        if Assigned(fVLT6000.Controller) then
           fVLT6000.Update;
       end;
  end;

end;

procedure TMDIChild.SetParams(const Value: String);
begin
  FParams := Value;
  DisassembleParams();
end;

procedure TMDIChild.SetSettings(const Value: String);
begin
  FSettings := Value;
  DisassembleSettings();
end;

procedure TMDIChild.SetValues(const Value: String);
begin
  FValues := Value;
  DisassembleValues();
end;

procedure TMDIChild.UpdateParams;
begin
  FParams:='';
  case TEmulModuleType(cbTypeOfController.ItemIndex) of
  emtTemp6: begin
         FParams:=fTemp6.Params;
     end;
  emtUI: begin
         FParams:=fUI.Params;
     end;
  emtSuperBIO: begin
         FParams:=fSuperBio.Params;
     end;
  emtBIO: begin
         FParams:=fBio.Params;
     end;
  emtValve: begin
         FParams:=fValve.Params;
     end;
  emtScales: begin
         FParams:=fScales.Params;
     end;
//  emtFCD2: begin
//         FParams:=fFCD.Params;
//     end;
  emtCounterEx:begin
               FParams:=fCounterEx.Params;
     end;
  emtCounter:begin
               FParams:=fCounter.Params;
     end;
  end;
end;

procedure TMDIChild.UpdateSettings;
var i:integer;
begin
  //���, �����, ������ ����, ������ ����

  case Mode of
  0: FSettings:=Format('%d,%d,%d,%d,%d,%d,%d',[Mode,cbTypeOfController.ItemIndex,seNetAddr.Value,Width,Height,Left,Top]);
  1: begin

      if ComPort1.Connected then i:=1 else i:=0;
      if HexBtn.Down then i:=i+2;
      if CRBtn.Down then i:=i+4;
      if LFBtn.Down then i:=i+8;
      if ScrollBtn.Down then i:=i+16;
      if DopInfoBtn.Down then i:=i+32;
      FSettings:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',[Mode,PortNumber,ord(ComPort1.BaudRate),Width,Height,Left,
        Top,ord(ComPort1.Parity.Bits),ord(ComPort1.StopBits),ord(ComPort1.DataBits),i]);
     end;
  end;
end;

(*
��������        0
����� ��������  1
���             2
����            3
���������� ����� ������ 4
������������� ����� (Temp6) 5
���������� ����� (���/����������) 6
��������������� 7
�������� ������� 8
����             9
��5              10
��2/��2�         11
*)
procedure TMDIChild.UpdateValues;
  var i:integer;
begin
  FValues:='';
  case Mode of
  0:
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtTemp6: begin
           FValues:=fTemp6.Values;
       end;
    emtUI: begin
           FValues:=fUI.Values;
       end;
    emtSuperBIO: begin
           FValues:=fSuperBio.Values;
       end;
    emtBIO: begin
           FValues:=fBio.Values;
       end;
    emtValve: begin
           FValues:=fValve.Values;
       end;
    emtScales: begin
           FValues:=fScales.Values;
       end;
   emtCounterEx:begin
           FValues:=fCounterEx.Values;
       end;
   emtCounter:begin
           FValues:=fCounter.Values;
       end;
   //  emtFCD2: begin
  //         FValues:=fFCD.Values;
  //     end;
    end;
  1:begin
      if lbMacros.items.count>0 then
      begin
         FValues:=IntToStr(lbMacros.items.count)+',';
         for i:=0 to lbMacros.items.count-1 do
          begin
            FValues:=FValues+lbMacros.Items[i]+',';
          end;
      end;
    end;
  end;
end;

procedure TMDIChild.DisassembleParams;
begin
  case TEmulModuleType(cbTypeOfController.ItemIndex) of
  emtTemp6: begin
       fTemp6.Params:=Params;
     end;
  emtUI: begin
       fUI.Params:=Params;
     end;
  emtSuperBIO: begin
       fSuperBio.Params:=Params;
     end;
  emtBIO: begin
       fBio.Params:=Params;
     end;
  emtValve: begin
       fValve.Params:=Params;
     end;
  emtScales: begin
       fScales.Params:=Params;
     end;
 emtCounterEx:begin
        fCounterEx.Params:=Params;
     end;
 emtCounter:begin
        fCounter.Params:=Params;
     end;
//  emtFCD2: begin
//       fFCD.Params:=Params;
//     end;
  end;
end;

procedure TMDIChild.DisassembleSettings;
var
    W,H,L,T:integer;
begin
  Mode:=StrToIntDef(PartOfStr(FSettings,1),0);
  case TEmulMode(mode) of
  emController: begin
    cbTypeOfController.ItemIndex:=StrToIntDef(PartOfStr(FSettings,2),0);
    seNetAddr.Value:=StrToIntDef(PartOfStr(FSettings,3),1);
    cbTypeOfControllerChange(nil);
    seNetAddrChange(nil);
    end;
  emTerminal: begin
    ComPort1.Port:='COM'+PartOfStr(FSettings,2);
    ComPort1.BaudRate:=TBaudRate(StrToIntDef(PartOfStr(FSettings,3),0));
    ComPort1.Parity.Bits:=TParityBits(StrToIntDef(PartOfStr(FSettings,8),0));
    ComPort1.StopBits:=TStopBits(StrToIntDef(PartOfStr(FSettings,9),0));
    ComPort1.DataBits:=TDataBits(StrToIntDef(PartOfStr(FSettings,10),0));
    T:=StrToIntDef(PartOfStr(FSettings,11),0);
    try
      if (T and 1)=1 then  ComPort1.Open;
    finally

    end;
    HexBtn.Down:=(T and 2)=2;
    CRBtn.Down:=(T and 4)=4;
    LFBtn.Down:=(T and 8)=8;
    ScrollBtn.Down:=(T and 16)=16;
    DopInfoBtn.Down:=(T and 32)=32;
    end;
  end;
  W:=StrToIntDef(PartOfStr(FSettings,4),Width);
  H:=StrToIntDef(PartOfStr(FSettings,5),Height);
  L:=StrToIntDef(PartOfStr(FSettings,6),Left);
  T:=StrToIntDef(PartOfStr(FSettings,7),Top);
  Width:=W;
  Height:=H;
  Left:=L;
  Top:=T;
end;

procedure TMDIChild.DisassembleValues;
var i,cnt:integer;
    s:String;
begin
  case TEmulMode(mode) of
    emController:
      case TEmulModuleType(cbTypeOfController.ItemIndex) of
      emtTemp6: begin
          fTemp6.Values:=Values;
         end;
      emtUI: begin
          fUI.Values:=Values;
         end;
      emtSuperBIO: begin
          fSuperBio.Values:=Values;
         end;
      emtBIO: begin
          fBio.Values:=Values;
         end;
      emtValve: begin
          fValve.Values:=Values;
         end;
      emtScales: begin
          fScales.Values:=Values;
         end;
     emtCounterEx:begin
            fCounterEx.Values:=Values;
         end;
     emtCounter:begin
            fCounter.Values:=Values;
         end;
      end;
  emTerminal: begin
        cnt:=StrToIntDef(PartOfStr(Values,1),0);
        lbMacros.Clear;
        for i:=2 to cnt+1 do
        begin
          s:=PartOfStr(Values,i);
          if s<>'' then
             lbMacros.Items.Add(s);
        end;
      end;
  end;
end;

procedure TMDIChild.SetMode(const Value: integer);
begin
  if Value in [0,1] then
  begin
    FMode := Value;
    if Assigned(pcMain) then
       pcMain.ActivePageIndex:=Value;
  end;
end;

procedure TMDIChild.tbOpenPortClick(Sender: TObject);
begin
  ComPort1.Open;
end;

procedure TMDIChild.tbSetupPortClick(Sender: TObject);
begin
   ComPort1.ShowSetupDialog;
end;

procedure TMDIChild.tbClosePortClick(Sender: TObject);
begin
  ComPort1.Close;
end;

procedure TMDIChild.ComPort1AfterOpen(Sender: TObject);
begin
  UpdateConsole();
end;

procedure TMDIChild.DoMoveListItem(AKind: Boolean);
var
 lIndex, NewIndex: Integer;
begin
 lIndex := lbMacros.ItemIndex;
 try
  if (lIndex >= 0) and (lIndex < lbMacros.Count) then
   begin
    case AKind of
     True:  begin
             NewIndex := lIndex + 1;
             lbMacros.Items.Exchange(lIndex,NewIndex);
            end;
     False: begin
              NewIndex := lIndex - 1;
              lbMacros.Items.Exchange(lIndex,NewIndex);
            end;
    end;
   lbMacros.ItemIndex:= lIndex;
  end;
 except
 end;
end;

procedure TMDIChild.UpdateConsole();
var s:String;
begin
  pnlSend.Visible:=ComPort1.Connected;
  StatusBar1.Visible:=ComPort1.Connected;
  if ComPort1.Connected then
     s:='������'
  else
     s:='������';

  tbOpenPort.Enabled:=not ComPort1.Connected;
  tbClosePort.Enabled:=ComPort1.Connected;
  tbSetupPort.Enabled:=not ComPort1.Connected;

  if ComPort1.Connected then
     ComTerminal.Color:=clMoneyGreen
  else
     ComTerminal.Color:=clGray;

  Caption:=ComPort1.Port+':'+BaudRateToStr(ComPort1.BaudRate)+':'+s;
  ToTerminal(Caption,[fsItalic],clGreen);

  sMacros.Visible:=ComPort1.Connected;
  gbMacros.Visible:=ComPort1.Connected;
end;

procedure TMDIChild.ComPort1AfterClose(Sender: TObject);
begin
 UpdateConsole();
end;

procedure TMDIChild.SendCMD(Value:String);
var s:String;
    msek:integer;
begin
  if DopInfoBtn.Down then
  begin
    S:=TimeToStr(Time);
    msek:=MilliSecondOf(Time);
    if msek>=100 then
       S:=S+Format('.%d',[msek])
    else if msek>=10 then
       S:=S+Format('.0%d',[msek])
    else
       S:=S+Format('.00%d',[msek]);
    ToTerminal(S,[fsBold,fsItalic],clGray);
    MainForm.ToTerminal(S,[fsBold,fsItalic],clGray);
  end;
  s:='';
  if HexBtn.Down then
    s:=Hex2Str(Value)
  else
    s:=Value;
  if CRBtn.Down then
     s:=s+Chr($0D);
  if LFBtn.Down then
     s:=s+Chr($0A);
  if s<>'' then
  begin
     if HexBtn.Down then
     begin
        ToTerminal(Str2Hex(S),[fsBold]);
        MainForm.ToTerminal(Str2Hex(S),[fsBold]);
     end
     else begin
        ToTerminal(S,[fsBold]);
        MainForm.ToTerminal(S,[fsBold]);
     end;
     ComPort1.WriteStr(s);
     StatusBar1.SimpleText:='���������� '+IntToStr(Length(s))+' ����';
  end;
end;

procedure TMDIChild.btnSendClick(Sender: TObject);
begin
  SendCMD(edtSend.Text);
end;

function TMDIChild.GetPortNumber: integer;
var s:String;
begin
    result:=0;
    if Assigned(ComPort1) then
    begin
      s:=ComPort1.Port;
      if Length(s)>3 then
      begin
        s:=copy(s,4,Length(s)-3);
        result:=StrToIntDef(s,0);
      end;
    end;
end;

procedure TMDIChild.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if COMPort1.Connected then COMPort1.Close;
end;

procedure TMDIChild.ComPort1RxChar(Sender: TObject; Count: Integer);
var
  Str: String;
begin
  ComPort1.ReadStr(Str,Count);
  if HexBtn.Down then
     ComTerminal.Lines.Add(Str2Hex(Str))
  else
     ComTerminal.Lines.Add(Str);
  CheckScroll();
  StatusBar1.SimpleText:='������� '+IntToStr(Count)+' ����';
end;

procedure TMDIChild.SetReceivedCmd(const Value: String);
begin
  if TEmulMode(Mode)=emController then
  begin
    //������ ������, ���� �� ���������
    FReceivedCmd := Value;
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtCounter:   begin
                    fCounter.ReceivedCmd:=Value;
                  end;
     emtCounterEx:begin
                    fCounterEx.ReceivedCmd:=Value;
                  end;
     emtFCD2:     begin
                    fFCD.ReceivedCmd:=Value;
                  end;
     emtScales:   begin
                    fScales.ReceivedCmd:=Value;
                  end;
     emtSuperBIO: begin
                    fSuperBio.ReceivedCmd:=Value;
                  end;
     emtTemp6:    begin
                    fTemp6.ReceivedCmd:=Value;
                  end;
     emtUI:       begin
                    fUI.ReceivedCmd:=Value;
                  end;
    emtValve:     begin
                    fValve.ReceivedCmd:=Value;
                  end;
    emtVLT6000:   begin
                    fVLT6000.ReceivedCmd:=Value;
                  end;
    emtIVTM:      begin
                  end;
    emtKM5:       begin
                  end;
    emtRT2:       begin
                  end;
    end;
  end;
end;

procedure TMDIChild.tbSaveLogClick(Sender: TObject);
begin
  if SaveDialog1.FileName='' then
     SaveDialog1.FileName:=ComPort1.Port+'_'+BaudRateToStr(ComPort1.BaudRate)+'.rtf';
  if SaveDialog1.Execute then
  begin
    ComTerminal.lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TMDIChild.tbCleatLogClick(Sender: TObject);
begin
  ComTerminal.Clear;
end;

procedure TMDIChild.ToTerminal(const Value: String;Attr:TFontStyles;AColor:TColor=clBlack);
begin
    ComTerminal.SelAttributes.Style:=Attr;
    ComTerminal.SelAttributes.Color:=AColor;
    ComTerminal.Lines.Add(Value);
    ComTerminal.SelAttributes.Style:=[];
    ComTerminal.SelAttributes.Color:=clBlack;
    CheckScroll;
end;

procedure TMDIChild.DoAnswerReceived(Sender: TObject; const Value: String);
var s:String;
    msek:integer;
begin
  if DopInfoBtn.Down then
  begin
    S:=TimeToStr(Time);
    msek:=MilliSecondOf(Time);
    if msek>=100 then
       S:=S+Format('.%d',[msek])
    else if msek>=10 then
       S:=S+Format('.0%d',[msek])
    else
       S:=S+Format('.00%d',[msek]);
    ToTerminal(s,[fsItalic],clGray);
  end;
  if (MainForm.ComPort1.Connected) then
  begin
    if MainForm.DopInfoBtn.Down then
      MainForm.ToTerminal(S,[fsItalic],clGray);
    //��������� ����� � �������
    if HexBtn.Down then
    begin
       ToTerminal(Str2Hex(Value),[]);
       MainForm.ToTerminal(Str2Hex(Value),[]);
    end
    else begin
       ToTerminal(Value,[]);
       MainForm.ToTerminal(Value,[]);
    end;
    MainForm.ComPort1.WriteStr(Value);
  end
  else
    ToTerminal(MainForm.ComPort1.Port+' �� ������!',[fsBold,fsItalic],clYellow);
end;



procedure TMDIChild.tbSUMMClick(Sender: TObject);
var
  s:String;
begin
  if HEXBtn.Down then
  begin
    //� ����������������� ������
    s:=Hex2Str(edtSend.Text);
    s:=AddChkCr(s,false);
    edtSend.Text:=Str2Hex(s);
  end else begin
    //� ASCII
    //------- ���������� �������� ����������� Temp6 -------
    //#2085<CR>
    //>+024.97+024.40+029.26+024.46+000.00+000.0037<CR>
    //-----------------------------------------------------
    s:=AddChkCr(edtSend.Text,false);
    edtSend.Text:=s;
  end;
end;

procedure TMDIChild.ComPort1Error(Sender: TObject; Errors: TComErrors);
var s:String;
begin
  s:=ComPort1.Port+' E:'+ComErrorsToStr(Errors);
  ToTerminal(s,[fsBold,fsItalic],clRed);
end;

procedure TMDIChild.CheckScroll();
begin
  try
    if ComTerminal.Visible and ScrollBtn.Down then
    begin
        ComTerminal.SetFocus;
        ComTerminal.SelStart := ComTerminal.GetTextLen;
        ComTerminal.Perform(EM_SCROLLCARET, 0, 0);
    end;
    ComTerminal.SelAttributes.Color:=clBlack;
    ComTerminal.SelAttributes.Style:=[];
  finally
  end;
end;

procedure TMDIChild.ComPort1Exception(Sender: TObject;
  TComException: TComExceptions; ComportMessage: String; WinError: Int64;
  WinMessage: String);
var s:String;
begin
  s:=ComPort1.Port+' E:'+ComportMessage+'/'+WinMessage;
  ToTerminal(s,[fsBold,fsItalic],clRed);
  ComPort1.Close;
end;

procedure TMDIChild.DisassembleComments;
begin
  if TEmulMode(Mode)=emTerminal then
    edtSend.Text:=FComments
  else
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtTemp6: begin
         fTemp6.Comments:=FComments;
       end;
    emtUI: begin
         fUI.Comments:=FComments;
       end;
    emtSuperBIO: begin
         fSuperBio.Comments:=FComments;
       end;
    emtBIO: begin
         fBio.Comments:=FComments;
       end;
    emtValve: begin
         fValve.Comments:=FComments;
       end;
    end;
end;

procedure TMDIChild.UpdateComments;
begin
  if TEmulMode(Mode)=emTerminal then
    FComments:=edtSend.Text
  else begin
    FComments:='';
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtTemp6: begin
           FComments:=fTemp6.Comments;
       end;
    emtUI: begin
           FComments:=fUI.Comments;
       end;
    emtSuperBIO: begin
           FComments:=fSuperBio.Comments;
       end;
    emtBIO: begin
           FComments:=fBio.Comments;
       end;
    emtValve: begin
           FComments:=fValve.Comments;
       end;
    end;
  end;
end;

procedure TMDIChild.SetComments(const Value: String);
begin
  FComments := Value;
  DisassembleComments();
end;

function TMDIChild.CmdIsValid(const Value: String): boolean;
begin
  result:=False;
  if TEmulMode(Mode)=emController then
  begin
    //������ ������, ���� �� ���������
    case TEmulModuleType(cbTypeOfController.ItemIndex) of
    emtCounter:   begin
                    if fCounter.CmdIsValid(Value) then
                    begin
                       fCounter.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtCounterEx:begin
                    if fCounterEx.CmdIsValid(Value) then
                    begin
                       fCounterEx.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtFCD2:     begin
                    if fFCD.CmdIsValid(Value) then
                    begin
                       fFCD.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtScales:   begin
                    if fScales.CmdIsValid(Value) then
                    begin
                       fScales.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtSuperBIO: begin
                    fSuperBio.Disassembled:=False;
                    if fSuperBio.CmdIsValid(Value) then
                    begin
                       fSuperBio.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtBIO: begin
                    if fBio.CmdIsValid(Value) then
                    begin
                       fBio.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtTemp6:    begin
                    if fTemp6.CmdIsValid(Value) then
                    begin
                       fTemp6.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
     emtUI:       begin
                    if fUI.CmdIsValid(Value) then
                    begin
                       fUI.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
    emtValve:     begin
                    if fValve.CmdIsValid(Value) then
                    begin
                       fValve.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
    emtVLT6000:   begin
                    if fVLT6000.CmdIsValid(Value) then
                    begin
                       fVLT6000.ReceivedCmd:=Value;
                       result:=True;
                    end
                  end;
    emtIVTM:      begin
                  end;
    emtKM5:       begin
                  end;
    emtRT2:       begin
                  end;
    end;
  end;
  if Result then
  begin
    //����� �� �����
    Sleep(1);
    Application.ProcessMessages;
  end;
end;

procedure TMDIChild.HEXBtnClick(Sender: TObject);
begin
  if HexBtn.Down then
     edtSend.Text:=Str2Hex(edtSend.Text)
  else
     edtSend.Text:=Hex2Str(edtSend.Text)
end;

procedure TMDIChild.N3Click(Sender: TObject);
begin
  lbMacros.Items.Add(edtSend.Text);
end;


function TMDIChild.lbMacrosSelectedIndex:integer;
var i:integer;
begin
  result:=-1;
  for i:=0 to lbMacros.Items.Count-1 do
  begin
    if lbMacros.Selected[i] then
    begin
      result:=i;
      break;
    end;
  end;
end;

procedure TMDIChild.lbMacrosDblClick(Sender: TObject);
var s:String;
    i:integer;
begin
  s:='';
  i:=lbMacrosSelectedIndex;
  if i>=0 then
    begin
      s:=lbMacros.items[i];
    end;
  if s<>'' then  SendCMD(s);
end;

procedure TMDIChild.lbMacrosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if CtrlDown then
  begin
    if key = vk_up then DoMoveListItem(True);
    if key = vk_down then DoMoveListItem(False);
  end
end;

procedure TMDIChild.lbMacrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var i:integer;
begin
  if CtrlDown then
  begin
    if key = VK_DELETE then
    begin
       i:=lbMacrosSelectedIndex;
       if i>=0 then
       lbMacros.Items.Delete(i);
    end
    else
      if key = vk_up then DoMoveListItem(True)
    else
      if key = vk_down then DoMoveListItem(False)
    else begin
      if key = 67 then//67 - Ctrl+C
      begin
         //�������� � ����� ������
         i:=lbMacrosSelectedIndex;
         if i>=0 then
         begin
           Clipboard.AsText:=lbMacros.Items[i];
         end;
      end
      else if key = 86 then//86 - Ctrl+V
      begin
         //������� �� ������ ������
         lbMacros.Items.Add(Clipboard.AsText);
      end;
    end;
  end
  else begin
    if key = VK_F2 then
    begin
       i:=lbMacrosSelectedIndex;
       if i>=0 then
       begin
          edtMacros.Top:=4+lbMacros.ItemHeight+lbMacros.ItemHeight*i;
          edtMacros.Text:=lbMacros.Items[i];
          edtMacros.tag:=i;
          edtMacros.Visible:=True;
          edtMacros.SetFocus();
       end;
    end;
  end;
end;

procedure TMDIChild.sMacrosCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  edtMAcros.Width:=lbMacros.Width-3;
end;

procedure TMDIChild.edtMacrosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = VK_RETURN then
    begin
      if edtMacros.tag in [0..(lbMacros.Items.Count-1)] then
         lbMacros.Items[edtMacros.tag]:=edtMacros.Text;
      edtMacros.Visible:=False;
      lbMacros.SetFocus();
    end
    else
    if key = VK_ESCAPE then
    begin
       edtMacros.Visible:=False;
       lbMacros.SetFocus();
    end;
end;

procedure TMDIChild.edtMacrosExit(Sender: TObject);
begin
   edtMacros.Visible:=False;
   lbMacros.SetFocus();
end;

procedure TMDIChild.edtMacrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = VK_ESCAPE then
    begin
       edtMacros.Visible:=False;
       lbMacros.SetFocus();
       key:=0;
    end;
end;

procedure TMDIChild.WMDeviceChange();
begin
  StatusBar1.SimpleText:='��������� ����� USB ���������...';
  if ComPort1.Connected then
  begin
     ComPort1.Close;
     Application.ProcessMessages;
     try
       ComPort1.Open;
     except
       on e:exception do
          StatusBar1.SimpleText:='������ �������� �����:'+e.Message;
     end;
  end;
end;

end.
