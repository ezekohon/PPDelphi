unit la_dobleEnlace;

interface

uses
  Winapi.Windows, math, Classes, SysUtils, Graphics, LO_DobleEnlace, Dialogs,
  lo_hashabierto, LO_ArbolBinario, la_hashabierto,
  IniFiles, lo_pila, la_arboltrinario, lo_arboltrinario, Rtti, globals;

type
  TArrayMatriz = array [0 .. 4] of tRegCampoMatriz;

function generarGrilla(): tMatriz;
function IsNumberInArray(const ANumber: integer;
  const AArray: array of tRegCampoMatriz): boolean;
procedure altaCarton(idJugador: string; nombreEvento: string; grilla: tMatriz);
function isGrillasIguales(grilla1, grilla2: tMatriz): boolean;
function isGrillaEnMe(Var Me: MeDobleEnlace; grilla: tMatriz;
  nombreEvento: string): boolean;
Procedure OrdenarColumnaGrilla(var V: Array of tRegCampoMatriz);
function getColumnaArreglo(V: tMatriz; index: integer): TArrayMatriz;
procedure ordenarGrilla(var m: tMatriz);
function isTieneCartonesComprados(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): boolean;
function eliminarCartonesDeJugador(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
function cantidadCartonesComprados(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
function cantidadJugadoresEnJuego(nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
function cantidadCartonesCompradosTotales(idJugador: tidUsuario;
  var meCartones: MeDobleEnlace): integer;

function tacharNumeroSiEstaEnCarton(var carton: tRegDatos_DE; pos: tpos;
  numeroBolilla: integer): boolean;

function isTienePremioDiagonal1(grilla: tMatriz): boolean;
function isTienePremioDiagonal2(grilla: tMatriz): boolean;
function isTienePremioCruz(grilla: tMatriz): boolean;
function isTienePremioLineaV(grilla: tMatriz): boolean;
function isTienePremioLineaH(grilla: tMatriz): boolean;
function isTienePremioBingo(grilla: tMatriz): boolean;
function isTienePremioCuadradoChico(grilla: tMatriz): boolean;
function isTienePremioCuadradoGrande(grilla: tMatriz): boolean;
function isTienePremioGeneral(grilla: tMatriz; tipoPremio: tTipoPremio)
  : boolean;
function verificarYDevolverSiCartonTienePremio(var carton: tRegDatos_DE;
  out premio: tTipoPremio): boolean;

implementation

function generarGrilla(): tMatriz;
var
  res: tMatriz;
  col1, col2, col3, col4, col5: TArrayMatriz;
  campo: tRegCampoMatriz;
  i, num: integer;
  k, h: integer;
  V: TArrayMatriz;
begin
  // Index := RandomRange(1, 6);
  // It may seem a little counter-intuitive, but the lower limit is inclusive, and the upper limit is non-inclusive.
  campo.tachado := false;
  OutputDebugString(pchar('LENGHT ' + IntToStr(length(res[0]))));
  Randomize;
  for i := 0 to length(res[0]) - 1 do
  begin

    num := RandomRange(1, 16);
    while IsNumberInArray(num, getColumnaArreglo(res, 0)) do
      num := RandomRange(1, 16); // no esta comprobando
    campo.numero := num;
    res[i, 0] := campo;

  end;
  for i := 0 to length(res[1]) - 1 do
  begin
    //Randomize;
    num := RandomRange(16, 31);
    while IsNumberInArray(num, getColumnaArreglo(res, 1)) do
      num := RandomRange(16, 31);
    campo.numero := num;
    res[i, 1] := campo;
  end;
  for i := 0 to length(res[2]) - 1 do
  begin
    // if i<>2 then
    // begin
   // Randomize;
    num := RandomRange(31, 46);
    while IsNumberInArray(num, getColumnaArreglo(res, 2)) do
      num := RandomRange(31, 46);
    campo.numero := num;
    res[i, 2] := campo;
    // end
    // else
    // begin
    // begin
    // campo.numero := 0;
    // res[i,2]:= campo;
    // end;
    // end;
    // insertar 0 en el medio?
  end;
  for i := 0 to length(res[3]) - 1 do
  begin
   // Randomize;
    num := RandomRange(46, 61);
    while IsNumberInArray(num, getColumnaArreglo(res, 3)) do
      num := RandomRange(46, 61);
    campo.numero := num;
    res[i, 3] := campo;
  end;
  for i := 0 to length(res[4]) - 1 do
  begin
   // Randomize;
    num := RandomRange(61, 76);
    while IsNumberInArray(num, getColumnaArreglo(res, 4)) do
      num := RandomRange(61, 76);
    campo.numero := num;
    res[i, 4] := campo;
  end;

  // ordenar
  { for k := 0 to 4 do
    begin
    h:= k;
    v:= getColumnaArreglo(res,h);
    OrdenarColumnaGrilla(v);
    end;
    res[2,2].numero:= 0; }
  ordenarGrilla(res);

  result := res;
end;

function IsNumberInArray(const ANumber: integer;
  const AArray: array of tRegCampoMatriz): boolean;
var
  i: integer;
begin
  for i := Low(AArray) to High(AArray) do
    if ANumber = AArray[i].numero then
      Exit(true);
  result := false;
end;

procedure altaCarton(idJugador: string; nombreEvento: string; grilla: tMatriz);
var
  reg: tRegDatos_DE;
  posicion: tpos;
begin
  reg.idCarton := ObtenerProximoIDInterno(meCartones); // generarlo
  // reg.idJuego := idJuego;
  reg.nombreEvento := nombreEvento;
  reg.idJugador := idJugador;
  reg.grilla := grilla;
  BuscarInfo(meCartones, reg.idCarton, posicion);
  //el posicion no sirve, creo posNueva al insertar
  InsertarInfo(meCartones, reg, posicion);
end;

function isGrillaEnMe(Var Me: MeDobleEnlace; grilla: tMatriz;
  nombreEvento: string): boolean;
var
  existe: boolean;
  i: integer;
  reg: tRegDatos_DE;
  grillasIguales: boolean;
begin
  { Por cada grilla insertada en el ME del juego actual,
    se llama a la funci�n �isGrillasIguales�. Si se encuentra una igual,
    se deja de llamar y se retorna �true�. En caso de que se llegue al �ltimo registro del
    ME sin encontrar coincidencia, se retorna �false�.
  }
  grillasIguales := false;

  i := LO_DobleEnlace.Primero(meCartones);
  while ((i <> _posnula) and (not grillasIguales)) do
  begin
    reg := CapturarInfo(meCartones, i);
    if reg.nombreEvento = nombreEvento then
    begin
      if isGrillasIguales(grilla, reg.grilla) then
        grillasIguales := true;
    end;
    i := LO_DobleEnlace.Proximo(meCartones, i);
  end;
  result := grillasIguales;
end;

function isGrillasIguales(grilla1, grilla2: tMatriz): boolean;
var
  sonIguales: boolean;
  j, i: integer;
begin
  for i := 0 to length(grilla1) do
  begin
    for j := 0 to length(grilla1[0]) do
    begin
      if grilla1[i, j].numero <> grilla2[i, j].numero then
        Exit(false);
    end;
  end;
  result := true;
end;

Procedure OrdenarColumnaGrilla(var V: Array of tRegCampoMatriz);
var
  i: integer;
  temp: tRegCampoMatriz;
  changed: boolean;
begin
  changed := true;

  while changed do
  begin
    changed := false;
    for i := Low(V) to High(V) - 1 do
    begin
      if (V[i].numero > V[i + 1].numero) then
      begin
        temp := V[i + 1];
        V[i + 1] := V[i];
        V[i] := temp;
        changed := true;
      end;
    end;
  end;
end;

function getColumnaArreglo(V: tMatriz; index: integer): TArrayMatriz;
var
  arr: TArrayMatriz;
  i: integer;
begin
  for i := 0 to 4 do
  begin
    arr[i] := V[i, index];
  end;
  result := arr;
end;

procedure ordenarGrilla(var m: tMatriz);
var
  k, h: integer;
  V: TArrayMatriz;
  i: integer;
begin
  for k := low(m[0]) to high(m[0]) do
  begin
    h := k;
    V := getColumnaArreglo(m, h);
    OrdenarColumnaGrilla(V);
    for i := Low(V) to High(V) do
    begin
      m[i, k] := V[i];
    end;
  end;
  m[2, 2].numero := 0;
end;

function isTieneCartonesComprados(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): boolean;
// dado id de jugador e id de juego, devolver si el jugador tiene cartones comprados del juego
var
  tiene: boolean;
  j: integer;
  reg: tRegDatos_DE;
begin
  // detallar en la documentacion
  if not MeVacio(meCartones) then
  begin
    j := LO_DobleEnlace.Primero(meCartones);
    // while j <> _posnula do
    repeat

      reg := LO_DobleEnlace.CapturarInfo(meCartones, j);

      if ((reg.idJugador = idJugador) and (reg.nombreEvento = nombreEvento))
      then
        Exit(true);
      j := LO_DobleEnlace.Proximo(meCartones, j);

    until (j = _posnula);
  end;
  result := false;
end;

function cantidadCartonesComprados(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
// dado id de jugador e id de juego, devolver cantidad cartones comprados por el jugador
var
  tiene: boolean;
  j, count: integer;
  reg: tRegDatos_DE;
begin
  count := 0;
  if not MeVacio(meCartones) then
  begin
    j := LO_DobleEnlace.Primero(meCartones);
    // while j <> _posnula do
    repeat
      reg := LO_DobleEnlace.CapturarInfo(meCartones, j);
      if ((reg.idJugador = idJugador) and (reg.nombreEvento = nombreEvento))
      then
        count := count + 1;
      j := LO_DobleEnlace.Proximo(meCartones, j);
    until (j = _posnula);
  end;
  result := count;
end;

function cantidadCartonesCompradosTotales(idJugador: tidUsuario;
  var meCartones: MeDobleEnlace): integer;
// dado id de jugador devolver cantidad cartones comprados por el jugador
var
  tiene: boolean;
  j, count: integer;
  reg: tRegDatos_DE;
begin
  count := 0;
  if not MeVacio(meCartones) then
  begin
    j := LO_DobleEnlace.Primero(meCartones);
    // while j <> _posnula do
    repeat
      reg := LO_DobleEnlace.CapturarInfo(meCartones, j);
      if (reg.idJugador = idJugador)
      then
        count := count + 1;
      j := LO_DobleEnlace.Proximo(meCartones, j);
    until (j = _posnula);
  end;
  result := count;
end;

function cantidadJugadoresEnJuego(nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
var
  tiene: boolean;
  j, i, count, uniqueCount: integer;
  reg: tRegDatos_DE;
  arr: array of tidUsuario;
  arrDistinct: THashedStringList;
begin
  count := 0;
  if not MeVacio(meCartones) then
  begin
    j := LO_DobleEnlace.Primero(meCartones);
    // while j <> _posnula do
    repeat
      reg := LO_DobleEnlace.CapturarInfo(meCartones, j);
      if (reg.nombreEvento = nombreEvento) then
      begin
        SetLength(arr, length(arr) + 1);
        arr[count] := reg.idJugador;
        count := count + 1;
      end;

      j := LO_DobleEnlace.Proximo(meCartones, j);
    until (j = _posnula);
  end;

  // VALORES UNICOS
  arrDistinct := THashedStringList.Create;
  try
    arrDistinct.Sorted := true;
    arrDistinct.Duplicates := dupIgnore; // ignores attempts to add duplicates
    for i := 0 to High(arr) do
      arrDistinct.Add(arr[i]);
    uniqueCount := arrDistinct.count;
  finally
    arrDistinct.Free;
  end;
  result := uniqueCount;
end;

function eliminarCartonesDeJugador(idJugador: tidUsuario; nombreEvento: string;
  var meCartones: MeDobleEnlace): integer;
// elimina y devuelve la cantidad que elimino
var
  j, cant: integer;
  reg: tRegDatos_DE;
  borro: boolean;
begin
  j := LO_DobleEnlace.Primero(meCartones);
  cant := 0;
  repeat
    borro := false;
    reg := CapturarInfo(meCartones, j);
    if ((reg.idJugador = idJugador) and (reg.nombreEvento = nombreEvento)) then
    begin
      Eliminar(meCartones, j);
      cant := cant + 1;
      borro := true;
    end;
    if borro then
      j := LO_DobleEnlace.Primero(meCartones)
      // si borro, arranco desde el principio del archivo
    else
      j := LO_DobleEnlace.Proximo(meCartones, j);

  until (j = _posnula);

  result := cant;
end;

function tacharNumeroSiEstaEnCarton(var carton: tRegDatos_DE; pos: tpos;
  numeroBolilla: integer): boolean;
var
  i, j: integer;
  tache: boolean;
begin
  tache := false;
  for i := low(carton.grilla) to high(carton.grilla) do
  begin
    for j := low(carton.grilla[0]) to high(carton.grilla[0]) do
    begin
        if ( not((i = 2) and (j = 2)) and not (tache)) then
        if (carton.grilla[i, j].numero = numeroBolilla) then
        begin
          carton.grilla[i, j].tachado := true;
          Modificar(meCartones, pos, carton);
          tache := true;
        end;
    end;
  end;
  result := tache;
end;

// PREMIOS
// tengo q chequear antes de calcularlo, que no se lo di ya en la bolilla anterior
function isTienePremioDiagonal1(grilla: tMatriz): boolean;
begin
  if (grilla[0, 0].tachado) and (grilla[1, 1].tachado) and
    (grilla[3, 3].tachado) and (grilla[4, 4].tachado) then
    result := true
  else
    result := false;
end;

function isTienePremioDiagonal2(grilla: tMatriz): boolean;
begin
  if (grilla[0, 4].tachado) and (grilla[1, 3].tachado) and
    (grilla[3, 1].tachado) and (grilla[4, 0].tachado) then
    result := true
  else
    result := false;
end;

function isTienePremioCruz(grilla: tMatriz): boolean;
begin
  if isTienePremioDiagonal1(grilla) and isTienePremioDiagonal2(grilla) then
    result := true
  else
  begin
    result := false;
  end;
end;

function isTienePremioLineaH(grilla: tMatriz): boolean;
var
  tieneLinea: boolean;
  i, j: integer;
begin
  tieneLinea := false;
  for i := low(grilla) to high(grilla) do
  begin
    for j := low(grilla[0]) to high(grilla[0]) do
    begin
      if (not((i = 2) and (j = 2))) then
        if (grilla[i, j].tachado = true) then
          tieneLinea := true
        else
        begin
           tieneLinea := false;
           break;
        end;

    end;
    if tieneLinea then
      Exit(true);
    tieneLinea := false;
  end;
  result := false;
end;

function isTienePremioLineaV(grilla: tMatriz): boolean;
var
  tieneLinea: boolean;
  i, j: integer;
begin
  tieneLinea := false;
  for i := low(grilla) to high(grilla) do
  begin
    for j := low(grilla[0]) to high(grilla[0]) do
    begin
      if (not((i = 2) and (j = 2))) then
        if (grilla[j, i].tachado = true) then
          tieneLinea := true
        else
        begin
           tieneLinea := false;
           break;
        end;
    end;
    if tieneLinea then
      Exit(true);
    tieneLinea := false;
  end;
  result := false;
end;

function isTienePremioBingo(grilla: tMatriz): boolean;
var
  tieneLinea: boolean;
  i, j: integer;
begin
  tieneLinea := false;
  for i := low(grilla) to high(grilla) do
  begin
    for j := low(grilla[0]) to high(grilla[0]) do
    begin
      if (not((i = 2) and (j = 2))) then
        if (not grilla[i, j].tachado) then
          Exit(false);
    end;
  end;

  result := true;
end;

function isTienePremioCuadradoChico(grilla: tMatriz): boolean;
begin
  if grilla[1, 1].tachado and grilla[1, 2].tachado and grilla[1, 3].tachado and
    grilla[2, 3].tachado and grilla[3, 3].tachado and grilla[3, 2].tachado and
    grilla[3, 1].tachado and grilla[2, 1].tachado then
    result := true
  else
    result := false
end;

function isTienePremioCuadradoGrande(grilla: tMatriz): boolean;
begin
  if grilla[0, 0].tachado and grilla[0, 1].tachado and grilla[0, 2].tachado and
    grilla[0, 3].tachado and grilla[0, 4].tachado and grilla[1, 4].tachado and
    grilla[2, 4].tachado and grilla[3, 4].tachado and grilla[4, 4].tachado and
    grilla[4, 3].tachado and grilla[4, 2].tachado and grilla[4, 1].tachado and
    grilla[4, 0].tachado and grilla[3, 0].tachado and grilla[2, 0].tachado and
    grilla[1, 0].tachado then
    result := true
  else
    result := false
end;

function isTienePremioGeneral(grilla: tMatriz; tipoPremio: tTipoPremio)
  : boolean;
begin
  case tipoPremio of

    LineaHorizontal:
      result := isTienePremioLineaH(grilla);
    LineaVertical:
      result := isTienePremioLineaV(grilla);
    Diagonal1:
      result := isTienePremioDiagonal1(grilla);
    Diagonal2:
      result := isTienePremioDiagonal2(grilla);
    Cruz:
      result := isTienePremioCruz(grilla);
    CuadradoChico:
      result := isTienePremioCuadradoChico(grilla);
    CuadradoGrande:
      result := isTienePremioCuadradoGrande(grilla);
    Bingo:
      result := isTienePremioBingo(grilla);
  end;
end;

function verificarYDevolverSiCartonTienePremio(var carton: tRegDatos_DE;
  out premio: tTipoPremio): boolean;
var
  juego: tRegDatosHash;
  tipoPremio: tTipoPremio;
  posHash: tPosHash;
  tienePremio: boolean;
begin
    tienePremio := false;
    BuscarHash(MeJuego, carton.nombreEvento, posHash);
    CapturarInfoHash(MeJuego, posHash, juego);
    for tipoPremio := Low(tTipoPremio) to High(tTipoPremio) do
    begin
      //Consulta si en el juego, ya se entreg� el premio en cuestion
      if not isPremioEntregado(juego, tipoPremio) and not tienePremio then
      begin
        //Consulta si la grilla tiene algun premio
        if isTienePremioGeneral(carton.grilla, tipoPremio) then
        begin
            tienePremio := true;
            premio := tipoPremio;
        end;
      end;
    end;
  result := tienePremio;
end;

function mensajeGanadorPremio(premio: tTipoPremio): string;
begin
  result := 'Useted ha ganado el premio: ' + TRttiEnumerationType.GetName
    (premio) + '!';
end;

end.
