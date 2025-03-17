unit uAbout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
//27.09.24 - uCount - счет при зажигании стартстопа 
//18.10.24 - CmdIsValid выполняет задержку 1 мсек для имитации задержки и разгрузки приложения
//19.10.24 - тест   
implementation

{$R *.dfm}

end.
 
