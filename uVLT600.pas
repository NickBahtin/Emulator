unit uVLT600;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Modules,Helper,
  Dialogs, uBaseFrame, Ex_Grid, ComCtrls;
const
  gvVLTParamNames:array[0..1] of String=(
  'Состояние',
  'Мощность');

type
  TfVLT6000 = class(TBaseFrame)
    procedure gvTableGetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);
  private
    FStarted: boolean;
    FPower: single;
    { Private declarations }
    function CmdIsValid(aCMD: String): boolean;override;
    function GenerateAnswer: String;override;
    procedure SetStarted(const Value: boolean);
    procedure SetPower(const Value: single);
  public
    { Public declarations }
    Controller:TModuleVLT6000;
    property Started:boolean read FStarted write SetStarted;
    property Power:single read FPower write SetPower;
  end;

var
  fVLT6000: TfVLT6000;

implementation

{$R *.dfm}

{ TfrmPump }

function TfVLT6000.CmdIsValid(aCMD: String): boolean;
var
  s:String;
  Addr:byte;
begin
    (*
    Команда инициализации работы с модулем
    <--	 >01FA7<CR>
    --> 	A1061<CR>
    Выключение
    <-- 	>0172040400F2<CR>
    --> 	A<CR>
    Включение
    <-- 	>0172040401F3<CR>
    --> 	A<CR>
    Установка частоты вращения
    Значение мощности от 0 до 100% умножаем на константу 163.84 - .
    <-- 	>0172030045CCCCCD89<CR> - 40%
    --> 	A<CR>
    <-- 	>0172030045B1739440<CR> - 34,7 %
    --> 	A<CR>
    *)
    Result := false;
    Addr:=StrToIntDef('$'+copy(aCMD,2,2),0);
    if (
        (aCMD[1]='>') and
        (Addr=Controller.Address) and
        (aCMD[4] in ['F','7'])
     ) then
     begin
         Result := CheckForChkCr(copy(aCMD,2,Length(aCMD)-1));
    end;
end;

function TfVLT6000.GenerateAnswer: String;
var s:String;
    tmpL:longword;
    tmpF:single absolute tmpL;
begin
  result:='';
  if not Assigned(Controller) then Exit;
  if (ReceivedCmd[4]='F') then
  begin
    //    Команда инициализации работы с модулем
    //    <--	 >01FA7<CR>
    //    --> 	A1061<CR>
    result:='A1061'+ Chr(13);
  end
  else if (ReceivedCmd[1]='>') and (ReceivedCmd[4]='7') then
  begin
    case ReceivedCmd[7] of
    '4':
         //    Выключение
         //    <-- 	>0172040400F2<CR>
         //    --> 	A<CR>
         //    Включение
         //    <-- 	>0172040401F3<CR>
         //    --> 	A<CR>
         Started:=ReceivedCmd[11]='1';
    '3': begin
          // Установка частоты вращения
          // Значение мощности от 0 до 100% умножаем на константу 163.84 - .
          //<-- 	>0172030045CCCCCD89<CR> - 40%
          //--> 	A<CR>
          s:='$'+copy(ReceivedCmd,10,8);//копируем мощность
          tmpL:=StrToIntDef(s,0);
          Power:=tmpF/163.84;
         end;
    end;
    result:='A'+ Chr(13);
  end;
end;

procedure TfVLT6000.SetPower(const Value: single);
begin
  FPower := Value;
end;

procedure TfVLT6000.SetStarted(const Value: boolean);
begin
  FStarted := Value;
end;

procedure TfVLT6000.gvTableGetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
    case cell.Col of
    0: begin
         Value:=gvVLTParamNames[cell.Row];
       end;
    1: begin
         if not Assigned(Controller) then
            Value:='---'
         else
         case cell.Row of
         0: begin
              if Started then
                 Value:='Работает'
              else
                 Value:='Остановлен';
            end;
         1: begin
              Value:=Format('%f',[Power]);
            end;
         end;
       end;
    end;
end;

end.
