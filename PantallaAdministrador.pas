unit PantallaAdministrador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitRegistrarJugador, abmJuegos, Vcl.Menus, abmJugadores;

type
  TFormAdministrador = class(TForm)
    MainMenu1: TMainMenu;
    Acciones1: TMenuItem;
    RegistrarJugador1: TMenuItem;
    ABMJuegos1: TMenuItem;
    ABMJuegadores: TMenuItem;
    procedure RegistrarJugador1Click(Sender: TObject);
    procedure ABMJuegos1Click(Sender: TObject);
    procedure ABMJuegadoresClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAdministrador: TFormAdministrador;

implementation

{$R *.dfm}

procedure TFormAdministrador.ABMJuegadoresClick(Sender: TObject);
begin
     FormAdministrador.Hide();
     FormAbmJugadores.Show();
end;

procedure TFormAdministrador.ABMJuegos1Click(Sender: TObject);
begin
    FormAdministrador.Hide();
    FormAbmJuegos.Show();
end;

procedure TFormAdministrador.RegistrarJugador1Click(Sender: TObject);
begin
   {with FormRegistrarJugador.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end; }
    FormAdministrador.Hide();
    FormRegistrarJugador.Show();
end;

end.
