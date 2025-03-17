unit uCounterX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid, StdCtrls, ExtCtrls, Led, Spin, ComCtrls;
const
  cTimeConst=0.000002;
  gvCountExParamNames:array[0..22] of String=(
    'Активность счетчиков - эталонных',//   CertifiableCounterIsActive: array [0..7] of Boolean;
    'Активность счетчиков - поверяемых',// TestCounterIsActive: array [0..7] of Boolean;
    'Cтатус счета по поверяемым счетчикам',// TestCounterIsStarted: array [0..7] of Boolean;
    'Состояние программного(1) и аппаратного (2) старта',//CountIsStarted: Boolean;
    'Статус (S)',// Status:array[0..7] of byte;
    'Состояние на поверяемых каналах',// TestFlowmeterState: array [0..7] of boolean;  //true - идет счет
    'Состояние на эталонных каналах',// CertifiableFlowmeterState: array [0..7] of boolean;
    //команда J
    'Частота на эталонных каналах  (J)',//CertifiableFlowmeterFreq: array [0..7] of Single;
    'Частота на поверяемых каналах (J)',//TestFlowmeterFreq: array [0..7] of Single;

    //Команда А - для первых 4
    'Время на поверяемых каналах (A)',// TestFlowmeterTime: array [0..7] of Single;
    'Количество импульсов на поверяемых каналах',// TestFlowmeterImpCounter: array [0..7] of Longword;
    'Время счета',//CertifiableFlowmeterTime:Single;

    'Команда запроса накопленные значения (D)',//  (по эталонам[1..8] при поверке в режиме старт стоп)
                                                //Время на эталонных каналах
                                                //CertifiableFlowmeterTimeD: array [0..7] of Single;
    'Количество импульсов по эталонным каналам',//CertifiableFlowmeterImpCounterD: array [0..7] of Longword;
    'Команда запроса накопленных значений (C) 1',// (по эталонам [0..3] при поверке в режиме старт стоп сличением)
    '2',// CertifiableFlowmeterImpCounterC: array [0..4,0..7] of Longword;
    '3',
    '4',
    'Команда запроса накопленных значений (E) 5',// (по эталонам [0..3] при поверке в режиме старт стоп сличением)
    '6',// CertifiableFlowmeterImpCounterC: array [0..4,0..7] of Longword;
    '7',
    '8',
    'Версия'

  );

type
  TfrmCounterX = class(TBaseFrame)
    Panel1: TPanel;
    cbHEX: TCheckBox;
    tmrStartStop: TTimer;
    Label1: TLabel;
    LED1: TLED;
    Label2: TLabel;
    seNoise: TSpinEdit;
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure tmrStartStopTimer(Sender: TObject);
    procedure LED1Click(Sender: TObject);
  private
    FK_Mode: boolean;
    FP_Mode: boolean;
    FL_Mode: boolean;
    FStartStop: boolean;
    function ValToStr(val: longword): String;
    function GenerateAnswer: String;override;
    function CmdIsValid(aCMD: String): boolean;override;
    function  GetParams:String;override;
    procedure SetParams(const Value: String);override;
    function GetValues: String;override;
    procedure SetValues(const Value: String);override;
    procedure SetK_Mode(const Value: boolean);
    procedure DoSummationImpulses;
    procedure SetP_Mode(const Value: boolean);
    procedure SetL_Mode(const Value: boolean);
    procedure SetStartStop(const Value: boolean);
    procedure Stop;//останавливает счет
    procedure Start;//запускает счет
    procedure Clear;//очищает накопленные значения
    procedure Update;override;
    { Private declarations }
  public
    { Public declarations }
    Controller:TModuleCounterEx;
    property K_Mode:boolean read FK_Mode write SetK_Mode;//режим ожидания внешнего сигнала старт/стоп
    property P_Mode:boolean read FP_Mode write SetP_Mode;//режим принудительного счета
    property L_Mode:boolean read FL_Mode write SetL_Mode;//режим принудительного счета для заполнения трубы
    property StartStop:boolean read FStartStop write SetStartStop;
  end;

var
  frmCounterX: TfrmCounterX;

implementation

uses
  uMAIN;

{$R *.dfm}
function TfrmCounterX.ValToStr(val:longword):String;
begin
  if cbHex.Checked then
     result := Format('%8x',[val])
  else
     result := Format('%d',[val]);

end;

procedure TfrmCounterX.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
  if Cell.Col=0 then
     Value:=gvCountExParamNames[Cell.Row]//Параметры
  else
     case Cell.Row of
     0: if Cell.Col in [1..8] then //активность счетчиков эталонных
          if Controller.CertifiableCounterIsActive[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     1: if Cell.Col in [1..8] then //активность счетчиков поверяемых
          if Controller.TestCounterIsActive[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     2: if Cell.Col in [1..8] then //статус счета по поверяемым счетчикам
          if Controller.TestCounterIsStarted[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     3: begin                     //состояние программного и аппаратного старта
          if Cell.Col = 1 then
          begin
            if Controller.CountIsStarted then
              Value:='true'
            else
              Value:='false';
          end
          else if Cell.Col = 2 then
          begin
            if Controller.ExternalLineStartStop then
              Value:='true'
            else
              Value:='false';
          end
          else
              Value:='';
        end;
     4: if Cell.Col in [1..8] then      //статус
          Value:=Format('%x',[Controller.Status_S[Cell.Col-1]]);
     5: if Cell.Col in [1..8] then    //состояние на поверяемых каналах
          if Controller.SlaveFlowmeterState[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     6: if Cell.Col in [1..8] then   //состояние на эталонных каналах
          if Controller.MasterFlowmeterState[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     7: if Cell.Col in [1..8] then //частота на эталонных каналах
          Value:=Format('%8.2f',[Controller.MasterFlowmeterFreq_J[Cell.Col-1]]);
     8: if Cell.Col in [1..8] then //частота на поверяемых каналах
          Value:=Format('%8.2f',[Controller.SlaveFlowmeterFreq_J[Cell.Col-1]]);
     9: if Cell.Col in [1..8] then //время на поверяемых каналах
          Value:=Format('%8.2f',[Controller.SlaveStartStopTime_A_B[Cell.Col-1]]);
     10: if Cell.Col in [1..8] then //количество импульсов на поверяемых каналах
          Value:=ValToStr(Controller.SlaveFlowmeterImpCounters_A_B[Cell.Col-1]);

     11: if Cell.Col  = 1 then  //время счета
        begin
          Value:=Format('%8.2f',[Controller.StartStopTime_A_B]);
        end
        else
            Value:='';
     12: if Cell.Col in [1..8] then //Команда запроса накопленных значений D - время
          Value:=Format('%8.2f',[Controller.StartStopTimes_D[Cell.Col-1]]);
     13: if Cell.Col in [1..8] then //Команда запроса накопленных значений D - импульсы
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_D[Cell.Col-1]);

     14: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[0,Cell.Col-1]);
     15: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[1,Cell.Col-1]);
     16: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[2,Cell.Col-1]);
     17: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[3,Cell.Col-1]);
     18: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[4,Cell.Col-1]);
     19: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[5,Cell.Col-1]);
     20: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[6,Cell.Col-1]);
     21: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.MasterFlowmeterImpCounters_C_E[7,Cell.Col-1]);
     22:  case Cell.Col of
          1: Value:=PartOfStr(Controller.Version,4,' ');
          2: Value:=PartOfStr(Controller.Version,5,' ');
          3: Value:=PartOfStr(Controller.Version,6,' ');
          4: Value:=PartOfStr(Controller.Version,7,' ');
          5: Value:=PartOfStr(Controller.Version,8,' ');
          6: Value:=PartOfStr(Controller.Version,9,' ');
          else
             Value:='';
          end;


     end;
end;


(*
•	Команда запроса частот счетчиков: J
•	Команда запроса статуса : S
•	команда запроса накопленных значений по поверяемым каналам при поверке старт стоп  (сличением): A
•	команда запроса накопленных значений по поверяемым каналам при поверке старт стоп  (сличением): B
* Команды C и E  объёмы по эталонам для каждого поверяемого прибора:
•	Команда запроса накопленных значений по эталонам для поверяемых каналов [0..3] при поверке в реж. сличением: С
•	Команда запроса накопленных значений по эталонам для поверяемых каналов [4..7] при поверке в реж. сличением: E
•	команда запроса накопленных  значений времени и объёма по эталонам [1..8] при поверке в реж. старт стоп : D
•	Команда запуска счета (старт-стоп по времени): T
•	Команда запуска счета: P Команда запускае счет и обнуляет счет.
•	Команда запуска счета для заполнения трубы : L
•	Команда остановки счета: R Команда останавливает  счет.
•	Команда однократно включает режим ручного запуска счета: K После подачи команды "К" счетчик ожидает вшнего сигнала запуска счета.
•	Команда  включает выключает    фильтр: F0(F1)
*)
function TfrmCounterX.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  len:integer;
  Addr:integer;
  Status,Control:boolean;
begin
  //проверяем ответ
  Result := false;
  // Функция определяет, ответ на какую именно команду проверяется, а затем проверяет его.
  try
  s:='$'+copy(aCMD,2,4);
  Addr:=StrToIntDef(s,0);
  len:=Length(aCMD);
  if (
      (aCMD[1]='#') and
      (Addr=Controller.Address) and
      (aCMD[6] in ['A'..'F','J','K','L','P','R'..'T','V'])
     ) then
   begin
       Result := CheckForChkCr(aCMD);
   end;
  except
    on e:Exception do
       OutputDebugString(PChar('Ошибка E'+e.Message));
  end;
end;

function TfrmCounterX.GenerateAnswer: String;
var
   S:String;
   tmpL:Longword;
   tmpF:single absolute tmpL;
   i,j:integer;

begin
  case ReceivedCmd[6] of
  'A': begin
         //команда запроса накопленных значений по поверяемым каналам при поверке старт стоп  (сличением): A
         //08:29:39:911 --> #0001A25¦
         //                       |             Время               | |  Количество импульсов   | Dhtvz
         //                       |     на поверяемых каналах       | |  на поверяемых каналах  |
         //08:29:40:003 <-- !0001 00000000 00000000 00000000 00000000 000000 000000 000000 000000 00029059 FB¦
         s:='';
         With Controller do
         begin
            for i:=0 to 3 do
            begin
              //Время на поверяемых каналах - команда А
              tmpL:=Round(SlaveStartStopTime_A_B[i]);
              s:=s+IntToHex(tmpL,8);
            end;
            for i:=0 to 3 do
            begin
              //Количество импульсов на поверяемых каналах
              tmpL:=Round(SlaveFlowmeterImpCounters_A_B[i]);
              s:=s+IntToHex(tmpL,6);
            end;
            //Время СТАРТ-СТОП
            tmpL:=Round(StartStopTime_A_B/cTimeConst);
            s:=s+IntToHex(tmpL,8);
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'B': begin
         //аналог команды А
         s:='';
         With Controller do
         begin
            for i:=0 to 3 do
            begin
              //Время на поверяемых каналах - команда А
              tmpL:=Round(SlaveStartStopTime_A_B[i+4]);
              s:=s+IntToHex(tmpL,8);
            end;
            for i:=0 to 3 do
            begin
              //Количество импульсов на поверяемых каналах
              tmpL:=Round(SlaveFlowmeterImpCounters_A_B[i+4]);
              s:=s+IntToHex(tmpL,6);
            end;
            //Время СТАРТ-СТОП
            tmpL:=Round(StartStopTime_A_B/cTimeConst);
            s:=s+IntToHex(tmpL,8);
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'C': begin
         //Команда запроса накопленных значений - C (по эталонам [0..3] при поверке в режиме старт стоп сличением)
         s:='';
         With Controller do
         begin
          for i := 0 to 3 do
          begin
            for j := 0 to 7 do
            begin
              tmpL:=MasterFlowmeterImpCounters_C_E[i,j];
              s:=s+IntToHex(tmpL,6);
            end;
          end;
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'D': begin
         //Команда запроса накопленные значения - D  (по эталонам[1..8] при поверке в режиме старт стоп)
         s:='';
         With Controller do
         begin
          for i := 0 to 7 do
          begin
              tmpL:=MasterFlowmeterImpCounters_D[i];
              s:=s+IntToHex(tmpL,6);
          end;
          for i := 0 to 7 do
          begin
              tmpF:=StartStopTimes_D[i]/cTimeConst;
              s:=s+IntToHex(tmpL,8);
          end;
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'E': begin
         //Команда запроса накопленных значений - E (по эталонам [4..7] при поверке в режиме старт стоп сличением)
         s:='';
         With Controller do
         begin
          for i := 4 to 7 do
          begin
            for j := 0 to 7 do
            begin
              tmpL:=MasterFlowmeterImpCounters_C_E[i,j];
              s:=s+IntToHex(tmpL,6);
            end;
          end;
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'F': begin
         //F0- выключает    фильтр, F1- включает     фильтр
         result := AddChkCr('!'+IntToHex(Controller.Address, 4));
       end;
   'J':begin
         //Команда частот (мгновенных значений) - 16 значений в формате флоат 32 бит  (по 8 символов) 8 поверяемых и 8 эталонных
         s:='';
         With Controller do
         begin
          //16 значений в формате флоат 32 бит  (по 8 символов)
          //8 поверяемых
          for i := 0 to 7 do
          begin
             tmpF:=SlaveFlowmeterFreq_J[i];
             s:=s+IntToHex(tmpL,8);
          end;
          //8 эталонных
          for i := 0 to 7 do
          begin
             tmpF:=MasterFlowmeterFreq_J[i];
             s:=s+IntToHex(tmpL,8);
          end;
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+s);
       end;
  'K': begin
         // Команда: K однократно включает режим запуска счета по внешнему сигнхросигналу
         K_Mode:=True;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4));
       end;
  'L': begin
         // Команда: L - запуска счета для заполнения трубы
         L_Mode:=True;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4));
       end;
  'P': begin
         // Команда: P - запуска счета
         P_Mode:=True;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4));
       end;
  'R': begin
         // Команда: P - запуска счета
         K_Mode:=False;
         P_Mode:=False;
         L_Mode:=False;
         Stop;
         result := AddChkCr('!'+IntToHex(Controller.Address, 4));
       end;
  'V': begin
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+'  Aa?ney CounterV2 oano 29.09.2021     ');
       end;
  'S': begin
         //Команда S - Состояние контроллера
    (*              Пов. Эт.   K (внешний синхросигнал)
                    сч.  сч.   старт
                     /  /     /
        !0001 20 80 20 80 07 77 77 21 - резерв - возможно версия плис
                           \старт P,L (Внутренний синхросигнал)

            Команда запроса статуса

            #0001S79{0D}

            ответ:
            !0001 678923452018000019{0D}
            6789234520180000
            !0001
            67  	статус CE поверяемым мгновенных значений
            23	статус CE эталонам	мгновенных значений
            20	статус CE при поверке сличением
            45	статус CE при поверке старт-стоп
            6789	РЕЗЕРВ
            6789	РЕЗЕРВ
            19{0D}
        *)
         s:='';
         for i:=0 to 7 do s:=s+IntToHex(Controller.Status_S[i],2);
         result := AddChkCr('!'+IntToHex(Controller.Address, 4)+S);

    end;

  end;
end;

function TfrmCounterX.GetParams: String;
begin
//    MasterFlowmeterFreq_J: array [0..7] of Single;
//    //Частота на поверяемых каналах
//    //переименовываем TestFlowmeterFreq в SlaveFlowmeterFreq_J
//    SlaveFlowmeterFreq_J: array [0..7] of Single;

  result:=Format('%f,%f,%f,%f,%f,%f,%f,%f',[
         Controller.SlaveFlowmeterFreq_J[0],
         Controller.SlaveFlowmeterFreq_J[1],
         Controller.SlaveFlowmeterFreq_J[2],
         Controller.SlaveFlowmeterFreq_J[3],
         Controller.SlaveFlowmeterFreq_J[4],
         Controller.SlaveFlowmeterFreq_J[5],
         Controller.SlaveFlowmeterFreq_J[6],
         Controller.SlaveFlowmeterFreq_J[7]
         ])
end;

function TfrmCounterX.GetValues: String;
begin
//    MasterFlowmeterFreq_J: array [0..7] of Single;
//    //Частота на поверяемых каналах
//    //переименовываем TestFlowmeterFreq в SlaveFlowmeterFreq_J
//    SlaveFlowmeterFreq_J: array [0..7] of Single;

  result:=Format('%f,%f,%f,%f,%f,%f,%f,%f',[
         Controller.MasterFlowmeterFreq_J[0],
         Controller.MasterFlowmeterFreq_J[1],
         Controller.MasterFlowmeterFreq_J[2],
         Controller.MasterFlowmeterFreq_J[3],
         Controller.MasterFlowmeterFreq_J[4],
         Controller.MasterFlowmeterFreq_J[5],
         Controller.MasterFlowmeterFreq_J[6],
         Controller.MasterFlowmeterFreq_J[7]
         ])
end;

procedure TfrmCounterX.SetParams(const Value: String);
begin
//    MasterFlowmeterFreq_J: array [0..7] of Single;
//    //Частота на поверяемых каналах
//    //переименовываем TestFlowmeterFreq в SlaveFlowmeterFreq_J
//    SlaveFlowmeterFreq_J: array [0..7] of Single;
   Controller.SlaveFlowmeterFreq_J[0]:=StrToFloatDef(PartOfStr(Value,1),0);
   Controller.SlaveFlowmeterFreq_J[1]:=StrToFloatDef(PartOfStr(Value,2),0);
   Controller.SlaveFlowmeterFreq_J[2]:=StrToFloatDef(PartOfStr(Value,3),0);
   Controller.SlaveFlowmeterFreq_J[3]:=StrToFloatDef(PartOfStr(Value,4),0);
   Controller.SlaveFlowmeterFreq_J[4]:=StrToFloatDef(PartOfStr(Value,5),0);
   Controller.SlaveFlowmeterFreq_J[5]:=StrToFloatDef(PartOfStr(Value,6),0);
   Controller.SlaveFlowmeterFreq_J[6]:=StrToFloatDef(PartOfStr(Value,7),0);
   Controller.SlaveFlowmeterFreq_J[7]:=StrToFloatDef(PartOfStr(Value,8),0);
end;

procedure TfrmCounterX.SetValues(const Value: String);
begin
//    MasterFlowmeterFreq_J: array [0..7] of Single;
//    //Частота на поверяемых каналах
//    //переименовываем TestFlowmeterFreq в SlaveFlowmeterFreq_J
//    SlaveFlowmeterFreq_J: array [0..7] of Single;
   Controller.MasterFlowmeterFreq_J[0]:=StrToFloatDef(PartOfStr(Value,1),0);
   Controller.MasterFlowmeterFreq_J[1]:=StrToFloatDef(PartOfStr(Value,2),0);
   Controller.MasterFlowmeterFreq_J[2]:=StrToFloatDef(PartOfStr(Value,3),0);
   Controller.MasterFlowmeterFreq_J[3]:=StrToFloatDef(PartOfStr(Value,4),0);
   Controller.MasterFlowmeterFreq_J[4]:=StrToFloatDef(PartOfStr(Value,5),0);
   Controller.MasterFlowmeterFreq_J[5]:=StrToFloatDef(PartOfStr(Value,6),0);
   Controller.MasterFlowmeterFreq_J[6]:=StrToFloatDef(PartOfStr(Value,7),0);
   Controller.MasterFlowmeterFreq_J[7]:=StrToFloatDef(PartOfStr(Value,8),0);
end;

procedure TfrmCounterX.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
     if Cell.Col in [1..8] then
     case Cell.Row of
     0: //активность счетчиков эталонных
        Controller.CertifiableCounterIsActive[Cell.Col-1]:=(Value='true') or (Value='1');
     1: //активность счетчиков поверяемых
        Controller.TestCounterIsActive[Cell.Col-1]:=(Value='true') or (Value='1');
     2: //статус счета по поверяемым счетчикам
        Controller.TestCounterIsStarted[Cell.Col-1]:=(Value='true') or (Value='1');
     4: //статус
        Controller.Status_S[Cell.Col-1]:=StrToIntDef(Value,0);
     5: //состояние на поверяемых каналах
        Controller.SlaveFlowmeterState[Cell.Col-1]:=(Value='true') or (Value='1');
     6: //состояние на эталонных каналах
        Controller.MasterFlowmeterState[Cell.Col-1]:=(Value='true') or (Value='1');
     7: //частота на эталонных каналах
        Controller.MasterFlowmeterFreq_J[Cell.Col-1]:=StrToFloatDef(Value,0);
     8: //частота на поверяемых каналах
        Controller.SlaveFlowmeterFreq_J[Cell.Col-1]:=StrToFloatDef(Value,0);
     9: //время на поверяемых каналах
        Controller.SlaveStartStopTime_A_B[Cell.Col-1]:=StrToFloatDef(Value,0);
     10://количество импульсов на поверяемых каналах
        Controller.SlaveFlowmeterImpCounters_A_B[Cell.Col-1]:=StrToIntDef(Value,0);
     11:Controller.StartStopTime_A_B:=StrToFloatDef(Value,0);
     12://Команда запроса накопленных значений D - время
        Controller.StartStopTimes_D[Cell.Col-1]:=StrToFloatDef(Value,0);
     13://Команда запроса накопленных значений D - импульсы
        Controller.MasterFlowmeterImpCounters_D[Cell.Col-1]:=StrToIntDef(Value,0);
     14:Controller.MasterFlowmeterImpCounters_C_E[0,Cell.Col-1]:=StrToIntDef(Value,0);
     15:Controller.MasterFlowmeterImpCounters_C_E[1,Cell.Col-1]:=StrToIntDef(Value,0);
     16:Controller.MasterFlowmeterImpCounters_C_E[2,Cell.Col-1]:=StrToIntDef(Value,0);
     17:Controller.MasterFlowmeterImpCounters_C_E[3,Cell.Col-1]:=StrToIntDef(Value,0);
     18:Controller.MasterFlowmeterImpCounters_C_E[4,Cell.Col-1]:=StrToIntDef(Value,0);
     19:Controller.MasterFlowmeterImpCounters_C_E[5,Cell.Col-1]:=StrToIntDef(Value,0);
     20:Controller.MasterFlowmeterImpCounters_C_E[6,Cell.Col-1]:=StrToIntDef(Value,0);
     21:Controller.MasterFlowmeterImpCounters_C_E[7,Cell.Col-1]:=StrToIntDef(Value,0);
     22:  case Cell.Col of
          1: Value:=PartOfStr(Controller.Version,4,' ');
          2: Value:=PartOfStr(Controller.Version,5,' ');
          3: Value:=PartOfStr(Controller.Version,6,' ');
          4: Value:=PartOfStr(Controller.Version,7,' ');
          5: Value:=PartOfStr(Controller.Version,8,' ');
          6: Value:=PartOfStr(Controller.Version,9,' ');
          else
             Value:='';
          end;
     end;
end;

procedure TfrmCounterX.tmrStartStopTimer(Sender: TObject);
begin
  inherited;
  if K_Mode then StartStop:=MainForm.StartStop;//работа по внешнему синхросигналу
  if StartStop then DoSummationImpulses;//если счет - считаем
end;

procedure TfrmCounterX.SetK_Mode(const Value: boolean);
begin
  FK_Mode := Value;
  tmrStartStop.Enabled:=Value;
end;

procedure TfrmCounterX.DoSummationImpulses;
var
  i,j:integer;
  tmpF:Single;
begin
  //суммируем все частоты
  with Controller do
  begin
    StartStopTime_A_B:=StartStopTime_A_B+1;
    for i:=0 to 7 do
    begin
      SlaveStartStopTime_A_B[i]:=StartStopTime_A_B;
      SlaveFlowmeterImpCounters_A_B[i]:=Round(SlaveFlowmeterImpCounters_A_B[i]+
                 SlaveFlowmeterFreq_J[i]);

      StartStopTimes_D[i]:=StartStopTime_A_B;
      MasterFlowmeterImpCounters_D[i]:=Round(MasterFlowmeterImpCounters_D[i]+
                 MasterFlowmeterFreq_J[i]);
      for j:=0 to 7 do
         MasterFlowmeterImpCounters_C_E[j,i]:=MasterFlowmeterImpCounters_C_E[j,i]+Round(MasterFlowmeterFreq_J[i]);
    end;
  end;
end;

procedure TfrmCounterX.SetP_Mode(const Value: boolean);
begin
  FP_Mode := Value;
  StartStop:=Value;
end;

procedure TfrmCounterX.SetL_Mode(const Value: boolean);
begin
  FL_Mode := Value;
  StartStop:=Value;
end;

procedure TfrmCounterX.SetStartStop(const Value: boolean);
begin
  if FStartStop <> Value then
  begin
    if Value then Clear;//если старт - после стопа - предварительный сброс
    FStartStop := Value;
    Controller.ExternalLineStartStop:=Value;
    LED1.Lighted:= Value;
    if Value then Start
    else Stop;
  end;
end;

procedure TfrmCounterX.Start;
begin
  Controller.CountIsStarted:=True;
  Controller.Status_S[2]:=$ff;
  Controller.Status_S[3]:=$ff;
  MainForm.StartStop:=True;
  tmrStartStop.Enabled:=True;
end;

procedure TfrmCounterX.Stop;
begin
  Controller.CountIsStarted:=False;
  Controller.Status_S[2]:=0;
  Controller.Status_S[3]:=0;
  MainForm.StartStop:=False;
  tmrStartStop.Enabled:=False;
end;

procedure TfrmCounterX.Clear;
var
  i,j:integer;
begin
  tmrStartStop.Enabled:=False;
  for i:=0 to 7 do
  begin
    Controller.SlaveStartStopTime_A_B[i]:=0;
    Controller.SlaveFlowmeterImpCounters_A_B[i]:=0;
    Controller.StartStopTime_A_B:=0;
    Controller.StartStopTimes_D[i]:=0;
    Controller.MasterFlowmeterImpCounters_D[i]:=0;
    for j:=0 to 7 do
      Controller.MasterFlowmeterImpCounters_C_E[i,j]:=0;
  end;
end;

procedure TfrmCounterX.Update;
var i:integer;
    noise:Single;
begin
  inherited;
  With Controller do
  begin
    for i := 0 to 7 do
    begin
       if SlaveFlowmeterFreq_J[i]<>0 then
       begin
          noise:=(seNoise.Value div 2 - Random(seNoise.Value))/100+SlaveFlowmeterFreq_J[i];
          if noise>0 then
             SlaveFlowmeterFreq_J[i]:=noise
          else
             SlaveFlowmeterFreq_J[i]:=noise*-1;
       end;
    end;
    //8 эталонных
    for i := 0 to 7 do
    begin
       if MasterFlowmeterFreq_J[i]<>0 then
       begin
          noise:=(seNoise.Value div 2 - Random(seNoise.Value))/100+MasterFlowmeterFreq_J[i];
          if noise>0 then
             MasterFlowmeterFreq_J[i]:=noise
          else
             MasterFlowmeterFreq_J[i]:=noise*-1;
       end;
    end;
  end;
end;

procedure TfrmCounterX.LED1Click(Sender: TObject);
begin
  StartStop:=not LED1.Lighted;//далее цвет меняется
end;

end.
