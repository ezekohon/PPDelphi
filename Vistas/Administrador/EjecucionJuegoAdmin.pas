unit EjecucionJuegoAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls,
  lo_hashabierto,
  RTTI, lo_arbolbinario, la_dobleenlace, lo_dobleenlace, la_hashabierto,
  bolillasrestantes, bolillasSacadas,
  la_pila, lo_pila, lo_colasparciales, fichaJugador, Globals,
  la_arboltrinario, listadoJugadores, lo_arboltrinario;

type

  recGanadorCarton = record
    idGanador: string;
    idCarton: Integer;
  end;

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
    listadoJugadoresButton: TButton;
    Timer1: TTimer;
    PausaButton: TButton;
    procedure CargarGrillaJugadores();
    Procedure SetearHeadersJugadores();
    Procedure AgregarReglonJugadores(RD: tRegDatos);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure VerBolillasRestantesButtonClick(Sender: TObject);
    procedure MezclarBolillasButtonClick(Sender: TObject);
    procedure SacarBolillaButtonClick(Sender: TObject);
    procedure BolillasSacadasButtonClick(Sender: TObject);
    procedure CargarGrillaBolillas();
    Procedure AgregarCelda(RD: tipodato; IndexRenglon: Integer;
      IndexCol: Integer);
    Procedure SetearHeadersGanadores();
    // Procedure AgregarReglonGanadores(RD: tRegDatosHash);
    procedure CargarGrillaGanadores();
    procedure FichaJugadorButtonClick(Sender: TObject);
    Procedure InOrdenArbolBi(Arbol: MeArbol; Raiz: tPosArbol);
    Procedure InOrdenArbolTri(Arbol: tMeIndiceTri; Raiz: tPosTri);
    procedure LimpiarGrillaJugadores();
    procedure LimpiarGrillaBolillas();
    procedure LimpiarGrillaGanadores();
    procedure listadoJugadoresButtonClick(Sender: TObject);
    procedure modoVirtualizacionManual();
    procedure SacarBolillaModoNormal();
    procedure SacarBolillaModoVManual();
    procedure modoNormal();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SacarBolillaModoVAutomatica();
    procedure modoVirtualizacionAutomatica();
    procedure PausaButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure togglePausarVirtualizacion();
    procedure pausarVirtualizacion();
    procedure reanudarVirtualizacion();

  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual: tRegDatosHash;
    ModoEjecucion: tModoEjecucion;
    Pausado: boolean;

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
  { count := 1;
    for i := 0 to Ultimo_Archivos(MeJugadores) do
    begin

    ObtenerInfoMe_Archivos(MeJugadores, i, reg);
    if isTieneCartonesComprados(reg.clave, JuegoActual.id, mecartones) then
    begin
    AgregarReglonJugadores(reg, count);
    count := count + 1;
    end;

    end; }
  InOrdenArbolBi(MeNick, Raiz_Indice(MeNick));
end;

Procedure TEjecucionJuegoAdminForm.InOrdenArbolBi(Arbol: MeArbol;
  Raiz: tPosArbol);
var
  RD: tRegDatos;
  N: tNodoIndice;
begin
  If Raiz = PosNula_Indice(Arbol) then
    exit;

  // Primero recursivo tendiendo a la Izquierda
  InOrdenArbolBi(Arbol, ProximoIzq_Indice(Arbol, Raiz));

  // Guardo en N el nodo indice.
  N := ObtenerInfo_Indice(Arbol, Raiz);

  // De N utilizo la posicion en Clientes para leer el registro.
  ObtenerInfoMe_Archivos(MeJugadores, N.PosEnDatos, RD);

  if isTieneCartonesComprados(RD.clave, JuegoActual.nombreEvento, mecartones)
  then
    AgregarReglonJugadores(RD);


  // Recursividad tendiendo a la Derecha.

  InOrdenArbolBi(Arbol, ProximoDer_Indice(Arbol, Raiz));

end;

Procedure TEjecucionJuegoAdminForm.InOrdenArbolTri(Arbol: tMeIndiceTri;
  Raiz: tPosTri);
var
  N: tNodoIndiceTri;
  /// ///////--INTERNO--//////////////////////////////////////////////
  Procedure AgregarReglonGanadores(cabecera: Integer; idGanador: string);
  { Metodo Recursivo }
  var
    RD: tdatopila;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);
      AgregarReglonGanadores(cabecera, idGanador);

      with grillaGanadores do
      Begin
        RowCount := RowCount + 1;
        Cells[0, RowCount - 1] := getNickJugadorConIdGanador(idGanador);
        Cells[1, RowCount - 1] := TRttiEnumerationType.GetName(RD.tipoPremio);
        Cells[2, RowCount - 1] := IntToStr(RD.idCarton);
        Cells[3, RowCount - 1] := floattostr(RD.importe);

        FixedRows := 1;
      End;

      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

/// ///////--INTERNO--//////////////////////////////////////////////
begin
  If Raiz = PosNula_tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  InOrdenArbolTri(Arbol, ProximoIzq_Tri(Arbol, Raiz));
  // Guardo en N el nodo indice.
  ObtenerNodo(Arbol, Raiz, N);

  // De N utilizo la posicion en Clientes para leer el registro.
  // ObtenerInfoMe_Archivos(MeJugadores, N.PosEnDatos, RD);

  if esJuegoBuscado(N.idGanador, JuegoActual.nombreEvento) then
  begin
    // recorrer la pila y llamar a agregarRenglon por cada premio en pila
    AgregarReglonGanadores(N.hm, N.idGanador);
  end;



  // Recursividad tendiendo a la Derecha.

  InOrdenArbolTri(Arbol, ProximoDer_Tri(Arbol, Raiz));

end;

procedure TEjecucionJuegoAdminForm.FichaJugadorButtonClick(Sender: TObject);
var
  nick: string;
  posIndiceNick: tPosArbol;
  PosEnDatos: tposarchi;
  reg: tRegDatos;
begin
  // seleccionando una row de la grilla de jugadores, se aprieta este boton y se abre la ficha del jugador
  nick := grillaJugadores.Cells[0, grillaJugadores.Row];
  If (nick <> '') and (grillaJugadores.Row > 0) then
  begin
    if BuscarNodo_Indice(MeNick, nick, posIndiceNick) then
    // simpre true, para buscar la posIndiceID
    begin
      PosEnDatos := ObtenerInfo_Indice(MeNick, posIndiceNick).PosEnDatos;
      ObtenerInfoMe_Archivos(MeJugadores, PosEnDatos, reg);
    end;
    if ModoEjecucion = VAutomatica then
      pausarVirtualizacion;

    FormFichaJugador.JuegoActual := JuegoActual;
    FormFichaJugador.JugadorActual := reg;
    FormFichaJugador.ShowModal;
  end
  else
    ShowMessage('Seleccione un jugador de la grilla para visualizar su ficha.');

end;

procedure TEjecucionJuegoAdminForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  regCola: tipodato;
begin
  if ((ModoEjecucion = VManual) or (ModoEjecucion = VAutomatica)) then
  begin
    while not colaVacia(MeTiradasVirtualizacion, JuegoActual.id) do
    begin
      Tope(MeTiradasVirtualizacion, regCola, JuegoActual.id);
      decolar(MeTiradasVirtualizacion, JuegoActual.id);
      encolar(MeTiradas, regCola, JuegoActual.id);
    end;
  end;
    Timer1.Enabled := false;
end;

procedure TEjecucionJuegoAdminForm.FormShow(Sender: TObject);
var
  cantJug: Integer;
begin
  if ModoEjecucion = Normal then
    modoNormal;
  if ModoEjecucion = VManual then
    modoVirtualizacionManual;
  if ModoEjecucion = VAutomatica then
    modoVirtualizacionAutomatica;

  cantJug := cantidadJugadoresEnJuego(JuegoActual.nombreEvento, mecartones);

  NombreEdit.Text := JuegoActual.nombreEvento;
  CantJugadoresEdit.Text := IntToStr(cantJug);
  PozoEdit.Text := floattostr(JuegoActual.PozoAcumulado);
  FechaEdit.Text := DateTimeToStr(JuegoActual.fechaEvento);

  LimpiarGrillaJugadores;
  CargarGrillaJugadores;
  LimpiarGrillaBolillas;
  CargarGrillaBolillas;
  LimpiarGrillaGanadores;
  CargarGrillaGanadores;
end;

procedure TEjecucionJuegoAdminForm.MezclarBolillasButtonClick(Sender: TObject);
begin
  mezclarBolillas(MeBOLILLERO);
end;

procedure TEjecucionJuegoAdminForm.SacarBolillaButtonClick(Sender: TObject);
begin
  if ModoEjecucion = Normal then
  begin
    SacarBolillaModoNormal;
  end;
  if ModoEjecucion = VManual then
  begin
    SacarBolillaModoVManual;
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

procedure TEjecucionJuegoAdminForm.Timer1Timer(Sender: TObject);
begin
  SacarBolillaModoVAutomatica;
end;

procedure Delay(dwMilliseconds: DWORD); { Similar al Windows.Sleep }
var
  ATickCount: DWORD;
begin
  ATickCount := GetTickCount64 + dwMilliseconds;
  while ATickCount > GetTickCount64 do
    Application.ProcessMessages;
end;

procedure TEjecucionJuegoAdminForm.VerBolillasRestantesButtonClick
  (Sender: TObject);
begin
  FormBolillasRestantes.ShowModal;
end;

Procedure TEjecucionJuegoAdminForm.AgregarReglonJugadores(RD: tRegDatos);
// IndexRenglon: Integer);
Begin

  with grillaJugadores do
  Begin
    RowCount := RowCount + 1;
    Cells[0, RowCount - 1] := RD.nick;
    Cells[1, RowCount - 1] := TRttiEnumerationType.GetName(RD.estado);
    Cells[2, RowCount - 1] := IntToStr(cantidadCartonesComprados(RD.clave,
      JuegoActual.nombreEvento, mecartones));

    FixedRows := 1;
  End;

End;

procedure TEjecucionJuegoAdminForm.CargarGrillaGanadores();
var
  // pos: tPosHash;
  i, count: Integer;
  reg: tRegDatosHash;
begin
  SetearHeadersGanadores;
  InOrdenArbolTri(MeIndiceGanadores,
    lo_arboltrinario.raiz_tri(MeIndiceGanadores));
end;

Procedure TEjecucionJuegoAdminForm.SetearHeadersGanadores();
Begin
  with grillaGanadores do
  Begin
    // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxx');
    ColWidths[3] := Canvas.TextWidth('xxxxxxxxx');

    Cells[0, 0] := 'NICK GANADOR';
    Cells[1, 0] := 'PREMIO';
    Cells[2, 0] := 'ID CARTON';
    Cells[3, 0] := 'IMPORTE';

  End;
End;

procedure TEjecucionJuegoAdminForm.CargarGrillaBolillas();
var
  i, cantSacadas, Row, col: Integer;
  reg, raux: tipodato;
  arr: array of Integer;
begin
  cantSacadas := lo_colasparciales.cantidadElementos(MeTiradas, JuegoActual.id);

  for i := 0 to cantSacadas - 1 do
  begin
    col := i mod 15;
    Row := i div 15;
    if not lo_colasparciales.colaVacia(MeTiradas, JuegoActual.id) then
    begin
      lo_colasparciales.Tope(MeTiradas, reg, JuegoActual.id);
      decolar(MeTiradas, JuegoActual.id);

      SetLength(arr, Length(arr) + 1);
      arr[Length(arr) - 1] := reg.Numero;

      AgregarCelda(reg, Row, col);

    end;
  end;

  for i := Low(arr) to High(arr) do
  begin
    raux.Numero := arr[i];
    encolar(MeTiradas, raux, JuegoActual.id);
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

procedure TEjecucionJuegoAdminForm.LimpiarGrillaJugadores();
var
  i: Integer;
begin
  for i := 0 to grillaJugadores.RowCount - 1 do
    grillaJugadores.Rows[i].Clear;
  grillaJugadores.RowCount := 1;
end;

procedure TEjecucionJuegoAdminForm.LimpiarGrillaGanadores();
var
  i: Integer;
begin
  for i := 0 to grillaGanadores.RowCount - 1 do
    grillaGanadores.Rows[i].Clear;
  grillaGanadores.RowCount := 1;
end;

procedure TEjecucionJuegoAdminForm.listadoJugadoresButtonClick(Sender: TObject);
begin
  if ModoEjecucion = VAutomatica then
    pausarVirtualizacion;

  FormListadoJugadores.JuegoActual := JuegoActual;
  FormListadoJugadores.ShowModal;
end;

procedure TEjecucionJuegoAdminForm.LimpiarGrillaBolillas();
var
  i: Integer;
begin
  for i := 0 to grillaBolillas.RowCount - 1 do
    grillaBolillas.Rows[i].Clear;
  grillaBolillas.RowCount := 5;
end;

procedure TEjecucionJuegoAdminForm.SacarBolillaModoNormal();

var
  reg: lo_pila.tdatopila;
  regCola: tipodato;
  i, cantGanadoresPremio: Integer;
  regCarton: tRegDatos_DE;
  isNumeroTachado, isTienePremio: boolean;
  tipoPremio: tTipoPremio;
  claveGanador: string;
  importePremio: real;
  regJuego: tRegDatosHash;
  posHash: tPosHash;
  arrGanadores: array of recGanadorCarton;

begin

  if (lo_pila.cantidadElemEnPila(MeBOLILLERO) > 0) then
  begin
    lo_pila.Tope(MeBOLILLERO, reg);
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

    Desapilar(MeBOLILLERO);
    // encolar tiradas
    regCola.enlace := reg.enlace;
    regCola.Numero := reg.Numero;
    encolar(MeTiradas, regCola, JuegoActual.id);

    {
      // LOGICA DEL JUEGO
      i := lo_dobleenlace.Primero(mecartones);
      while i <> _posnula do
      // recorro todos los cartones
      begin
      regCarton := CapturarInfo(mecartones, i);
      // si el carton pertenece al juego
      if regCarton.nombreEvento = JuegoActual.nombreEvento then
      begin
      isNumeroTachado := tacharNumeroSiEstaEnCarton(regCarton, i, reg.Numero);
      if isNumeroTachado then
      begin

      isTienePremio := verificarYDevolverSiCartonTienePremio(regCarton,
      tipoPremio);
      // tipoPremio es parameter out
      if isTienePremio then
      begin
      BuscarHash(MeJuego, regCarton.nombreEvento, posHash);
      CapturarInfoHash(MeJuego, posHash, regJuego);

      // insertar ganador
      claveGanador := generarClaveGanador(regCarton.idJugador,
      regCarton.nombreEvento);

      importePremio := la_arboltrinario.importePorTipoPremio(regJuego,
      tipoPremio);
      restarPremioAPozoAcumulado(regJuego, importePremio);
      modificarPremioEntregado(regJuego, tipoPremio);
      AltaGanador(claveGanador, tipoPremio, importePremio,
      regCarton.idCarton);

      // actualizar grilla ganadores
      // agregar a algun lado para mostrar en jugador?
      end;
      end;
      end;

      i := lo_dobleenlace.Proximo(mecartones, i);

      end;
    }
    cantGanadoresPremio := 0;
    for tipoPremio := Low(tTipoPremio) to High(tTipoPremio) do
    begin
      i := lo_dobleenlace.Primero(mecartones);
      while i <> _posnula do
      // recorro todos los cartones
      begin
        regCarton := CapturarInfo(mecartones, i);
        // si el carton pertenece al juego
        if regCarton.nombreEvento = JuegoActual.nombreEvento then
        begin
          isNumeroTachado := tacharNumeroSiEstaEnCarton(regCarton, i,
            reg.Numero);
          if isNumeroTachado then
          begin
            isTienePremio := verificarYDevolverSiCartonTienePremio(regCarton,
              tipoPremio);
            // tipoPremio es parameter out
            if isTienePremio then
            begin
              // si tiene premio, guardo en un array para agregar despues
              SetLength(arrGanadores, Length(arrGanadores) + 1);
              arrGanadores[Length(arrGanadores) - 1].idGanador :=
                generarClaveGanador(regCarton.idJugador,
                regCarton.nombreEvento);
              arrGanadores[Length(arrGanadores) - 1].idCarton :=
                regCarton.idCarton;
            end;
          end;
        end;
        i := lo_dobleenlace.Proximo(mecartones, i);
      end;

      // aca insertar ganadores teniendo en cuenta si hay mas de uno
      if Length(arrGanadores) > 0 then
      begin
        cantGanadoresPremio := Length(arrGanadores);

        BuscarHash(MeJuego, regCarton.nombreEvento, posHash);
        CapturarInfoHash(MeJuego, posHash, regJuego);
        importePremio := la_arboltrinario.importePorTipoPremio(regJuego,
          tipoPremio);
        restarPremioAPozoAcumulado(regJuego, importePremio);
        for i := Low(arrGanadores) to High(arrGanadores) do
        begin
          AltaGanador(arrGanadores[i].idGanador, tipoPremio,
            importePremio / cantGanadoresPremio, arrGanadores[i].idCarton);

        end;
        modificarPremioEntregado(regJuego, tipoPremio);
      end;

      // vaciar el array
      SetLength(arrGanadores, 0);

    end;
    CargarGrillaBolillas;
    LimpiarGrillaGanadores;
    CargarGrillaGanadores;
  end
  else
  begin
    MessageDlg('No quedan bolillas restantes por sacar!', mtInformation,
      [mbOk], 0, mbOk);
  end;

end;

procedure TEjecucionJuegoAdminForm.SacarBolillaModoVManual();
var
  primerNumero: Integer;
  regCola: tipodato;
  primeroSacado: boolean;
begin
  // tope(MeTIRADASVirtualizacion,regCola,juegoactual.id);
  // primerNumero := regCola.Numero;
  // primeroSacado := true;

  if cantidadElementos(MeTiradas, JuegoActual.id) < 75 then
  // ((regCola.numero <> primerNumero) or (not primeroSacado)) do
  begin
    Tope(MeTiradasVirtualizacion, regCola, JuegoActual.id);
    decolar(MeTiradasVirtualizacion, JuegoActual.id);
    encolar(MeTiradas, regCola, JuegoActual.id);
  end;
  CargarGrillaBolillas;
end;

procedure TEjecucionJuegoAdminForm.modoVirtualizacionManual();
var
  regCola: tipodato;
begin
  MezclarBolillasButton.enabled := false;
  BolillasSacadasButton.enabled := false;
  VerBolillasRestantesButton.enabled := false;
  // insertarCabeceraControl(MeTiradasVirtualizacion, JuegoActual.id);

  while not colaVacia(MeTiradas, JuegoActual.id) do
  begin
    Tope(MeTiradas, regCola, JuegoActual.id);
    decolar(MeTiradas, JuegoActual.id);
    encolar(MeTiradasVirtualizacion, regCola, JuegoActual.id);
  end;

end;

procedure TEjecucionJuegoAdminForm.togglePausarVirtualizacion();
begin
  if Timer1.enabled then
  begin
    pausarVirtualizacion
  end
  else
  begin
    reanudarVirtualizacion;
  end;
end;

procedure TEjecucionJuegoAdminForm.pausarVirtualizacion();
begin

  Timer1.enabled := false;
  PausaButton.Caption := 'Reanudar';

end;

procedure TEjecucionJuegoAdminForm.reanudarVirtualizacion();
begin

  Timer1.enabled := true;
  PausaButton.Caption := 'Pausar';

end;

procedure TEjecucionJuegoAdminForm.PausaButtonClick(Sender: TObject);
begin
  togglePausarVirtualizacion;
end;

procedure TEjecucionJuegoAdminForm.SacarBolillaModoVAutomatica();
var
  primerNumero: Integer;
  regCola: tipodato;
  primeroSacado: boolean;
begin
  // tope(MeTIRADASVirtualizacion,regCola,juegoactual.id);
  // primerNumero := regCola.Numero;
  // primeroSacado := true;

  if cantidadElementos(MeTiradas, JuegoActual.id) < 75 then
  // ((regCola.numero <> primerNumero) or (not primeroSacado)) do
  begin
    Tope(MeTiradasVirtualizacion, regCola, JuegoActual.id);
    decolar(MeTiradasVirtualizacion, JuegoActual.id);
    encolar(MeTiradas, regCola, JuegoActual.id);
  end;
  CargarGrillaBolillas;
end;

procedure TEjecucionJuegoAdminForm.modoVirtualizacionAutomatica();
var
  regCola: tipodato;
begin
  MezclarBolillasButton.enabled := false;
  BolillasSacadasButton.enabled := false;
  VerBolillasRestantesButton.enabled := false;
  SacarBolillaButton.enabled := false;
  SacarBolillaButton.visible := false;
  PausaButton.visible := true;
  Timer1.enabled := true;

  while not colaVacia(MeTiradas, JuegoActual.id) do
  begin
    Tope(MeTiradas, regCola, JuegoActual.id);
    decolar(MeTiradas, JuegoActual.id);
    encolar(MeTiradasVirtualizacion, regCola, JuegoActual.id);
  end;

end;

procedure TEjecucionJuegoAdminForm.modoNormal();
begin
  MezclarBolillasButton.enabled := true;
  BolillasSacadasButton.enabled := true;
  VerBolillasRestantesButton.enabled := true;
end;

end.
