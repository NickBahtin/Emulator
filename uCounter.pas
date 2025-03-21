unit uCounter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid, StdCtrls, Spin, Led, ExtCtrls, ComCtrls;

const
    gvCountParamNames:array[0..7] of String=(
    '������� ��������� ���������� ������������',
    '���������� ��������� �� ���������� ���������',
    '����� ���������� ���������',
    '�����������(1),����������(2),���������(3)',//CountIsStarted: Boolean;
    '������� ��������� ������������',
    '���������� ��������� �� ��������� 0',
    '���������� ��������� �� ��������� 1',
    '����� ��������� ���� ���������� �����������'
    );

type
  TfrmCounter = class(TBaseFrame)
    Panel1: TPanel;
    Label1: TLabel;
    LED1: TLED;
    Label2: TLabel;
    cbHEX: TCheckBox;
    seNoise: TSpinEdit;
    tmrStartStop: TTimer;
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    function GenerateAnswer: String;override;
    function CmdIsValid(aCMD: String): boolean;override;
    function  GetParams:String;override;
    procedure SetParams(const Value: String);override;
    function GetValues: String;override;
    procedure SetValues(const Value: String);override;
    procedure tmrStartStopTimer(Sender: TObject);
    procedure LED1Click(Sender: TObject);
  private
    FStartStop: boolean;
    FK_Mode: boolean;
    FP_Mode: boolean;
    function ValToStr(val: longword): String;
    procedure SetStartStop(const Value: boolean);
    { Private declarations }
    procedure Stop;//������������� ����
    procedure Start;//��������� ����
    procedure Clear;
    procedure DoSummationImpulses;//������� ����������� ��������
    procedure Update;override;
    procedure SetK_Mode(const Value: boolean);
    procedure SetP_Mode(const Value: boolean);
  public
    { Public declarations }
    Controller:TModuleCounter;
    property K_Mode:boolean read FK_Mode write SetK_Mode;//����� �������� �������� ������� �����/����
    property P_Mode:boolean read FP_Mode write SetP_Mode;//����� ��������������� �����
    property StartStop:boolean read FStartStop write SetStartStop;
  end;

var
  frmCounter: TfrmCounter;

implementation

uses
  uMAIN;

{$R *.dfm}

function TfrmCounter.ValToStr(val:longword):String;
begin
  if cbHex.Checked then
     result := Format('%8x',[val])
  else
     result := Format('%d',[val]);

end;

procedure TfrmCounter.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin

  if Cell.Col=0 then
     Value:=gvCountParamNames[Cell.Row]
  else
     case Cell.Row of
     0: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.CertifiableFlowmeterFrequencies[Cell.Col-1]);
     1: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.CertifiableFlowmeterImpulses[Cell.Col-1]);
     2: if Cell.Col in [1..8] then
          if Controller.CounterIsActive[Cell.Col-1] then
            Value:='true'
          else
            Value:='false';
     3: begin
          if Cell.Col = 1 then
          begin
            if Controller.CountIsStarted then
              Value:='true'
            else
              Value:='false';
          end
          else if Cell.Col = 2 then
          begin
            if MainForm.StartStop then
              Value:='true'
            else
              Value:='false';
          end
          else if Cell.Col = 3 then
          begin
            if Controller.DependentImpulseModeIsActive then
              Value:='true'
            else
              Value:='false';
          end
          else
              Value:='---';
        end;
     4: if Cell.Col in [1..2] then
          Value:=ValToStr(Controller.SampleFlowmeterFrequencies[Cell.Col-1]);
     5: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.SampleFlowmeterImpulses[Cell.Col-1,0]);
     6: if Cell.Col in [1..8] then
          Value:=ValToStr(Controller.SampleFlowmeterImpulses[Cell.Col-1,1]);
     7:  if Cell.Col = 1 then
              Value:=ValToStr(Controller.SamplePairNumber)
          else
              Value:='';
     end;
end;

procedure TfrmCounter.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
     if Cell.Col in [1..8] then
     case Cell.Row of
     0: if Cell.Col in [1..8] then
          Controller.CertifiableFlowmeterFrequencies[Cell.Col-1]:=StrToIntDef(Value,0);
     1: if Cell.Col in [1..8] then
          Controller.CertifiableFlowmeterImpulses[Cell.Col-1]:=StrToIntDef(Value,0);
     2: if Cell.Col in [1..8] then
          Controller.CounterIsActive[Cell.Col-1]:= (Value='true') or (Value='1') or (Value='TRUE');
     3: begin
          if Cell.Col = 1 then
          begin
            Controller.CountIsStarted:=(Value='true') or (Value='1') or (Value='TRUE');
          end
          else if Cell.Col = 2 then
          begin
            MainForm.StartStop:=(Value='true') or (Value='1') or (Value='TRUE');
          end
          else if Cell.Col = 3 then
          begin
            Controller.DependentImpulseModeIsActive:=(Value='true') or (Value='1') or (Value='TRUE');
          end
        end;
     4: if Cell.Col in [1..2] then
          Controller.SampleFlowmeterFrequencies[Cell.Col-1]:=StrToIntDef(Value,0);
     5: if Cell.Col in [1..8] then
          Controller.SampleFlowmeterImpulses[Cell.Col-1,0]:=StrToIntDef(Value,0);
     6: if Cell.Col in [1..8] then
          Controller.SampleFlowmeterImpulses[Cell.Col-1,1]:=StrToIntDef(Value,0);
     7:  if Cell.Col = 1 then
         begin
              if StrToIntDef(Value,0) in [0..2] then
                 Controller.SamplePairNumber:=StrToIntDef(Value,0);
         end;
     end;
end;

procedure TfrmCounter.SetStartStop(const Value: boolean);
begin
  if Value<>FStartStop then
  begin
    if Value then Clear;//���� ����� - ����� ����� - ��������������� �����
    FStartStop := Value;
    Controller.ExternalLineStartStop:=Value;
    LED1.Lighted:= Value;
    if Value then Start
    else Stop;
  end;
end;

procedure TfrmCounter.Clear;
var
  i,j:integer;
begin
  tmrStartStop.Enabled:=False;
  for i:=0 to 7 do
  begin
    Controller.CertifiableFlowmeterImpulses[i]:=0;
    Controller.SampleFlowmeterImpulses[i,0]:=0;
    Controller.SampleFlowmeterImpulses[i,1]:=0;
  end;
end;

procedure TfrmCounter.Start;
var i:integer;
begin
  with Controller do
  begin
    CountIsStarted:=True;
    for i:=0 to 7 do
    begin
      // ���������� ��������� �� ��������� ��������� ������������.
      SampleFlowmeterImpulses[i,0]:=0;
      SampleFlowmeterImpulses[i,1]:=0;
      // ���������� ��������� �� ��������� ���������� ������������.
      CertifiableFlowmeterImpulses[i]:=0;
      Controller.CounterIsActive[i]:=Controller.CertifiableFlowmeterFrequencies[i]>0;
    end;
  end;
  StartStop:=True;
  MainForm.StartStop:=True;
  tmrStartStop.Enabled:=True;
end;

procedure TfrmCounter.Stop;
var i:integer;
begin
  Controller.CountIsStarted:=False;
  tmrStartStop.Enabled:=False;
  for i:=0 to 7 do
        Controller.CounterIsActive[i]:=False;
  StartStop:=False;
  MainForm.StartStop:=False;
  tmrStartStop.Enabled:=False;
end;

procedure TfrmCounter.tmrStartStopTimer(Sender: TObject);
begin
  inherited;
  if K_Mode then StartStop:=MainForm.StartStop;//������ �� �������� �������������
  if StartStop then DoSummationImpulses;//���� ���� - �������
end;


procedure TfrmCounter.DoSummationImpulses;
var
  i,j:integer;
  tmpF:Single;
begin
  //��������� ��� �������
  with Controller do
  begin
    for i:=0 to 7 do
    begin
      // ���������� ��������� �� ��������� ��������� ������������.
      SampleFlowmeterImpulses[i,0]:=SampleFlowmeterImpulses[i,0]+SampleFlowmeterFrequencies[0];
      SampleFlowmeterImpulses[i,1]:=SampleFlowmeterImpulses[i,1]+SampleFlowmeterFrequencies[1];
      // ���������� ��������� �� ��������� ���������� ������������.
      CertifiableFlowmeterImpulses[i]:=CertifiableFlowmeterImpulses[i]+CertifiableFlowmeterFrequencies[i];
    end;
  end;
end;

procedure TfrmCounter.Update;
var i:integer;
    noise:Single;
begin
  inherited;
  With Controller do
  begin
    //8 ���������
    for i := 0 to 7 do
    begin
       if CertifiableFlowmeterFrequencies[i]<>0 then
       begin
          noise:=(seNoise.Value div 2 - Random(seNoise.Value))+CertifiableFlowmeterFrequencies[i];
          if noise>0 then
             CertifiableFlowmeterFrequencies[i]:=Round(noise)
          else
             CertifiableFlowmeterFrequencies[i]:=Round(noise*-1);
       end;
    end;
    for i := 0 to 0 do
    begin
       if SampleFlowmeterFrequencies[i]<>0 then
       begin
          noise:=(seNoise.Value div 2 - Random(seNoise.Value))+SampleFlowmeterFrequencies[i];
          if noise>0 then
             SampleFlowmeterFrequencies[i]:=Round(noise)
          else
             SampleFlowmeterFrequencies[i]:=Round(noise*-1);
       end;
    end;
  end;
end;

procedure TfrmCounter.SetK_Mode(const Value: boolean);
begin
  FK_Mode := Value;
  tmrStartStop.Enabled:=Value;
end;

procedure TfrmCounter.SetP_Mode(const Value: boolean);
begin
  FP_Mode := Value;
  StartStop:=Value;
end;

function TfrmCounter.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  len:integer;
  Addr:byte;
  Status,Control:boolean;
begin
  //��������� �����
  Result := false;
  // ������� ����������, ����� �� ����� ������ ������� �����������, � ����� ��������� ���.
  Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
  len:=Length(aCMD);
  if (
      (aCMD[1]='#') and
      (Addr=Controller.Address) and
      (aCMD[4] in ['0'..'3','J','K','S','T','X','D','N','L','F'])
     ) then
   begin
       Result := CheckForChkCr(aCMD);
   end;
end;

function TfrmCounter.GenerateAnswer: String;
var
   S:String;
   tmpW:word;
   _CounterIsActive:byte;
   tmpL:Longword;
   tmpF:single absolute tmpL;
   i,j:integer;

begin
(*
"	������� ������� ������ ���������: J
"	������ ���������� ���������: K
"	������� ������� �����: S
"	������� ��������� �����: T
"	������� ������� ������� ��������: X
"	������� ��������� ���������� ������ ��������� ���������: D
"	������� ����������/���������� ������ ��������� ���������: N
"	������� ��������� ������ ��������� ���������: L
"	������� ���������� ������ ��������� ���������: F
"	������� ��������� ������ ��������� ����: ������ ����� ����  '0'..'3'
*)
  case ReceivedCmd[4] of
  '0'..'3': //������� ��������� ��������� ����(0..3) ( ����� 6 ����):
       begin
         With Controller do
          SamplePairNumber:=ord(ReceivedCmd[4])-ord('0');
         result := AddChkCr('!'+IntToHex(Controller.Address, 2));
       end;
  'J': //������� �������  ������ ��������� " J" ( ����� 46 ����):
       begin
         s:='';
         With Controller do
         begin
            s:=s+IntToHex(SampleFlowmeterFrequencies[0],4)+IntToHex(SampleFlowmeterFrequencies[1],4);
            for i:=0 to 7 do
            begin
              //���������� ��������� �� ���������� �������
              tmpL:=CertifiableFlowmeterFrequencies[i];
              s:=s+IntToHex(tmpL,4);
            end;
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 2)+s);
       end;//J
  'K': //������� ������� ���������� ��������� " K "(����� 4+72*8+3=583 �����):
       begin
         s:='';
        for i:=0 to 7 do
          With Controller do
          begin
            s:=s+IntToHex(CertifiableFlowmeterImpulses[i],8);
            s:=s+IntToHex(SampleFlowmeterImpulses[i][0],8);
            s:=s+IntToHex(SampleFlowmeterImpulses[i][1],8);
          end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 2)+s);
       end;//K


     (*
     #<������� �����> X<CRC><CR>
    ! <������� �����>
    <�������� ������� - 2 ������� >//������� �����  - 87654321 -1 - ������ �����
                                                              //0F -������� 4 ������
    <������� ���� ��������� ������������ - 1 ������ '0'..'3'>
    <���� ������� - 1 ������ '0'..'1'>
    <����� ��������� ��������� - 1 ������ '0'..'1'>
    <��������� �����  - 1 ������ '0'..'1'>
    <CRC><CR>
    ������:
    #01XDC�( ����������  13)
    !01002000A4�
    *)
  'X': //������� �������  �������  ��������� ( ����� 11 ����):
       begin
         _CounterIsActive:=0;
         with Controller do
         begin
           for i:= 0 to 7 do
           begin
             if CounterIsActive[i] then
                _CounterIsActive:=_CounterIsActive or (1 shl i);
           end;
           s:=IntToHex(_CounterIsActive,2);
           s:=s+IntToHex(Controller.SamplePairNumber,1);
           if CountIsStarted then s:=s+'1' else s:=s+'0';
           if SlowImpulseModeIsActive then s:=s+'1' else s:=s+'0';
           if DependentImpulseModeIsActive then s:=s+'1' else s:=s+'0';
         end;
         result := AddChkCr('!'+IntToHex(Controller.Address, 2)+s);
       end;//X
  'S','T','D','N','L','F':
        (*
      S - ������� ������� ����� ( ����� 6  ����):
      T - ������� ��������� ����� ( ����� 6  ����):
      D - ������� ���������  ������ ��������� ���������. ( ����� 6 ����):
      N - ������� ����������  ������ ��������� ���������. ( ����� 6 ����):
      L - ������� ���������  ������ ���������  ���������. ( ����� 6 ����):
      F - ������� ����������  ������ ���������  ���������. ( ����� 6 ����):
        *)
       begin
        with Controller do
        case ReceivedCmd[4] of
        'T': Stop;
        'S': Start;
        'D': DependentImpulseModeIsActive:=True;
        'N': DependentImpulseModeIsActive:=False;
        'L': SlowImpulseModeIsActive:=True;
        'F': SlowImpulseModeIsActive:=False;
        end;

         result := AddChkCr('!'+IntToHex(Controller.Address, 2));
       end;// 'S','T','D','N','L','F'
  end;
end;

function TfrmCounter.GetParams: String;
begin
  result:=Format('%d,%d,%d,%d,%d,%d,%d,%d',[
         Controller.CertifiableFlowmeterFrequencies[0],
         Controller.CertifiableFlowmeterFrequencies[1],
         Controller.CertifiableFlowmeterFrequencies[2],
         Controller.CertifiableFlowmeterFrequencies[3],
         Controller.CertifiableFlowmeterFrequencies[4],
         Controller.CertifiableFlowmeterFrequencies[5],
         Controller.CertifiableFlowmeterFrequencies[6],
         Controller.CertifiableFlowmeterFrequencies[7]
         ])
end;

function TfrmCounter.GetValues: String;
begin
  result:=Format('%d,%d',[
         Controller.SampleFlowmeterFrequencies[0],
         Controller.SampleFlowmeterFrequencies[1]
         ])
end;

procedure TfrmCounter.SetParams(const Value: String);
begin
   Controller.CertifiableFlowmeterFrequencies[0]:=StrToIntDef(PartOfStr(Value,1),0);
   Controller.CertifiableFlowmeterFrequencies[1]:=StrToIntDef(PartOfStr(Value,2),0);
   Controller.CertifiableFlowmeterFrequencies[2]:=StrToIntDef(PartOfStr(Value,3),0);
   Controller.CertifiableFlowmeterFrequencies[3]:=StrToIntDef(PartOfStr(Value,4),0);
   Controller.CertifiableFlowmeterFrequencies[4]:=StrToIntDef(PartOfStr(Value,5),0);
   Controller.CertifiableFlowmeterFrequencies[5]:=StrToIntDef(PartOfStr(Value,6),0);
   Controller.CertifiableFlowmeterFrequencies[6]:=StrToIntDef(PartOfStr(Value,7),0);
   Controller.CertifiableFlowmeterFrequencies[7]:=StrToIntDef(PartOfStr(Value,8),0);
end;

procedure TfrmCounter.SetValues(const Value: String);
begin
   Controller.SampleFlowmeterFrequencies[0]:=StrToIntDef(PartOfStr(Value,1),0);
   Controller.SampleFlowmeterFrequencies[1]:=StrToIntDef(PartOfStr(Value,2),0);
end;

procedure TfrmCounter.LED1Click(Sender: TObject);
begin
  inherited;
  LED1.Lighted:=not LED1.Lighted;
  Controller.CountIsStarted:=LED1.Lighted;
  StartStop:=LED1.Lighted;
end;

end.
