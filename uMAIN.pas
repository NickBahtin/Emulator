unit uMAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  DateUtils,Modules,IniFiles,Helper,
  ActnList, ToolWin, ImgList, CPort, RxRichEd;

  const
    cDefParams='0,0,1,0,1,0,0,0,0,0,0,0,797,1000,0,1000';
    cDefSettings='0,7,80,516,227,825,18';
    DBT_DEVICECHANGE = $0007;
    cCaptionText='Эмулятор протоколов 2022..24';
type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    aFileNewController: TAction;
    aFileSave: TAction;
    aFileExit: TAction;
    aFileOpen: TAction;
    aFileSaveAs: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    ComPort1: TComPort;
    aConnection: TAction;
    aSetupConnection: TAction;
    aDisconnection: TAction;
    Connect1: TMenuItem;
    Activate1: TMenuItem;
    Deactivate1: TMenuItem;
    aSetupConnection1: TMenuItem;
    N2: TMenuItem;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    SaveDialog1: TSaveDialog;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    aFileNewTerminal: TAction;
    gbJournal: TGroupBox;
    ComTerminal: TRxRichEdit;
    ToolButton6: TToolButton;
    tbShowJournall: TToolButton;
    aShowJournal: TAction;
    pnlSend: TPanel;
    HexBtn: TSpeedButton;
    ScrollBtn: TSpeedButton;
    DopInfoBtn: TSpeedButton;
    Timer1: TTimer;
    aOnTop: TAction;
    ToolButton15: TToolButton;
    aDispatcher: TAction;
    ToolButton16: TToolButton;
    N3: TMenuItem;
    mnuStartStop: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    spl1: TSplitter;
    procedure aFileOpenExecute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure aFileExitExecute(Sender: TObject);
    procedure aSetupConnectionExecute(Sender: TObject);
    procedure Activate1Click(Sender: TObject);
    procedure aConnectionExecute(Sender: TObject);
    procedure aDisconnectionExecute(Sender: TObject);
    procedure ComPort1AfterOpen(Sender: TObject);
    procedure ComPort1AfterClose(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure aFileSaveAsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure aFileNewControllerExecute(Sender: TObject);
    procedure aFileSaveExecute(Sender: TObject);
    procedure aFileNewTerminalExecute(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure aShowJournalExecute(Sender: TObject);
    procedure ComPort1Error(Sender: TObject; Errors: TComErrors);
    procedure ComPort1Exception(Sender: TObject;
      TComException: TComExceptions; ComportMessage: String;
      WinError: Int64; WinMessage: String);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aDispatcherExecute(Sender: TObject);
    procedure mnuStartStopClick(Sender: TObject);
    procedure ComTerminalMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    firstactivate:boolean;
    FAnswer: String;
    FStartStop: boolean;
    FRequest: String;
    { Private declarations }
    procedure CreateMDIChild(ASettings,AValues,AParams,AComments: string);
    procedure ComPortChangeState;
    procedure SetAnswer(const Value: String);
    procedure UpdateConsole;
    procedure StoreState;
    procedure RestoreState;
    procedure SetStartStop(const Value: boolean);
    procedure WMDeviceChange(var Msg: TMessage); message WM_DeviceChange;
    procedure SetRequest(const Value: String);
  public
    { Public declarations }
    procedure ToTerminal(const Value: String; Attr: TFontStyles;AColor:TColor=clBlack);
    procedure CheckScroll;
    procedure ClearProject();
    procedure SaveProject(AFileName:String);
    procedure LoadProject(AFileName:String);
    property Request:String read FRequest write SetRequest;
    property Answer:String read FAnswer write SetAnswer;
    property StartStop:boolean read FStartStop write SetStartStop;

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses uCHILDWIN,kbdhelper, uAbout;

procedure TMainForm.CreateMDIChild(ASettings,AValues,AParams,AComments: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  if ASettings<>'' then
  begin
     Child.Settings:=ASettings;
     Child.Values:=AValues;
     Child.Params:=AParams;
     Child.Comments:=AComments;
  end
  else
     Child.Caption:='Неопределенный тип контроллера';
end;

procedure TMainForm.aFileOpenExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    LoadProject(OpenDialog.FileName);
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.aFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.aSetupConnectionExecute(Sender: TObject);
begin
   ComPort1.ShowSetupDialog;
end;

procedure TMainForm.Activate1Click(Sender: TObject);
begin
  ComPort1.Open;
end;

procedure TMainForm.aConnectionExecute(Sender: TObject);
begin
   ComPort1.Open;
end;

procedure TMainForm.aDisconnectionExecute(Sender: TObject);
begin
  ComPort1.Close;
end;

procedure TMainForm.UpdateConsole();
var s:String;
begin
  if ComPort1.Connected then
     s:='Открыт'
  else
     s:='Закрыт';

  s:=ComPort1.Port+':'+BaudRateToStr(ComPort1.BaudRate)+':'+s;
  ToTerminal(s,[fsBold,fsItalic],clGreen);
end;


procedure TMainForm.ComPort1AfterOpen(Sender: TObject);
begin
  StatusBar1.Panels[1].Text:='Порт:'+ComPort1.Port;
  StatusBar1.Panels[2].Text:='Состояние:Открыт';
  ComPortChangeState();
end;

procedure TMainForm.ComPortChangeState;
begin
  aConnection.Enabled:=not ComPort1.Connected;
  aFileNewController.Enabled:=not ComPort1.Connected;
  aDisconnection.Enabled:=ComPort1.Connected;
  aFileOpen.Enabled:=not ComPort1.Connected;
  aFileNewTerminal.Enabled:=not ComPort1.Connected;
  aSetupConnection.Enabled:=not ComPort1.Connected;
  pnlSend.Visible:=ComPort1.Connected;
  Timer1.Enabled:=ComPort1.Connected;
  UpdateConsole;
end;

procedure TMainForm.ComPort1AfterClose(Sender: TObject);
begin
  StatusBar1.Panels[1].Text:='Порт:'+ComPort1.Port;
  StatusBar1.Panels[2].Text:='Состояние:Закрыт';
  ComPortChangeState();
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if Application.MessageBox('Закрыть приложение?', 'Завершение работы', MB_YESNO
     + MB_ICONQUESTION)<>mrYes then
     CanClose:=False;
   if (CanClose) and ComPort1.Connected then
   begin
      ComPort1.Close;
   end;


end;

procedure TMainForm.LoadProject(AFileName: String);
var
  MyIniFile: TIniFile;
  cnt,i:Integer;
  Settings,Values,Params,Comments:string;
begin
  ClearProject();
  if FileExists(AFileName) then
  begin
    StatusBar1.Panels[0].Text:='Проект:'+ExtractFileName(AFileName);
    Caption:=cCaptionText+' ('+StatusBar1.Panels[0].Text+')';
    MyIniFile := TIniFile.Create(AFileName);
    with MyIniFile do
    begin
      cnt:=ReadInteger('Project','Count',0);
      ComPort1.Port:=ReadString('Project','Port','COM1');
      ComPort1.BaudRate:=StrToBaudRate(ReadString('Project','Baud','9600'));
      for i := 1 to cnt do
      begin
        Settings:=ReadString('Item'+IntToStr(i),'Settings','');
        Values:=ReadString('Item'+IntToStr(i),'Values','');
        Params:=ReadString('Item'+IntToStr(i),'Params','');
        Comments:=ReadString('Item'+IntToStr(i),'Comments','');
        CreateMDIChild(Settings,Values,Params,Comments);
      end;
      if ReadBool('Project','Connected',false) then
        try
          ComPort1.Open;
        finally
        end;
     MyIniFile.Free;
    end;
  end;
end;

procedure TMainForm.SaveProject(AFileName: String);
var
  MyIniFile: TIniFile;
  i:integer;
begin
  MyIniFile := TIniFile.Create(AFileName);
  with MyIniFile do
  begin
    WriteInteger('Project','Count',MDIChildCount);
    WriteString('Project','Port',ComPort1.Port);
    WriteString('Project','Baud',BaudRateToStr(ComPort1.BaudRate));
    WriteBool('Project','Connected',ComPort1.Connected);
    for i := 1 to MDIChildCount do
    begin
      TMDIChild(MDIChildren[i-1]).UpdateSettings;
      TMDIChild(MDIChildren[i-1]).UpdateValues;
      TMDIChild(MDIChildren[i-1]).UpdateParams;
      TMDIChild(MDIChildren[i-1]).UpdateComments;
      WriteString('Item'+IntToStr(i),'Settings',TMDIChild(MDIChildren[i-1]).Settings);
      WriteString('Item'+IntToStr(i),'Values',TMDIChild(MDIChildren[i-1]).Values);
      WriteString('Item'+IntToStr(i),'Params',TMDIChild(MDIChildren[i-1]).Params);
      WriteString('Item'+IntToStr(i),'Comments',TMDIChild(MDIChildren[i-1]).Comments);
    end;
    MyIniFile.Free;
  end;
  if FileExists(AFileName) then
     OpenDialog.FileName:=AFileName;
end;

procedure TMainForm.ClearProject;
var i:integer;
begin
  ComPort1.Close;
  for i := MDIChildCount-1 downto 0  do
  begin
     MDIChildren[i].Free;
  end;
end;

procedure TMainForm.aFileSaveAsExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
     SaveProject(SaveDialog1.FileName);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DecimalSeparator:='.';
  OpenDialog.InitialDir:=ExtractFilePath(Application.ExeName);
  SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  firstactivate:=True;
end;

procedure TMainForm.aFileNewControllerExecute(Sender: TObject);
begin
  CreateMDIChild(cDefSettings,'',cDefPArams,'');
end;

procedure TMainForm.aFileSaveExecute(Sender: TObject);
begin
  if FileExists(SaveDialog1.FileName) then
     SaveProject(SaveDialog1.FileName)
  else
     aFileSaveAsExecute(nil);
end;

procedure TMainForm.aFileNewTerminalExecute(Sender: TObject);
begin
  //Терминал,COM1,9600,400,200,1,1,0,2,3,0
  CreateMDIChild('1,1,7,400,200,1,1,0,2,3,0','','','');
//      FSettings:=Format('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d',[Mode,PortNumber,ord(ComPort1.BaudRate),Width,Height,Left,
//        Top,ord(ComPort1.Parity.Bits),ord(ComPort1.StopBits),ord(ComPort1.DataBits),i]);
end;

procedure TMainForm.ComPort1RxChar(Sender: TObject; Count: Integer);
var
  Str,tmpS: String;
  msek,i:integer;
  found:boolean;
begin
     ComPort1.ReadStr(Str,Count);
     Request:=Request+Str;
     if gbJournal.Visible then
     begin
       if DopInfoBtn.Down then
       begin
         tmpS:=TimeToStr(Time);
         msek:=MilliSecondOf(Time);
         if msek>=100 then
            tmpS:=tmpS+Format('.%d',[msek])
         else if msek>=10 then
            tmpS:=tmpS+Format('.0%d',[msek])
         else
            tmpS:=tmpS+Format('.00%d',[msek]);
         ToTerminal(tmpS,[fsItalic],clGray);
       end;

       //фиксируем ответ в журнале
       if HexBtn.Down then
           ToTerminal(Str2Hex(Str),[])
       else
           ToTerminal(Str,[]);
     end;


     //отправляем на разборку окнам
     if pos(#$0D,Request)>0 then
     begin
       found:=False;
       for i := 1 to MDIChildCount do
       begin
          if TMDIChild(MDIChildren[i-1]).CmdIsValid(Request) then begin
            ToTerminal('Обработан в '+TMDIChild(MDIChildren[i-1]).Caption,[]);
            found:=True;
            break;
          end;
       end;
       if not Found then
          ToTerminal('Не найден контроллер для запроса: '+Request,[]);
       Request:='';
     end;
end;

procedure TMainForm.aShowJournalExecute(Sender: TObject);
begin
  gbJournal.Visible:=aShowJournal.Checked;
   spl1.Visible:=aShowJournal.Checked;
end;

procedure TMainForm.SetAnswer(const Value: String);
begin
  FAnswer := Value;
  if ComPort1.Connected then
  begin
     if gbJournal.Visible then
     begin
       //фиксируем ответ в журнале
       ToTerminal(Value,[],clBlack);
     end;
     ComPort1.WriteStr(Value);
  end;
end;

procedure TMainForm.ComPort1Error(Sender: TObject; Errors: TComErrors);
var s:String;
begin
  s:=ComPort1.Port+' E:'+ComErrorsToStr(Errors);
  ToTerminal(S,[fsBold,fsItalic],clRed);
end;

procedure TMainForm.ComPort1Exception(Sender: TObject;
  TComException: TComExceptions; ComportMessage: String; WinError: Int64;
  WinMessage: String);
var s:String;
begin
  s:=ComPort1.Port+' E:'+ComportMessage+'/'+WinMessage;
  ToTerminal(S,[fsBold,fsItalic],clRed);
  ComPort1.Close;
end;


procedure TMainForm.CheckScroll();
begin
  if gbJournal.Visible and ScrollBtn.Down then
  begin
      ComTerminal.SetFocus;
      ComTerminal.SelStart := ComTerminal.GetTextLen;
      ComTerminal.Perform(EM_SCROLLCARET, 0, 0);
  end;
  ComTerminal.SelAttributes.Color:=clBlack;
  ComTerminal.SelAttributes.Style:=[];
end;

procedure TMainForm.ToTerminal(const Value: String;Attr:TFontStyles;AColor:TColor=clBlack);
begin
  ComTerminal.SelAttributes.Style:=Attr;
  ComTerminal.SelAttributes.Color:=AColor;
  ComTerminal.Lines.Add(Trim(Value));
  ComTerminal.SelAttributes.Style:=[];
  ComTerminal.SelAttributes.Color:=clBlack;
  CheckScroll;
end;


procedure TMainForm.Timer1Timer(Sender: TObject);
var i:integer;
begin
 //отправляем на разборку окнам
 for i := 1 to MDIChildCount do
 begin
    TMDIChild(MDIChildren[i-1]).Update(self);
 end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if FirstActivate then
  begin
     FirstActivate:=False;
     RestoreState();
  end;
end;

//восстанавливаем предыдущее остояние
procedure TMainForm.RestoreState;
var
  MyIniFile: TIniFile;
  AFileName,ProjectName:string;
begin
  AFileName:=changeFileExt(Application.ExeName,'.ini');
  if FileExists(AFileName) then
  begin
    MyIniFile := TIniFile.Create(AFileName);
    try
      ProjectName:=MyIniFile.ReadString('Project','Last','');
      if FileExists(ProjectName) then
         LoadProject(ProjectName);
    finally
      MyIniFile.Free;
    end;
  end;
end;

//сохраняем текущее состояние
procedure TMainForm.StoreState;
var
  MyIniFile: TIniFile;
  ProjectName:string;
begin
  if FileExists(OpenDialog.FileName) then
  begin
    ProjectName:=changeFileExt(Application.ExeName,'.ini');
    MyIniFile := TIniFile.Create(ProjectName);
    try
      MyIniFile.WriteString('Project','Last',OpenDialog.FileName);
    finally
      MyIniFile.Free;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  StoreState();
end;

{ TODO : Основные контрллеры   Горячая клавиша - Ctrl+ALt+A
Контроллер температуры                  - реализовано  2022-12-04 16:47:57
Контроллер токовых входов и напряжений  - реализовано  2022-12-04 19:44:30
Контроллер Пневматики                   - РЕАЛИЗОВАН
Контроллер электрозадвижек              - РЕАЛИЗОВАН
Контроллер Весов                        - РЕАЛИЗОВАН
Контроллер Насосов (Данфосс)
Контроллер УПП                          - РЕАЛИЗОВАН   26.03.2023
Контроллер счетчиков                    - В состоянии РЕАЛИЗАЦИИ 26.03.2023
Контроллер КМ5
Контроллер РТ2
Контроллер ЦАП
Контроллер Пневматики старый            - РЕАЛИЗОВАН
}
procedure TMainForm.aDispatcherExecute(Sender: TObject);
begin
  WinExec(Pchar('cmd /c start mmc devmgmt.msc'), 0);
end;

procedure TMainForm.SetStartStop(const Value: boolean);
begin
  if FStartStop <> Value then
  begin
    FStartStop := Value;
    mnuStartStop.Checked:=Value;
  end;
end;

procedure TMainForm.mnuStartStopClick(Sender: TObject);
begin
  StartStop:=not StartStop;
end;

procedure TMainForm.WMDeviceChange(var Msg: TMessage);
var
  MyMsg: TMessage;
  i:integer;
begin
  case Msg.wParam of
    DBT_DEVICECHANGE:
    begin
      MyMsg:=Msg;
      StatusBar1.SimpleText:='Изменение карты USB устройств...';
      if ComPort1.Connected then
      begin
         ComPort1.Close;
         Application.ProcessMessages;
         try
           ComPort1.Open;
         except
           on e:exception do
              StatusBar1.SimpleText:='Ошибка открытия порта:'+e.Message;
         end;
      end;
      for i := 1 to MDIChildCount do
        TMDIChild(MDIChildren[i-1]).WMDeviceChange();
    end;
  end;
end;


procedure TMainForm.SetRequest(const Value: String);
begin
  FRequest := Value;
end;

procedure TMainForm.ComTerminalMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if CtrlDown then
    if WheelDelta>0 then
       ComTerminal.Font.Size:=ComTerminal.Font.Size+1
    else
       ComTerminal.Font.Size:=ComTerminal.Font.Size-1;
end;

end.
