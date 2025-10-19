unit uHSC_IMP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid, StdCtrls, ExtCtrls, Led, Spin, ComCtrls;

const
  gvOpenCloseNames:array[boolean] of String=('0','1');
  gvHSC_IMPStateNames:array[boolean] of String=('Отключен','Подключен');
  gvHSC_IMPParamNames:array[0..15] of String=(
    'Подключение',
    'Тип входов',
    'Тип частот',
    'Частоты счетчиков ',
    'Количество импульсов ',
    'Дробное количество импульсов',
    'Состояние счета',
    'Время проливки',
    'Симуляция',
    'Тип запуска счета',
    'Тип останова счета',
    'Ограничение длительности счета, сек',
    'Ограничение счета по количеству импульсов',
    'Внутренняя синхронизация',
    'Внешняя синхронизация',
    'Ведущий/Ведомый'
    );

type
  TfrmHSC_IMP = class(TBaseFrame)
    Panel1: TPanel;
    Label1: TLabel;
    LED1: TLED;
    Label2: TLabel;
    cbHEX: TCheckBox;
    seNoise: TSpinEdit;
    gvHSC_IMP: TGridView;
    tmrStartStop: TTimer;
    procedure tmrStartStopTimer(Sender: TObject);
  private
    FStartStop: boolean;
    function ValToStr(val: longword): String;
    procedure SetStartStop(const Value: boolean);
    procedure Stop;//останавливает счет
    procedure Start;//запускает счет
    procedure Clear;
    procedure DoSummationImpulses;//очищает накопленные значения
    { Private declarations }
  public
    { Public declarations }
    Controller:TModuleHSC_IMP;
    property StartStop:boolean read FStartStop write SetStartStop;
  end;

implementation

uses uMAIN;

{$R *.dfm}

procedure TfrmHSC_IMP.Clear;
var
  i,j:integer;
begin
  tmrStartStop.Enabled:=False;
  for i:=0 to 7 do
  begin
//    Controller.SlaveStartStopTime_A_B[i]:=0;
//    Controller.SlaveFlowmeterImpCounters_A_B[i]:=0;
//    Controller.StartStopTime_A_B:=0;
//    Controller.StartStopTimes_D[i]:=0;
//    Controller.MasterFlowmeterImpCounters_D[i]:=0;
//    for j:=0 to 7 do
//      Controller.MasterFlowmeterImpCounters_C_E[i,j]:=0;
  end;
end;

procedure TfrmHSC_IMP.SetStartStop(const Value: boolean);
begin
  FStartStop := Value;
end;

procedure TfrmHSC_IMP.Start;
begin
  Controller.CountIsStarted:=True;
//  Controller.Status_S[2]:=$ff;
//  Controller.Status_S[3]:=$ff;
  MainForm.StartStop:=True;
  tmrStartStop.Enabled:=True;
end;

procedure TfrmHSC_IMP.Stop;
begin
  Controller.CountIsStarted:=False;
//  Controller.Status_S[2]:=0;
//  Controller.Status_S[3]:=0;
  MainForm.StartStop:=False;
  tmrStartStop.Enabled:=False;
end;

function TfrmHSC_IMP.ValToStr(val:longword):String;
begin
  if cbHex.Checked then
     result := Format('%8x',[val])
  else
     result := Format('%d',[val]);

end;


procedure TfrmHSC_IMP.tmrStartStopTimer(Sender: TObject);
begin
  inherited;
  StartStop:=MainForm.StartStop;//работа по внешнему синхросигналу
  if StartStop then DoSummationImpulses;//если счет - считаем

end;

procedure TfrmHSC_IMP.DoSummationImpulses;
var
  i,j:integer;
  tmpF:Single;
begin
  //суммируем все частоты
  with Controller do
  begin
//    StartStopTime_A_B:=StartStopTime_A_B+1;
//    for i:=0 to 7 do
//    begin
//      SlaveStartStopTime_A_B[i]:=StartStopTime_A_B;
//      SlaveFlowmeterImpCounters_A_B[i]:=Round(SlaveFlowmeterImpCounters_A_B[i]+
//                 SlaveFlowmeterFreq_J[i]);
//
//      StartStopTimes_D[i]:=StartStopTime_A_B;
//      MasterFlowmeterImpCounters_D[i]:=Round(MasterFlowmeterImpCounters_D[i]+
//                 MasterFlowmeterFreq_J[i]);
//      for j:=0 to 7 do
//         MasterFlowmeterImpCounters_C_E[j,i]:=MasterFlowmeterImpCounters_C_E[j,i]+Round(MasterFlowmeterFreq_J[i]);
//    end;
  end;
end;


end.
