unit PantallaAdministrador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitRegistrarJugador, abmJuegos,
  Vcl.Menus, abmJugadores,
  Vcl.Grids, Vcl.StdCtrls, lo_hashabierto, lo_dobleEnlace, LO_ArbolBinario,
  EjecucionJuegoAdmin,
  Rtti, la_hashabierto, lo_pila, lo_colasparciales, lo_arboltrinario;

type
  TFormAdministrador = class(TForm)
    MainMenu1: TMainMenu;
    Acciones1: TMenuItem;
    RegistrarJugador1: TMenuItem;
    ABMJuegos1: TMenuItem;
    ABMJuegadores: TMenuItem;
    Label1: TLabel;
    grilla: TStringGrid;
    procedure RegistrarJugador1Click(Sender: TObject);
    procedure ABMJuegos1Click(Sender: TObject);
    procedure ABMJuegadoresClick(Sender: TObject);
    procedure CargarGrilla();
    procedure LimpiarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon(RD: tRegDatosHash; IndexRenglon: Integer);
    procedure grillaDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

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
  // FormAdministrador.Hide();
  // FormAbmJugadores.Show();
  FormAbmJugadores.ShowModal;
end;

procedure TFormAdministrador.ABMJuegos1Click(Sender: TObject);
begin
  // FormAdministrador.Hide();
  // FormAbmJuegos.Show();
  FormAbmJuegos.ShowModal;
  LimpiarGrilla;
  CargarGrilla;
end;

procedure TFormAdministrador.RegistrarJugador1Click(Sender: TObject);
begin

  // FormAdministrador.Hide();
  // FormRegistrarJugador.Show();
  FormRegistrarJugador.ShowModal;
end;

procedure TFormAdministrador.CargarGrilla();
var
  // pos: tPosHash;
  i, count: Integer;
  pos: tPosHash;
  reg: tRegDatosHash;
begin
  SetearHeaders;
  count := 1;
  Pos:=lo_hashabierto.Primero (MeJuego);
  While pos <> _posnula do
  begin
    CapturarInfoHash(MeJuego, pos, reg);
    if ((reg.estado = NoActivado) or (reg.estado = Jugando) or
      (reg.estado = Finalizado)) then
    begin
      AgregarReglon(reg, count);
      count := count + 1;
      pos:=lo_hashabierto.Proximo(MeJuego,pos);
    end
    else
    begin
      pos:=lo_hashabierto.Proximo(MeJuego,pos);
    end;
  end;
end;

procedure TFormAdministrador.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CerrarMe_Archivos(MeJUGADORES);
  Cerrarme_indice(MeID);
  lo_dobleEnlace.Cerrarme(MeCartones);
  CerrarMe_Hash(MeJuego);
  lo_pila.Cerrarme(MeBolillero);
  lo_colasparciales.Cerrarme(metiradas);
  lo_arboltrinario.Cerrar_ArbolTri(MeIndiceGanadores);
  lo_pila.Cerrarme(MePilaGanadores);
end;

procedure TFormAdministrador.FormShow(Sender: TObject);
begin
  AbrirMe_Archivos(MeJUGADORES);
  AbrirMe_Indice(MeID);
  lo_dobleEnlace.AbrirMe(MeCartones);
  AbrirMe_Hash(MeJuego);
  lo_pila.AbrirMe(MeBolillero);
  lo_colasparciales.AbrirMe(metiradas);
  lo_arboltrinario.Abrir_ArbolTri(MeIndiceGanadores);
  lo_pila.Abrirme(MePilaGanadores);
  CargarGrilla;
end;

procedure TFormAdministrador.grillaDblClick(Sender: TObject);
var
  nombreEvento, nEventoJugando: string;
  pos: tPosHash;
  reg: tRegDatosHash;
begin
  nombreEvento := grilla.Cells[0, grilla.Row];
  if hayPartidaJugando(MeJuego, nEventoJugando) then
  begin
    if nEventoJugando = nombreEvento then
    begin
      BuscarHash(MeJuego, nombreEvento, pos);
      CapturarInfoHash(MeJuego, pos, reg);
      EjecucionJuegoAdminForm.JuegoActual := reg;
      EjecucionJuegoAdminForm.ShowModal;
      LimpiarGrilla;
      CargarGrilla;
    end
    else
      messagedlg('Hay otra partida jugando!', mtCustom, [mbOK], 0);
  end
  else
  begin
    // no hay partida jugando. Cambio el estado de la clickeada a Jugando
    BuscarHash(MeJuego, nombreEvento, pos);
    CapturarInfoHash(MeJuego, pos, reg);
    if reg.estado = tEstadoJuego.NoActivado then
    begin
      empezarJuego(nombreEvento);
      EjecucionJuegoAdminForm.JuegoActual := reg;
      EjecucionJuegoAdminForm.ShowModal;
      LimpiarGrilla;
      CargarGrilla;
    end
    else
    begin
      messagedlg('Este juego no se encuentra en condiciones de comenzar!',
        mtCustom, [mbOK], 0);
    end;

  end;

end;

Procedure TFormAdministrador.SetearHeaders();
Begin
  with grilla do
  Begin
    // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');
    ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');
    ColWidths[4] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');
    Cells[0, 0] := 'NOMBRE EVENTO';
    Cells[1, 0] := 'FECHA';
    Cells[2, 0] := 'POZO ACUMULADO';
    Cells[3, 0] := 'CARTONES VENDIDOS';
    Cells[4, 0] := 'ESTADO';
  End;
End;

Procedure TFormAdministrador.AgregarReglon(RD: tRegDatosHash;
  IndexRenglon: Integer);
Begin

  with grilla do
  Begin
    Cells[0, IndexRenglon] := RD.nombreEvento;
    Cells[1, IndexRenglon] := DateTimeToStr(RD.fechaEvento);
    Cells[2, IndexRenglon] := FloatToStr(RD.PozoAcumulado);
    // TRttiEnumerationType.GetName( RD.estado);
    Cells[3, IndexRenglon] := IntToStr(RD.TotalCartonesVendidos);
    // IntToStr(RD.TotalCartonesVendidos);
    Cells[4, IndexRenglon] := TRttiEnumerationType.GetName(RD.estado);
    FixedRows := 1;
  End;

End;

procedure TFormAdministrador.LimpiarGrilla();
var
  i: Integer;
begin
  for i := 0 to grilla.RowCount - 1 do
    grilla.Rows[i].Clear;
  grilla.RowCount := 100;
end;

end.
