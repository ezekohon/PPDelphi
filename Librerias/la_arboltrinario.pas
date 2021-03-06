unit la_arboltrinario; // GANADORES

interface

uses
  SysUtils, StrUtils, lo_arboltrinario, lo_pila, lo_hashabierto,
  lo_arbolbinario, Dialogs, globals,rtti,lo_colasparciales;

function generarClaveGanador(idUsuario: tidusuario;
  nombreEvento: string): string;
Function AltaGanador(claveBusqueda: string; tipoPremio: tTipoPremio;
  importe: real; idCarton: integer): Boolean;
procedure restarPremioAPozoAcumulado(juego: tRegDatosHash; importePremio: real);
function importePorTipoPremio(juego: tRegDatosHash;
  tipoPremio: tTipoPremio): real;
function esJuegoBuscado(claveBusqueda: string; nombreEvento: string): Boolean;
function esJugadorBuscado(claveBusqueda: string; idJugador: string): Boolean;
function getJugadorConGanador(claveBusqueda: string): string;
function espremioYaEntregadoAGanador(cabeceraPila: integer;
  tipoPremio: tTipoPremio): Boolean;

function contarPremiosGanadorEnJuego(meGanadores: tMeIndiceTri;
  nombreEvento: string; idJugador: string): integer;
function sumarPremiosGanadorEnJuego(meGanadores: tMeIndiceTri;
  nombreEvento: string; idJugador: string): real;
function contarPremiosCarton(meGanadores: tMeIndiceTri; nombreEvento: string;
  idJugador: string; idCarton: integer): integer;
function sumarPremiosCarton(meGanadores: tMeIndiceTri; nombreEvento: string;
  idJugador: string; idCarton: integer): real;
procedure InOrderContarPremiosAcumuladosTotales(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador: string; var cuenta: integer);
procedure InOrderSumarPremiosAcumuladosTotales(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador: string; var suma: real);
  function getNickJugadorConIdGanador(claveBusqueda: string): string;
  procedure InOrderIsGanadorObtuvoPremio(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador:string;premio:string; var premioGanado:boolean);
 Procedure isJugadorGanoBingo(var premioGanado: boolean; cabecera: integer;out idCarton: integer; out importe:real);



implementation

Function AltaGanador(claveBusqueda: string; tipoPremio: tTipoPremio;
  importe: real; idCarton: integer): Boolean;
Var
  PosTri: tPosTri;
  Reg: tDatoPila;
  ExisteGANADOR: Boolean;
  N: tNodoIndiceTri;
  cabeceraPila: integer;
  regColaPremio: lo_colasparciales.TipoDato;
  // claveBusqueda: string[100];
Begin

  // Busco si existe ya la clave idUsuario_idJuego a cargar...
  AltaGanador := False;

  ExisteGANADOR := BuscarNodo_Tri(meindiceganadores, claveBusqueda, PosTri);

  Reg.tipoPremio := tipoPremio; // id autogenerado.
  Reg.importe := importe;
  Reg.idCarton := idCarton;
  regColaPremio.tipoPremio := tipoPremio; // id autogenerado.
  regColaPremio.importe := importe;
  regColaPremio.idCarton := idCarton;

  // CASO 1: Ganador(combinacion jugador+juego) no existe
  If not ExisteGANADOR then
  Begin
    // En este caso, primero inserto el nodo del arbol

    // obtener cabeceraPila
    cabeceraPila := Obtener_UltimaCabeceraPila(meindiceganadores);
    Aumentar_UltimaCabeceraPila(meindiceganadores);

    // insertar control cabecera pila
    lo_pila.insertarCabeceraControl(MePilaGanadores, cabeceraPila);

    // inserto nodo
    N.hm := cabeceraPila;
    N.idGanador := claveBusqueda;
    InsertarNodo_Tri(meindiceganadores, N, PosTri);

     //para mensajes de premios
    regColaPremio.idJugador := getjugadorconganador(claveBusqueda);
    // insertar reg datos pila

    lo_pila.apilar(MePilaGanadores, Reg, cabeceraPila);
    encolar(MePremios,regColaPremio);

    result := True;
    ShowMessage('Indice Insertado' + '  -  cabeceraPila' +
      inttostr(cabeceraPila) + '  - clave' + N.idGanador);
  End
  else
  begin
    // CASO 2: ya existe el ganador, lo encuentro e inserto en la pila
    // o hacerlo en 2 metodos separados?
    ObtenerNodo(meindiceganadores, PosTri, N);
    apilar(MePilaGanadores, Reg, N.hm); // hm es la pos a la cabecera de la pila

    //para mensajes de premios
    regColaPremio.idJugador := getjugadorconganador(claveBusqueda);
    encolar(MePremios,regColaPremio);

    ShowMessage('pila Insertado' + '  -  cabeceraPila' + inttostr(N.hm) +
      '  - clave' + N.idGanador);

    result := True;
  end;

End;

function generarClaveGanador(idUsuario: tidusuario;
  nombreEvento: string): string;
begin
  result := idUsuario + '_' + nombreEvento;
end;

function importePorTipoPremio(juego: tRegDatosHash;
  tipoPremio: tTipoPremio): real;
// dado un juego y un tipo de premio, devuelve el importe del premio
// hay que restar al pozo acumulado la cantidad que estoy dando de premio
var
  valor: real;
begin
  Case tipoPremio of
    LineaHorizontal:
      valor := juego.PozoAcumulado * (juego.PorcentajePremioLinea / 100);
    LineaVertical:
      valor := juego.PozoAcumulado * (juego.PorcentajePremioLinea / 100);
    Diagonal1:
      valor := juego.PozoAcumulado * (juego.PorcentajePremioDiagonal / 100);
    Diagonal2:
      valor := juego.PozoAcumulado * (juego.PorcentajePremioDiagonal / 100);
    Cruz:
      valor := juego.PozoAcumulado * (juego.PorcentajePremioCruz / 100);
    CuadradoChico:
      valor := juego.PozoAcumulado *
        (juego.PorcentajePremioCuadradoChico / 100);
    CuadradoGrande:
      valor := juego.PozoAcumulado *
        (juego.PorcentajePremioCuadradoGrande / 100);
    Bingo:
      valor := juego.PozoAcumulado;
  else
    ShowMessage('unexpected ');
  end;
  result := valor;
end;

procedure restarPremioAPozoAcumulado(juego: tRegDatosHash; importePremio: real);
var
  pos: tPosHash;
  Reg: tRegDatosHash;
begin
  BuscarHash(MeJuego, juego.nombreEvento, pos);
  CapturarInfoHash(MeJuego, pos, Reg);
  Reg.PozoAcumulado := Reg.PozoAcumulado - importePremio;
  ModificarHash(MeJuego, pos, Reg);
end;

function espremioYaEntregadoAGanador(cabeceraPila: integer;
  tipoPremio: tTipoPremio): Boolean;
// Determina si ya se insert� el premio X en la pila de un ganador determinado
begin
  result := buscarPremio(MePilaGanadores, tipoPremio, cabeceraPila);
end;

function esJuegoBuscado(claveBusqueda: string; nombreEvento: string): Boolean;
// con una clave de ganador, y una clave de evento, devuelve si el ganador corresponde al evento
begin
  result := Copy(claveBusqueda, pos('_', claveBusqueda) + 1,
    Length(claveBusqueda)) = nombreEvento;
end;

function esJugadorBuscado(claveBusqueda: string; idJugador: string): Boolean;
// con una clave de ganador, y una clave de jugador, devuelve si el ganador corresponde al evento
begin
  result := Copy(claveBusqueda, 0, pos('_', claveBusqueda) - 1) = idJugador;
end;

function getJugadorConGanador(claveBusqueda: string): string;
// con una clave de ganador, y una clave de jugador, devuelve si el ganador corresponde al evento
begin
  result := Copy(claveBusqueda, 0, pos('_', claveBusqueda) - 1);
end;

function getNickJugadorConIdGanador(claveBusqueda: string): string;
var
  idJugador: string;
  posBi: tPosArbol;
    Rd: tRegDatos;
  N:tNodoIndice;
begin

  idJugador := Copy(claveBusqueda, 0, pos('_', claveBusqueda) - 1);
  BuscarNodo_Indice(MeID,idJugador, posBi);
      N:=ObtenerInfo_Indice (MeID,posBi);

    //De N utilizo la posicion en Clientes para leer el registro.
    ObtenerInfoMe_Archivos(MeJUGADORES,N.PosEnDatos,RD);
    result:= rd.nick;
end;

function sumarPremiosGanadorEnJuego(meGanadores: tMeIndiceTri;
  nombreEvento: string; idJugador: string): real;
var
  suma: real;
  claveGanador: string;
  PosTri: tPosTri;
  N: tNodoIndiceTri;
  Reg: tDatoPila;
  ExisteGANADOR: Boolean;
  /// INTERNO///
  Procedure sumarPremios(var suma: real; cabecera: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
    sumaAux: real;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);
      sumaAux := RD.importe;
      sumarPremios(suma, cabecera);

      { Hago lo que tenga que hacer }
      suma := suma + sumaAux;
      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

/// INTERNO///
begin
  suma := 0;
  claveGanador := generarClaveGanador(idJugador, nombreEvento);
  ExisteGANADOR := BuscarNodo_Tri(meindiceganadores, claveGanador, PosTri);

  if ExisteGANADOR then
  begin
    ObtenerNodo(meindiceganadores, PosTri, N);
    sumarPremios(suma, N.hm);
  end
  else
  begin
    suma := 0;
  end;

  result := suma;
end;

function contarPremiosGanadorEnJuego(meGanadores: tMeIndiceTri;
  nombreEvento: string; idJugador: string): integer;
var
  cuenta: integer;
  claveGanador: string;
  PosTri: tPosTri;
  N: tNodoIndiceTri;
  Reg: tDatoPila;
  ExisteGANADOR: Boolean;
  Procedure contarPremios(var cuenta: integer; cabecera: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
    cuentaAux: integer;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);
      contarPremios(cuenta, cabecera);

      { Hago lo que tenga que hacer }
      cuenta := cuenta + 1;
      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

begin
  cuenta := 0;
  claveGanador := generarClaveGanador(idJugador, nombreEvento);
  ExisteGANADOR := BuscarNodo_Tri(meindiceganadores, claveGanador, PosTri);

  if ExisteGANADOR then
  begin
    ObtenerNodo(meindiceganadores, PosTri, N);
    contarPremios(cuenta, N.hm);
  end
  else
  begin
    cuenta := 0;
  end;

  result := cuenta;
end;

function sumarPremiosCarton(meGanadores: tMeIndiceTri; nombreEvento: string;
  idJugador: string; idCarton: integer): real;
var
  suma: real;
  claveGanador: string;
  PosTri: tPosTri;
  N: tNodoIndiceTri;
  Reg: tDatoPila;
  ExisteGANADOR: Boolean;
  Procedure sumarPremios(var suma: real; cabecera: integer; idCarton: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
    sumaAux: real;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      sumaAux := RD.importe;
      sumarPremios(suma, cabecera, idCarton);

      { Hago lo que tenga que hacer }
      if RD.idCarton = idCarton then
        suma := suma + sumaAux;

      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

begin
  suma := 0;
  claveGanador := generarClaveGanador(idJugador, nombreEvento);
  ExisteGANADOR := BuscarNodo_Tri(meindiceganadores, claveGanador, PosTri);

  if ExisteGANADOR then
  begin
    ObtenerNodo(meindiceganadores, PosTri, N);
    sumarPremios(suma, N.hm, idCarton);
  end
  else
  begin
    suma := 0;
  end;

  result := suma;
end;

function contarPremiosCarton(meGanadores: tMeIndiceTri; nombreEvento: string;
  idJugador: string; idCarton: integer): integer;
var
  cuenta: integer;
  claveGanador: string;
  PosTri: tPosTri;
  N: tNodoIndiceTri;
  Reg: tDatoPila;
  ExisteGANADOR: Boolean;
  Procedure contarPremios(var cuenta: integer; cabecera: integer;
    idCarton: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
    cuentaAux: integer;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);
      contarPremios(cuenta, cabecera, idCarton);

      { Hago lo que tenga que hacer }
      if RD.idCarton = idCarton then
        cuenta := cuenta + 1;
      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

begin
  cuenta := 0;
  claveGanador := generarClaveGanador(idJugador, nombreEvento);
  ExisteGANADOR := BuscarNodo_Tri(meindiceganadores, claveGanador, PosTri);

  if ExisteGANADOR then
  begin
    ObtenerNodo(meindiceganadores, PosTri, N);
    contarPremios(cuenta, N.hm, idCarton);
  end
  else
  begin
    cuenta := 0;
  end;

  result := cuenta;
end;

procedure InOrderContarPremiosAcumuladosTotales(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador: string; var cuenta: integer);
var
  N: tNodoIndiceTri;
  /// ///////--INTERNO--//////////////////////////////////////////////
  Procedure contarPremios(var cuenta: integer; cabecera: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
    cuentaAux: integer;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      contarPremios(cuenta, cabecera);

      { Hago lo que tenga que hacer }

      cuenta := cuenta + 1;
      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

/// ///////--INTERNO--//////////////////////////////////////////////
begin
  If Raiz = PosNula_tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  InOrderContarPremiosAcumuladosTotales(Arbol, ProximoIzq_Tri(Arbol, Raiz),
    idJugador, cuenta);
  // Guardo en N el nodo indice.
  ObtenerNodo(Arbol, Raiz, N);

  if esJugadorBuscado(N.idGanador, idJugador) then
  begin
    // recorrer la pila y llamar a agregarRenglon por cada premio en pila
    contarPremios(cuenta, N.hm);
  end;

  // Recursividad tendiendo a la Derecha.

  InOrderContarPremiosAcumuladosTotales(Arbol, ProximoDer_Tri(Arbol, Raiz),
    idJugador, cuenta);

end;

procedure InOrderSumarPremiosAcumuladosTotales(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador: string; var suma: real);
var
  N: tNodoIndiceTri;
  /// ///////--INTERNO--//////////////////////////////////////////////
  Procedure sumarPremios(var suma: real; cabecera: integer);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      sumarPremios(suma, cabecera);

      { Hago lo que tenga que hacer }

      suma := suma + RD.importe;
      apilar(MePilaGanadores, RD, cabecera);
    end;
  end;

/// ///////--INTERNO--//////////////////////////////////////////////
begin
  If Raiz = PosNula_tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  InOrderSumarPremiosAcumuladosTotales(Arbol, ProximoIzq_Tri(Arbol, Raiz),
    idJugador, suma);
  // Guardo en N el nodo indice.
  ObtenerNodo(Arbol, Raiz, N);

  if esJugadorBuscado(N.idGanador, idJugador) then
  begin
    // recorrer la pila y llamar a agregarRenglon por cada premio en pila
    sumarPremios(suma, N.hm);
  end;

  // Recursividad tendiendo a la Derecha.

  InOrderSumarPremiosAcumuladosTotales(Arbol, ProximoDer_Tri(Arbol, Raiz),
    idJugador, suma);

end;

procedure InOrderIsGanadorObtuvoPremio(Arbol: tMeIndiceTri;
  Raiz: tPosTri; idJugador:string;premio:string; var premioGanado:boolean);
  var
  N: tNodoIndiceTri;

/// ///////--INTERNO--//////////////////////////////////////////////
Procedure isPremioGanado(var premioGanado: boolean; cabecera: integer; tipoPremio:string);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) and (not premioGanado) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      isPremioGanado(premioGanado, cabecera,tipoPremio);

       if TRttiEnumerationType.GetName(rd.tipoPremio) = tipoPremio then
        premioGanado := true;

      apilar(MePilaGanadores, RD, cabecera);
    end
     else If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      isPremioGanado(premioGanado, cabecera,tipoPremio);

      apilar(MePilaGanadores, RD, cabecera);
    end

  end;

/// ///////--INTERNO--//////////////////////////////////////////////
begin
//indica si el jugador gano un premio pasado como parametro
      If Raiz = PosNula_tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  InOrderIsGanadorObtuvoPremio(Arbol, ProximoIzq_Tri(Arbol, Raiz),
    idJugador, premio,premioGanado);
  // Guardo en N el nodo indice.
  ObtenerNodo(Arbol, Raiz, N);

  if esJugadorBuscado(N.idGanador, idJugador) then
  begin
    isPremioGanado(premioGanado, N.hm, premio);
  end;

  // Recursividad tendiendo a la Derecha.

  InOrderIsGanadorObtuvoPremio(Arbol, ProximoDer_Tri(Arbol, Raiz),
    idJugador, premio,premioGanado);
end;



Procedure isJugadorGanoBingo(var premioGanado: boolean; cabecera: integer;out idCarton: integer; out importe:real);
  { Metodo Recursivo }
  var
    RD: tDatoPila;
  begin
    If not PilaVacia(MePilaGanadores, cabecera) and (not premioGanado) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      isJugadorGanoBingo(premioGanado, cabecera,idcarton,importe);

       if TRttiEnumerationType.GetName(rd.tipoPremio) = 'Bingo' then
       begin
          premioGanado := true;
          idCarton:= rd.idCarton;
          importe:= rd.importe;
       end;


      apilar(MePilaGanadores, RD, cabecera);
    end
     else If not PilaVacia(MePilaGanadores, cabecera) then
    begin
      lo_pila.Tope(MePilaGanadores, RD, cabecera);
      Desapilar(MePilaGanadores, cabecera);

      isJugadorGanoBingo(premioGanado, cabecera,idcarton,importe);

      apilar(MePilaGanadores, RD, cabecera);
    end

  end;


end.
