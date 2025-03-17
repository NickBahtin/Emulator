unit uFCD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,
  Dialogs, uBaseFrame, StdCtrls, Spin, ExtCtrls, Ex_Grid, ComCtrls;

const
  gvFCDParamNames:array[0..9] of String=(
  '����� 1',
  '����� 2',
  '����� 3',
  '����� ���������� ������������, ��',
  '�1, ��',
  '�2, ��',
  '�3, ��',
  '�4, ��',
  '����� ��� �����, ��',
  '��������'
  );
  fcdstatenames:array[boolean]of string=('��������� �����','������� ���');
  _fcdstatenames:array[boolean]of string=('0','1');

type
  TfrmFCD = class(TBaseFrame)
    Panel1: TPanel;
    Label1: TLabel;
    seUPPNum: TSpinEdit;
    tmrSwitchWithTime: TTimer;
    function SwitchFCDWithTimer(FCD_number: Byte; time: Word): Boolean;
    function SwitchFCD(FCD_number: Byte; in_tank: Boolean): Boolean;
    procedure seUPPNumChange(Sender: TObject);
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
    procedure tmrSwitchWithTimeTimer(Sender: TObject);
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure gvTableSetEditText(Sender: TObject; Cell: TGridCell;
      var Value: String);
//    function GetComments: String;override;
//    function  GetParams:String;override;
//    function GetValues: String;override;
  private
    { Private declarations }
  public
    { Public declarations }
    Controller:TModuleFCD2;
  end;

var
  frmFCD: TfrmFCD;

implementation

uses
  Helper,uMAIN;

{$R *.dfm}

procedure TfrmFCD.seUPPNumChange(Sender: TObject);
begin
  inherited;
  gvTable.Invalidate;
end;

procedure TfrmFCD.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
  var idx:integer;
begin
  idx:=seUPPNum.Value-1;
  if idx in [0..2] then
  begin
    case cell.Col of
    0: begin
         Value:=gvFCDParamNames[cell.Row];
       end;
    1: begin
         if not Assigned(Controller) then
            Value:='---'
         else
         case cell.Row of
         0..2: begin
              Value:=fcdstatenames[Controller.InTankPositions[cell.Row]];
            end;
         3: begin
              Value:=Format('%f',[Controller.LastSwitchingTime]);
            end;
         4: begin
              Value:=Format('%f',[Controller.t1]);
            end;
         5: begin
              Value:=Format('%f',[Controller.t2]);
            end;
         6: begin
              Value:=Format('%f',[Controller.t3]);
            end;
         7: begin
              Value:=Format('%f',[Controller.t4]);
            end;
         8: begin
              Value:=Format('%f',[Controller.InTankTime]);
            end;
         9: begin
              Value:=Format('%d',[tmrSwitchWithTime.Tag]);
            end;

         end;
       end;
    end;
  end;
end;


function TfrmFCD.SwitchFCDWithTimer(FCD_number: Byte;
  time: Word): Boolean;
begin
  //time - � ��������
  Controller.InTankPositions[FCD_number]:=True;
  Controller.T1:=5;
  Controller.T2:=4;
  Controller.T3:=0;
  Controller.T4:=0;
  Controller.LastSwitchingTime:=9;
  Controller.InTankTime:=0;
  tmrSwitchWithTime.Tag:=time*100;
  tmrSwitchWithTime.Enabled:=True;
end;

function TfrmFCD.SwitchFCD(FCD_number: Byte; in_tank: Boolean): Boolean;
begin
     Controller.InTankPositions[FCD_number]:=in_tank;
end;

procedure TfrmFCD.tmrSwitchWithTimeTimer(Sender: TObject);
begin
  inherited;
  //���� ����� �� �������
  if tmrSwitchWithTime.tag>0 then
  begin
     MainForm.StartStop:=True;
     Controller.InTankPositions[seUPPNum.Value-1]:=True;
     tmrSwitchWithTime.tag:=tmrSwitchWithTime.tag-100;
     Controller.InTankTime:=Controller.InTankTime+1000;//�����, ����������� ��� ����� � ��
  end;
  //���� ����� �������
  if (tmrSwitchWithTime.tag=0) then
  begin
     MainForm.StartStop:=False;
     Controller.LastSwitchingTime:=10;
     Controller.T3:=5;
     Controller.T4:=5;
     Controller.InTankPositions[seUPPNum.Value-1]:=False;
     tmrSwitchWithTime.Enabled:=False;
  end;
  gvTable.Invalidate;//��������� �������� � �������
end;
(*

����������  ��� -  ������� ����� 0x90 �������� ������ 38400
�������:
 A,B,C - ������������ ��� 1,2,3
 s - ������ �������
 V - ������������ �� �����
 D - ������������ �� �������� - � ������ ��������� �� �����������

������������ ���:
#<������� ����� 2 �������> <����� ��� A..C><������������ 1- �� ���, �� ������ 0><CRC><CR>
������:
#90A0XX�//������������ ��� A �� ������
!908A�

������������ ��� �� �����:  'V'
#<������� ����� 2 �������>V<����� ��� A..C><����� ������������ - 8 ��������><CRC><CR>
������:
#90VA0770F1������������� ��� �� �����!908A�


������ ������� (����� 37 ����):
//����� �������� ����� � �������� �������� tx
#<������� ����� 2 �������>s<CRC><CR>
! <������� ����� 2 �������><���1 1-�� ��� 0-������><���2 1-�� ��� 0-������><���3 1-�� ��� 0-������><����� ������������ 4 �����><t1 4 �����><t2 4 �����><t3 4 �����><t4 4 �����><CRC><CR>
������:
#90sFF�
!9000000000000000000000000000000005A�


*)
function TfrmFCD.CmdIsValid(aCMD: String): boolean;
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
      (Addr=Controller.Address)
     ) then
   begin
       if (aCMD[4] in ['A'..'C','V','s','S']) then
          Result := CheckForChkCr(aCMD);
   end;
end;

function TfrmFCD.GenerateAnswer: String;
var s:String;
    tmpL:longword;
begin
  result:='';
  if not Assigned(Controller) then Exit;
  if (ReceivedCmd[4]='s') then
  begin
     //�������� �� ������ �������
     With Controller do
     s:=_fcdstatenames[InTankPositions[0]]+_fcdstatenames[InTankPositions[1]]+_fcdstatenames[InTankPositions[2]]+
         IntToHex(Round(LastSwitchingTime),4)+
         IntToHex(Round(T1),4)+
         IntToHex(Round(T2),4)+
         IntToHex(Round(T3),4)+
         IntToHex(Round(T4),4)+
         IntToHex(Round(InTankTime),8);
     result := AddChkCr('!'+IntToHex(Controller.Address, 2)+s);
  end
  else if (ReceivedCmd[4]='S') then //������� ���������  ��� � ������
  begin
     //�������� �� ������ �������
     With Controller do
     s:= _fcdstatenames[InTankPositions[0]]+_fcdstatenames[InTankPositions[1]]+_fcdstatenames[InTankPositions[2]]+
         IntToHex(Round(LastSwitchingTime*10/3.333333333333),2);
     result := AddChkCr('!'+IntToHex(Controller.Address, 2)+s);
  end
  else if (ReceivedCmd[4] in ['A'..'C']) then
  begin
    //�������� �� ������ ������������ ������������
    seUPPNum.Value:=Ord(ReceivedCmd[4])-Ord('A')+1;//��������� ����� ������ ���
    SwitchFCD(seUPPNum.Value-1,ReceivedCmd[5]='1');
    result := AddChkCr('!'+IntToHex(Controller.Address, 2));
  end
  else if ReceivedCmd[4] = 'V' then
  begin
    //�������� �� ������ ������������ �� �������
    seUPPNum.Value:=Ord(ReceivedCmd[5])-Ord('A')+1;//��������� ����� ������ ���
    Controller.InTankTime:=0;
    tmpL:=StrToIntDef('$'+copy(ReceivedCmd,6,8),1);
    SwitchFCDWithTimer(seUPPNum.Value-1,Round(tmpL/1000));
    result := AddChkCr('!'+IntToHex(Controller.Address, 2));
  end;
end;


procedure TfrmFCD.gvTableSetEditText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
  case cell.Col of
  1: begin
       case cell.Row of
         0..2: begin
              if (Value=fcdstatenames[false]) or (Value=_fcdstatenames[false]) then
                  Controller.InTankPositions[cell.Row]:=False
              else
                  Controller.InTankPositions[cell.Row]:=True;
            end;
         3: begin
              Controller.LastSwitchingTime:=StrToFloatDef(Cp(Value),0);
            end;
       9: begin
            tmrSwitchWithTime.Tag:=StrToIntDef(Value,0);
          end;
       end;
     end;
  end;
end;

end.
