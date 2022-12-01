unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Horse, Horse.CORS,
  Horse.Jhonson, Vcl.StdCtrls, ProdutosController, LoginController,ClienteController, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    PanelButton: TPanel;
    SpeedButtonAtivar: TSpeedButton;
    procedure OpenListen();
    procedure SpeedButtonAtivarClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses dm;

procedure TForm3.OpenListen;
var
  port: Integer;
begin
  port := StrToInt(Edit1.Text);

  // registrar middleweres
  THorse.Use(Jhonson());

    // THorse.Use(CORS);
  TControllerProdutos.Registry;
  TLoginController.Registry;
  TClienteController.Registry;


  THorse.Listen(port);
end;

procedure TForm3.SpeedButtonAtivarClick(Sender: TObject);
var
  validar: string;
begin
  validar := SpeedButtonAtivar.Caption;
  if validar = 'Ativar' then
  begin
    SpeedButtonAtivar.Caption := 'Desativar';
    PanelButton.Color := clRed;
    OpenListen;
  end
  else
  begin
    SpeedButtonAtivar.Caption := 'Ativar';
    THorse.StopListen;
    PanelButton.Color := $00A3FF00;
  end;
end;

end.
