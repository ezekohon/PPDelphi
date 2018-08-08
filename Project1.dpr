program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitRegistrarJugador in 'UnitRegistrarJugador.pas' {FormRegistrarJugador},
  la_arbolbinario in 'Librerias\la_arbolbinario.pas',
  lo_arbolbinario in 'Librerias\lo_arbolbinario.pas',
  lo_pila in 'Librerias\lo_pila.pas',
  la_pila in 'Librerias\la_pila.pas',
  lo_colasparciales in 'Librerias\lo_colasparciales.pas',
  Login in 'Login.pas' {Form2},
  lo_hashabierto in 'Librerias\lo_hashabierto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormRegistrarJugador, FormRegistrarJugador);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
