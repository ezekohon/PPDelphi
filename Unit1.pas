unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitRegistrarJugador, Vcl.Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Acciones1: TMenuItem;
    RegistrarJugador1: TMenuItem;
    procedure RegistrarJugador1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.RegistrarJugador1Click(Sender: TObject);
begin
   {with FormRegistrarJugador.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end; }
    Form1.Hide();
    FormRegistrarJugador.Show();
end;

end.
