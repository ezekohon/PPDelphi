program Project1;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  PantallaAdministrador in 'PantallaAdministrador.pas' {FormAdministrador},
  UnitRegistrarJugador in 'UnitRegistrarJugador.pas' {FormRegistrarJugador},
  la_arbolbinario in 'Librerias\la_arbolbinario.pas',
  lo_arbolbinario in 'Librerias\lo_arbolbinario.pas',
  lo_pila in 'Librerias\lo_pila.pas',
  la_pila in 'Librerias\la_pila.pas',
  lo_colasparciales in 'Librerias\lo_colasparciales.pas',
  Login in 'Login.pas' {FormLogin},
  lo_hashabierto in 'Librerias\lo_hashabierto.pas',
  abmJuegos in 'abmJuegos.pas' {FormAbmJuegos},
  la_hashabierto in 'Librerias\la_hashabierto.pas',
  abmJugadores in 'abmJugadores.pas' {FormABMJugadores},
  CryptoUtils in 'Helpers\CryptoUtils.pas',
  Cypher in 'Helpers\Cypher.pas',
  PantallaJugador in 'PantallaJugador.pas' {FormJugador},
  EditarPerfilJugador in 'Vistas\Jugadores\EditarPerfilJugador.pas' {FormEditarPerfilJugador},
  JugadoresActivos in 'Vistas\Jugadores\JugadoresActivos.pas' {FormJugadoresActivos},
  lo_dobleEnlace in 'Librerias\lo_dobleEnlace.pas',
  CalendarioJuegos in 'Vistas\Jugadores\CalendarioJuegos.pas' {FormCalendarioJuegos},
  ComprarCartones in 'Vistas\Jugadores\ComprarCartones.pas' {FormComprarCartones},
  la_dobleEnlace in 'Librerias\la_dobleEnlace.pas',
  Globals in 'Helpers\Globals.pas',
  DetalleJuego in 'Vistas\Jugadores\DetalleJuego.pas' {FormDetalleJuego},
  EjecucionJuegoAdmin in 'Vistas\Administrador\EjecucionJuegoAdmin.pas' {EjecucionJuegoAdminForm},
  PruebaCartones in 'Vistas\Pruebas\PruebaCartones.pas' {FormPruebaCartones},
  BolillasRestantes in 'Vistas\Administrador\BolillasRestantes.pas' {FormBolillasRestantes},
  BolillasSacadas in 'Vistas\Administrador\BolillasSacadas.pas' {FormBolillasSacadas},
  FichaJugador in 'Vistas\Administrador\FichaJugador.pas' {FormFichaJugador},
  lo_arboltrinario in 'Librerias\lo_arboltrinario.pas',
  la_arboltrinario in 'Librerias\la_arboltrinario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormAdministrador, FormAdministrador);
  Application.CreateForm(TFormRegistrarJugador, FormRegistrarJugador);
  Application.CreateForm(TFormAbmJuegos, FormAbmJuegos);
  Application.CreateForm(TFormABMJugadores, FormABMJugadores);
  Application.CreateForm(TFormJugador, FormJugador);
  Application.CreateForm(TFormEditarPerfilJugador, FormEditarPerfilJugador);
  Application.CreateForm(TFormJugadoresActivos, FormJugadoresActivos);
  Application.CreateForm(TFormCalendarioJuegos, FormCalendarioJuegos);
  Application.CreateForm(TFormComprarCartones, FormComprarCartones);
  Application.CreateForm(TFormDetalleJuego, FormDetalleJuego);
  Application.CreateForm(TEjecucionJuegoAdminForm, EjecucionJuegoAdminForm);
  Application.CreateForm(TFormPruebaCartones, FormPruebaCartones);
  Application.CreateForm(TFormBolillasRestantes, FormBolillasRestantes);
  Application.CreateForm(TFormBolillasSacadas, FormBolillasSacadas);
  Application.CreateForm(TFormFichaJugador, FormFichaJugador);
  Application.Run;
end.
