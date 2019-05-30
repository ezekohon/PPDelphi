unit EjecucionJuegoAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls,
  lo_hashabierto,
  RTTI, lo_arbolbinario, la_dobleenlace, lo_dobleenlace, la_hashabierto,
  bolillasrestantes, bolillasSacadas,
  la_pila, lo_pila, lo_colasparciales, fichaJugador;

type
  TEjecucionJuegoAdminForm = class(TForm)
    Panel1: TPanel;
    grillaJugadores: TStringGrid;
    grillaGanadores: TStringGrid;
    Label1: TLabel;
    NombreEdit: TEdit;
    Label2: TLabel;
    CantJugadoresEdit: TEdit;
    Label3: TLabel;
    PozoEdit: TEdit;
    Label4: TLabel;
    FechaEdit: TEdit;
    Label5: TLabel;
    HoraEdit: TEdit;
    Label6: TLabel;
    JugadoresLineaEdit: TEdit;
    Panel2: TPanel;
    Label7: TLabel;
    MezclarBolillasButton: TButton;
    BolillasSacadasButton: TButton;
    VerBolillasRestantesButton: TButton;
    Panel3: TPanel;
    Button1: TButton;
    SacarBolillaButton: TButton;
    grillaBolillas: TStringGrid;
    FichaJugadorButton: TButton;
    procedure CargarGrillaJugadores();
    Procedure SetearHeadersJugadores();
    Procedure AgregarReglonJugadores(RD: tRegDatos; IndexRenglon: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure VerBolillasRestantesButtonClick(Sender: TObject);
    procedure MezclarBolillasButtonClick(Sender: TObject);
    procedure SacarBolillaButtonClick(Sender: TObject);
    procedure BolillasSacadasButtonClick(Sender: TObject);
    procedure CargarGrillaBolillas();
    Procedure AgregarCelda(RD: tipodato; IndexRenglon: Integer;
      IndexCol: Integer);
    procedure FichaJugadorButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual: tRegDatosHash;
  end;

var
  EjecucionJuegoAdminForm: TEjecucionJuegoAdminForm;

implementation

{$R *.dfm}

procedure TEjecucionJuegoAdminForm.BolillasSacadasButtonClick(Sender: TObject);
begin
  FormBolillasSacadas.JuegoActual := JuegoActual;
  FormBolillasSacadas.ShowModal;

end;

procedure TEjecucionJuegoAdminForm.Button1Click(Sender: TObject);
var
  reg: tRegDatosHash;
  pos: tPosHash;
begin
  // modificar estado de la partida
  BuscarHash(MeJuego, JuegoActual.nombreEvento, pos);
  CapturarInfoHash(MeJuego, pos, reg);
  reg.estado := NoActivado;
  ModificarHash(MeJuego, pos, reg);

end;

procedure TEjecucionJuegoAdminForm.CargarGrillaJugadores();
var
  // pos: tPosHash;
  i, count: Integer;
  reg: tRegDatos;
begin
  SetearHeadersJugadores;
  count := 1;
  for i := 0 to Ultimo_Archivos(MeJugadores) do
  begin

    ObtenerInfoMe_Archivos(MeJugadores, i, reg);
    if tieneCartonesComprados(reg.clave, JuegoActual.id, mecartones) then
    begin
      AgregarReglonJugadores(reg, count);
      count := count + 1;
    end;

  end;
end;


procedure TEjecucionJuegoAdminForm.FichaJugadorButtonClick(Sender: TObject);
var
  nick: string;
  posIndiceNick: tposarbol;
  posEnDatos: tposarchi;
  reg: tRegDatos;
begin
  // seleccionando una row de la grilla de jugadores, se aprieta este boton y se abre la ficha del jugador
  nick := grillaJugadores.Cells[0, grillaJugadores.Row];
  If (nick <> '') and (grillaJugadores.Row > 0) then
  begin
    if BuscarNodo_Indice(MeNick, nick, posIndiceNick) then
    // simpre true, para buscar la posIndiceID
    begin
      posEnDatos := ObtenerInfo_Indice(MeNick, posIndiceNick).posEnDatos;
      ObtenerInfoMe_Archivos(MeJugadores, posEnDatos, reg);
    end;
  end
  else
    ShowMessage('Seleccione un jugador de la grilla para visualizar su ficha.');

  FormFichaJugador.juegoActual := juegoActual;
  FormFichaJugador.JugadorActual := reg;
  FormFichaJugador.ShowModal;
end;

procedure TEjecucionJuegoAdminForm.FormShow(Sender: TObject);
var
  cantJug: Integer;
begin
  cantJug := cantidadJugadoresEnJuego(JuegoActual.id, mecartones);

  NombreEdit.Text := JuegoActual.nombreEvento;
  CantJugadoresEdit.Text := IntToStr(cantJug);
  PozoEdit.Text := FloatToStr(JuegoActual.PozoAcumulado);
  FechaEdit.Text := DateTimeToStr(JuegoActual.fechaEvento);

  CargarGrillaJugadores;
  CargarGrillaBolillas;
end;

procedure TEjecucionJuegoAdminForm.MezclarBolillasButtonClick(Sender: TObject);
begin
  mezclarBolillas(MeBOLILLERO);
end;

procedure TEjecucionJuegoAdminForm.SacarBolillaButtonClick(Sender: TObject);
var
  reg: lo_pila.tdatopila;
  regCola: TipoDato;
begin

  if (lo_pila.cantidadElemEnPila(MeBOLILLERO) > 0) then
  begin
    lo_pila.tope(MeBOLILLERO, reg);
    if lo_pila.cantidadElemEnPila(MeBOLILLERO) = 1 then
    begin
      MessageDlg('�ltima bolilla: ' + IntToStr(reg.Numero) +
        ' Juego finalizado!', mtInformation, [mbOk], 0, mbOk);
      // Cambiar estado del juego?
      finalizarJuego(JuegoActual.nombreEvento);
    end
    else
    begin
      MessageDlg('Bolilla sacada: ' + IntToStr(reg.Numero) +
        ' Bolillas restantes: ' +
        IntToStr(lo_pila.cantidadElemEnPila(MeBOLILLERO) - 1), mtInformation,
        [mbOk], 0, mbOk);

    end;

    desapilar(MeBOLILLERO);
    // encolar tiradas
    regCola.enlace:= reg.enlace;
    regCola.numero:= reg.numero;
    encolar(MeTIRADAS, regCola, JuegoActual.id);

    //ACA FALTA TODA LA LOGICA DEL JUEGO
    //recorrer todos los cartones en juego y ejecutar 'tienePremio' de la_dobleEnlace
    //

    CargarGrillaBolillas;
  end
  else
  begin
    MessageDlg('No quedan bolillas restantes por sacar!', mtInformation,
      [mbOk], 0, mbOk);
  end;

end;

Procedure TEjecucionJuegoAdminForm.SetearHeadersJugadores();
Begin
  with grillaJugadores do
  Begin
    // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');

    Cells[0, 0] := 'JUGADOR';
    Cells[1, 0] := 'ESTADO';
    Cells[2, 0] := 'CARTONES';
  End;
End;

procedure TEjecucionJuegoAdminForm.VerBolillasRestantesButtonClick
  (Sender: TObject);
begin
  FormBolillasRestantes.ShowModal;
end;

Procedure TEjecucionJuegoAdminForm.AgregarReglonJugadores(RD: tRegDatos;
  IndexRenglon: Integer);
Begin

  with grillaJugadores do
  Begin
    Cells[0, IndexRenglon] := RD.nick;
    Cells[1, IndexRenglon] := TRttiEnumerationType.GetName(RD.estado);
    Cells[2, IndexRenglon] := IntToStr(cantidadCartonesComprados(RD.clave,
      JuegoActual.id, mecartones));

    FixedRows := 1;
  End;

End;

// FALTA ME GANADORES
{
  procedure TEjecucionJuegoAdminForm.CargarGrillaGanadores();
  var
  //pos: tPosHash;
  i, count: integer;
  reg: tRegDatosHash;
  begin
  SetearHeadersGanadores;
  count := 1;
  for i := 0 to lo_hashabierto.Ultimo(MeJuego) do
  begin
  CapturarInfoHash(MeJuego,i,reg);
  if ((reg.estado = NoJugado)  or (reg.estado = Jugando)) then
  begin
  AgregarReglonJugadores(reg,count);
  count:= count + 1;
  end;
  end;
  end;


  Procedure TEjecucionJuegoAdminForm.SetearHeadersGanadores();
  Begin
  with grillaGanadores do
  Begin
  // T�tulo de las columnas
  ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');
  ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');

  Cells[0, 0] := 'NOMBRE EVENTO';
  Cells[1, 0] := 'FECHA';
  Cells[2, 0] := 'POZO ACUMULADO';
  Cells[3, 0] := 'CARTONES VENDIDOS';

  End;
  End;

  Procedure TEjecucionJuegoAdminForm.AgregarReglonGanadores (RD: tRegDatosHash; IndexRenglon:Integer);
  Begin

  with grillaGanadores do
  Begin
  Cells[0, IndexRenglon] := RD.nombreEvento;
  Cells[1, IndexRenglon] := DateTimeToStr(RD.fechaEvento);
  Cells[2, IndexRenglon] := IntToStr(RD.PozoAcumulado);//TRttiEnumerationType.GetName( RD.estado);
  Cells[3, IndexRenglon] := IntToStr(RD.TotalCartonesVendidos);//IntToStr(RD.TotalCartonesVendidos);

  FixedRows:=1;
  End;

  End;
}

procedure TEjecucionJuegoAdminForm.CargarGrillaBolillas();
var
  i, cantSacadas, Row, col: Integer;
  reg, raux: tipodato;
  arr: array of Integer;
begin
  cantSacadas := lo_colasparciales.cantidadElementos(MeTIRADAS, JuegoActual.id);

  for i := 0 to cantSacadas - 1 do
  begin
    col := i mod 15;
    Row := i div 15;
    if not lo_colasparciales.colaVacia(MeTIRADAS, JuegoActual.id) then
    begin
      lo_colasparciales.tope(MeTIRADAS, reg, JuegoActual.id);
      decolar(MeTIRADAS, JuegoActual.id);

      SetLength(arr, Length(arr) + 1);
      arr[Length(arr) - 1] := reg.Numero;

      AgregarCelda(reg, Row, col);

    end;
  end;

  for i := Low(arr) to High(arr) do
  begin
    raux.Numero := arr[i];
    encolar(MeTIRADAS, raux, JuegoActual.id);
  end;
end;

Procedure TEjecucionJuegoAdminForm.AgregarCelda(RD: tipodato;
  IndexRenglon: Integer; IndexCol: Integer);
Begin

  with grillaBolillas do
  Begin
    Cells[IndexCol, IndexRenglon] := IntToStr(RD.Numero);

    FixedRows := 1;
  End;

End;

end.
