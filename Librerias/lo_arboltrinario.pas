unit lo_arboltrinario;

interface

//uses
 // lo_pila;

const
  _posnula_tri = -1;
  _max_tri = maxint;
  _ARCHIVO_INDICE_NIVEL = 'INDICEGANADORES.NIV';
  _ARCHIVO_INDICE_DATOS = 'INDICEGANADORES.NTX';
  _ARCHIVO_INDICE_CONTROL = 'INDICEGANADORES.CON';

  _ARCHIVO_GANADORES_DATOS = 'DATOSGANADORES.DAT';
  _RUTA_ARCHIVO_PILA_DATOS = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\DATOSGANADORES.DAT';
  _ARCHIVO_GANADORES_CONTROL = 'DATOSGANADORES.CON';
  _RUTA_ARCHIVO_PILA_CONTROL = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\DATOSGANADORES.CON';
  _RUTA = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\';

type
  tPosTri = integer; // _posnula_tri.._max_tri;
  tClaveTri = string[100];
  tCadenatri = string[100];

  // NODO
  tNodoIndiceTri = record // ESTO es el nodo del arbol
    idGanador: string[100]; // clave de busqueda. idUsuario_idJuego
    Padre: tPosTri;
    hi: tPosTri;
    hd: tPosTri;
    hm: tPosTri; // (seria como la posendatos(?)) hm es cabecera de la pila
    nivel: integer;
  end;

  tNivelesTri = record
    nivel:integer;
    cantNodos: integer;
    // cant nodos en ese nivel del arbol. en c/ insercion y eliminacion se actualzia
  end;

  tControlTri = record
    raiz: tPosTri; // al arbol ntx
    cantidad: integer;
    cant_niveles: integer;
    borrados: tPosTri; // a pila borrados
    ultimaCabeceraPila: integer;
  end;
  tArchivoControlTri = file of tControlTri;
  tArchivoIndiceTri = file of tNodoIndiceTri;
  tArchivoNivelesTri = file of tNivelesTri;

  // ME de indice arboreo (el arbol en si)
  tMeIndiceTri = record
    I: tArchivoIndiceTri;
    N: tArchivoNivelesTri;
    // D:tArchivoDatosTri;
    C: tArchivoControlTri;
  end;
  // El me de pila es de lo_pila

  /// ////////ARBOL TRINARIO
Procedure CrearMe_ArbolTri(var Arbol: tMeIndiceTri);
Procedure Cerrar_ArbolTri(var me: tMeIndiceTri);
Procedure Abrir_ArbolTri(var me: tMeIndiceTri);
Function BuscarNodo_Tri(var Arbol: tMeIndiceTri; clave: tClaveTri;
  var pos: tPosTri): boolean;
Procedure InsertarNodo_Tri(var Arbol: tMeIndiceTri; var nodo: tNodoIndiceTri;
  pos: tPosTri);
Function CantidadNodos(Arbol: tMeIndiceTri): integer;
Procedure ObtenerNodo(Arbol: tMeIndiceTri; pos: tPosTri; out nodo: tNodoIndiceTri);
Function ProximoDer_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
Function ProximoIzq_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
Procedure Aumentar_UltimaCabeceraPila(var Arbol: tMeIndiceTri);
Function Obtener_UltimaCabeceraPila(Arbol: tMeIndiceTri): integer;
Function  Raiz_Tri(var Arbol:tMeIndiceTri):tPosTri;
Function  PosNula_Tri(arbol:tMeIndiceTri):tPosTri;
procedure AumentarNodosEnNivel(var Arbol:tMeIndiceTri;nivel:integer);

///////////////BALANCEO/////////
  Procedure AVL_Indice(Arbol: tMeIndiceTri; raiz: tpostri; var PosNodo: tpostri;
  Var Balance: boolean);
  Function ProfundidadNodo(Arbol: tMeIndiceTri; raiz: tpostri): integer;
Procedure RightRight(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Procedure LeftLeft(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Procedure LeftRight(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Procedure RightLeft(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Procedure DisminuirNiveles(var Arbol: tMeIndiceTri; raiz: tpostri);
Function CantidadNiveles(Arbol: tMeIndiceTri): integer;
Function FactorEquilibrio(Arbol: tMeIndiceTri; PosNodo: tpostri): integer;
Procedure CasoDeDesequilibrio(Arbol: tMeIndiceTri; PosNodo: tpostri);
procedure BalancearArbol_Tri(var me: tMeIndiceTri);
Procedure AumentarNiveles(var Arbol: tMeIndiceTri; raiz: tpostri);


Var
  MeIndiceGanadores: tMeIndiceTri;


implementation

Procedure CrearMe_ArbolTri(var Arbol: tMeIndiceTri);
var
  RC: tControlTri;
  RN: tNivelesTri;
  ioD, ioC, ioN: integer;
begin
  assign(Arbol.I, _RUTA + _ARCHIVO_INDICE_DATOS);
  assign(Arbol.N, _RUTA + _ARCHIVO_INDICE_NIVEL);
  assign(Arbol.C, _RUTA + _ARCHIVO_INDICE_CONTROL);
{$I-}
  reset(Arbol.I);
  ioD := IoResult;
  reset(Arbol.C);
  ioC := IoResult;
  reset(Arbol.N);
  ioN := IoResult;
  if (ioD <> 0) or (ioC <> 0) or (ioN <> 0) then
  begin
    Rewrite(Arbol.I);
    Rewrite(Arbol.C);
    Rewrite(Arbol.N);
    RC.raiz := _posnula_tri;
    RC.cantidad := 0;
    RC.cant_niveles := 0;
    rc.ultimaCabeceraPila:= 0;
    RC.borrados := _posnula_tri;
    Write(Arbol.C, RC);


    rn.nivel:=1;
    rn.cantNodos:=0;
    seek(Arbol.N,rn.nivel);
    Write(Arbol.N, rn);
  end;
  Close(Arbol.I);
  Close(Arbol.C);
  Close(Arbol.N);
{$I+}
end;

{ ****************************************************************************** }
Procedure Abrir_ArbolTri(var me: tMeIndiceTri);
Begin
  reset(me.I);
  reset(me.C);
  reset(me.N);
end;

{ ****************************************************************************** }
Procedure Cerrar_ArbolTri(var me: tMeIndiceTri);
Begin
  Close(me.I);
  Close(me.C);
  Close(me.N);
end;

{ ****************************************************************************** }
Function BuscarNodo_Tri(var Arbol: tMeIndiceTri; clave: tClaveTri;
  var pos: tPosTri): boolean;
{ Busca por clave primaria: Si existe devuelve la posicion real, sino la pos de
  su padre, y si es el primer elemento devuelve pos_nula }
var
  Reg: tNodoIndiceTri;
  RC: tControlTri;
  encont: boolean;
  posPadre: tPosTri;
begin
  seek(Arbol.C, 0);
  read(Arbol.C, RC);
  pos := RC.raiz;
  encont := false;
  posPadre := _posnula_tri;
  while (not encont) and (pos <> _posnula_tri) do
  begin
    seek(Arbol.I, pos);
    read(Arbol.I, Reg);
    if (clave = Reg.idGanador) then
      encont := true
    else
    begin
      if (Reg.idGanador > clave) then
      begin
        posPadre := pos;
        pos := Reg.hi;
      end
      else
      begin
        posPadre := pos;
        pos := Reg.hd;
      end;
    end;
  end;
  if (not encont) then
    pos := posPadre;
  BuscarNodo_Tri := encont;
end;
/// /////////////////////////////////////////////////////////////////////////////
Procedure InsertarNodo_Tri(var Arbol: tMeIndiceTri; var nodo: tNodoIndiceTri;
  pos: tPosTri);
var // El pos que entra es la posicion fisica de su padre...
  posnueva: tPosTri;
  Reg, rd: tNodoIndiceTri;
  RC: tControlTri;
  rn: tNivelesTri;
begin
  //nodo.hm := _posnula_tri;
  seek(Arbol.C, 0);
  read(Arbol.C, RC);
  if RC.borrados = _posnula_tri then
    posnueva := filesize(Arbol.I)
  else
  begin
    posnueva := RC.borrados;
    seek(Arbol.I, posnueva);
    read(Arbol.I, rd);
    RC.borrados := rd.hi;
  end;

  if (RC.raiz = _posnula_tri) then // Arbol vacio
  begin
    nodo.Padre := _posnula_tri;
    nodo.hi := _posnula_tri;
    nodo.hd := _posnula_tri;
    nodo.nivel := 1;
    seek(arbol.n,nodo.nivel);
    read(arbol.n,rn);
    rn.cantNodos:= rn.cantNodos+1;
    Write(arbol.n,rn);
    RC.raiz := posnueva;
  end
  else // Hoja
  begin
    { Leo a su padre }
    seek(Arbol.I, pos);
    read(Arbol.I, Reg);
    { Cambio enlaces del nodo a insertar }
    nodo.Padre := pos;
    nodo.hd := _posnula_tri;
    nodo.hi := _posnula_tri;
    {agrego nivel}
    nodo.nivel := reg.nivel + 1;

    { Cambio enlaces del padre }
    if (nodo.idGanador < Reg.idGanador) then
      Reg.hi := posnueva
    else
      Reg.hd := posnueva;
    { Grabo a su padre }
    seek(Arbol.I, pos);
    write(Arbol.I, Reg);
  end;

   If nodo.nivel > RC.cant_niveles then
   begin
       RC.cant_niveles := nodo.nivel;
       seek(arbol.N, nodo.nivel);
       rn.nivel:= nodo.nivel;
       rn.cantNodos:=1;
       Write(arbol.n,rn);
   end
   else
   begin
       seek(arbol.N, nodo.nivel);
       read(arbol.N, rn);
       rn.cantNodos:=rn.cantNodos+1;
       seek(arbol.N, nodo.nivel);
       Write(arbol.n,rn);
   end;

  RC.cantidad := RC.cantidad + 1;
  seek(Arbol.I, posnueva);
  write(Arbol.I, nodo); // se escribe el elemento en el archivo
  seek(Arbol.C, 0);
  write(Arbol.C, RC); // se actualiza el registro control

end;
{ ****************************************************************************** }
Function CantidadNodos(Arbol: tMeIndiceTri): integer;
Var
  RC: tControlTri;
begin
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);
  CantidadNodos := RC.cantidad;
end;

{ ****************************************************************************** }
Procedure ObtenerNodo(Arbol: tMeIndiceTri; pos: tPosTri; out nodo: tNodoIndiceTri);
begin
  seek(Arbol.I, pos);
  Read(Arbol.I, nodo);
end;

{ ****************************************************************************** }
Function ProximoIzq_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
var
  rd: tNodoIndiceTri;
begin
  seek(Arbol.I, pos);
  read(Arbol.I, rd);
  ProximoIzq_Tri := rd.hi;
end;

{ ****************************************************************************** }
Function ProximoDer_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
var
  rd: tNodoIndiceTri;
begin
  seek(Arbol.I, pos);
  read(Arbol.I, rd);
  ProximoDer_Tri := rd.hd;
end;

{ ****************************************************************************** }
Function Obtener_UltimaCabeceraPila(Arbol: tMeIndiceTri): integer;
Var
  RC: tControlTri;
Begin
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);
  result := RC.UltimaCabeceraPila;
end;

{ ****************************************************************************** }
Procedure Aumentar_UltimaCabeceraPila(var Arbol: tMeIndiceTri);
Var
  RC: tControlTri;
Begin
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);
  RC.UltimaCabeceraPila := RC.UltimaCabeceraPila + 1;
  seek(Arbol.C, 0);
  Write(Arbol.C, RC);
end;

{ ****************************************************************************** }
Function  Raiz_Tri(var Arbol:tMeIndiceTri):tPosTri;
var
   RC:tControlTri;
begin
   seek(Arbol.C,0);
   read(Arbol.C,RC);
   Raiz_Tri:=RC.Raiz;
end;

{ ****************************************************************************** }
Function  PosNula_Tri(arbol:tMeIndiceTri):tPosTri;
begin
  PosNula_Tri:=_posnula_tri;
end;

procedure AumentarNodosEnNivel(var Arbol:tMeIndiceTri; nivel:integer);
var
  RN: tNivelesTri;
begin
   seek(Arbol.n,nivel);
   read(Arbol.n,rn);
   rn.cantNodos := rn.cantNodos +1;
   seek(Arbol.n,nivel);
   write(Arbol.n,rn);
end;


////////BALANCEO///////////////////
Procedure AVL_Indice(Arbol: tMeIndiceTri; raiz: tpostri; var PosNodo: tpostri;
  Var Balance: boolean);
{ Indica si el Arbol esta balanceado. Si no lo esta me envia la pos del nodo
  que esta causando el desequilibrio. Este siempre es el nodo de mas ALTO nivel.
  La idea es ir balanceandolo de los nodos mas pesados hasta llegar a la raiz. }
var
  Result: integer;
begin
  // Si lo que entra es posNula sale.
  If (raiz = PosNula_Tri(Arbol)) then
    exit;
  // Recursivo tendiendo a la Izquierda
  AVL_Indice(Arbol, ProximoIzq_Tri(Arbol, raiz), PosNodo, Balance);
  // Recursivo tendiendo a la derecha
  AVL_Indice(Arbol, ProximoDer_Tri(Arbol, raiz), PosNodo, Balance);

  Result := FactorEquilibrio(Arbol, raiz);

  If Result < 0 then
    Result := Result * (-1);

  { Cuando conoce la posicion del nodo en desequilibrio no lo cambia }
  If (Result > 1) then
    Balance := false;

  If (PosNodo = PosNula_Tri(Arbol)) and (not Balance) then
    PosNodo := raiz;
end;

Function FactorEquilibrio(Arbol: tMeIndiceTri; PosNodo: tpostri): integer;
var
  N: tNodoIndiceTri;
  Ti, Td: integer;
begin
  If PosNodo = -1 then
    FactorEquilibrio := 0
  Else
  begin
    // Guardo en N el nodo indice.
    ObtenerNodo(Arbol, PosNodo, n);

    // Calculo la profundidad de ambos hijos.
    If N.hi <> PosNula_Tri(Arbol) then
      Ti := ProfundidadNodo(Arbol, N.hi)
    Else
      Ti := 0;
    If N.hd <> PosNula_Tri(Arbol) then
      Td := ProfundidadNodo(Arbol, N.hd)
    Else
      Td := 0;

    { -->AVL es cuando de todo nodo |Altura(Ti)-Altura(Td)|<=1.
      --->Ti y Td son los subarboles de un nodo.
      --> Aca Ti y Td contienen la Altura de dicho subarbol. }
    FactorEquilibrio := Ti - Td;
  end;
end;

{ ****************************************************************************** }
Procedure CasoDeDesequilibrio(Arbol: tMeIndiceTri; PosNodo: tpostri);
var
  N: tNodoIndiceTri;
begin

  ObtenerNodo(Arbol, PosNodo, N);
  { Si el factor de desequilibrio es Positivo
    significa que hay que revisar el lado izquierdo }
  If FactorEquilibrio(Arbol, PosNodo) >= 0 then
  begin
    If FactorEquilibrio(Arbol, N.hi) >= 0 then
      LeftLeft(Arbol, PosNodo)
    Else
      LeftRight(Arbol, PosNodo);
  end
  Else
  begin
    If FactorEquilibrio(Arbol, N.hd) >= 0 then
      RightLeft(Arbol, PosNodo)
    Else
      RightRight(Arbol, PosNodo);
  end;

end;

{ ****************************************************************************** }
Function ProfundidadNodo(Arbol: tMeIndiceTri; raiz: tpostri): integer;
var
  nodo: tNodoIndiceTri;
  Profundidad: integer;
  { Procedimiento interno......................................................... }
  Procedure ProfundidadArbol(Arbol: tMeIndiceTri; raiz: tpostri;
    var Prof: integer);
  var
    N: tNodoIndiceTri;
  begin
    If raiz = PosNula_Tri(Arbol) then
      exit;
    // Primero recursivo tendiendo a la Izquierda
    ProfundidadArbol(Arbol, ProximoIzq_Tri(Arbol, raiz), Prof);
    // Recursividad tendiendo a la Derecha.
    ProfundidadArbol(Arbol, ProximoDer_Tri(Arbol, raiz), Prof);

    // Guardo en N el nodo indice.
    ObtenerNodo(Arbol, raiz, N);

    If N.nivel > Prof then
      Prof := N.nivel;
  end;

{ ............................................................................ }
Begin
  Profundidad := 0;
  ObtenerNodo(Arbol, raiz, Nodo);
  ProfundidadArbol(Arbol, raiz, Profundidad);
  ProfundidadNodo := (Profundidad - nodo.nivel) + 1;
End;

{ ****************************************************************************** }
Function CantidadNiveles(Arbol: tMeIndiceTri): integer;
var
  RC: tControlTri;
begin
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);
  CantidadNiveles := RC.cant_niveles;
end;

Procedure RightRight(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Var
  NodoArriba, NodoAbajo, NodoAnterior: tNodoIndiceTri;
  RC: tControlTri;
  posAux: tpostri;
begin

  seek(Arbol.I, PosNodo);
  Read(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.hd);
  Read(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);

  { Cambio enlaces }
  posAux := NodoAbajo.hi;
  NodoAbajo.padre := NodoArriba.padre;
  NodoAbajo.hi := PosNodo;
  NodoArriba.padre := NodoArriba.hd;
  NodoArriba.hd := posAux;;

  { Es necesario cambiar al nodo anterior? }
  { ******************************** }
  If NodoAbajo.padre <> _posnula_tri then
  begin
    seek(Arbol.I, NodoAbajo.padre);
    Read(Arbol.I, NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd := NodoArriba.padre
    Else
      NodoAnterior.hi := NodoArriba.padre;
    seek(Arbol.I, NodoAbajo.padre);
    Write(Arbol.I, NodoAnterior);
  end;
  { ******************************** }

  { Cambio el campo nivel }
  NodoAbajo.nivel := NodoAbajo.nivel - 1;
  NodoArriba.nivel := NodoArriba.nivel + 1;

  { Verifico que el del drama no haya sido la raiz }
  If PosNodo = RC.raiz then
    RC.raiz := NodoArriba.padre;

  seek(Arbol.I, PosNodo);
  Write(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.padre);
  Write(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Write(Arbol.C, RC);

  DisminuirNiveles(Arbol, NodoAbajo.hd);
  AumentarNiveles(Arbol, NodoArriba.hi);
end;

Procedure DisminuirNiveles(var Arbol: tMeIndiceTri; raiz: tpostri);
var
  N: tNodoIndiceTri;
begin
  If raiz = PosNula_Tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  DisminuirNiveles(Arbol, ProximoIzq_tri(Arbol, raiz));
  ObtenerNodo(Arbol, raiz, N);
  N.nivel := N.nivel - 1;
  seek(Arbol.I, raiz);
  Write(Arbol.I, N);
  // Recursividad tendiendo a la Derecha.
  DisminuirNiveles(Arbol, ProximoDer_tri(Arbol, raiz));
end;

{ ****************************************************************************** }
Procedure LeftLeft(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Var
  NodoArriba, NodoAbajo, NodoAnterior: tNodoIndiceTri;
  RC: tControlTri;
  posAux: tpostri;
begin

  seek(Arbol.I, PosNodo);
  Read(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.hi);
  Read(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);

  { Cambio enlaces }
  posAux := NodoAbajo.hd;
  NodoAbajo.padre := NodoArriba.padre;
  NodoAbajo.hd := PosNodo;
  NodoArriba.padre := NodoArriba.hi;
  NodoArriba.hi := posAux;;

  { Es necesario cambiar al nodo anterior? }
  { ******************************** }
  If NodoAbajo.padre <> _posnula_tri then
  begin
    seek(Arbol.I, NodoAbajo.padre);
    Read(Arbol.I, NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd := NodoArriba.padre
    Else
      NodoAnterior.hi := NodoArriba.padre;
    seek(Arbol.I, NodoAbajo.padre);
    Write(Arbol.I, NodoAnterior);
  end;
  { ******************************** }

  { Cambio el campo nivel }
  NodoAbajo.nivel := NodoAbajo.nivel - 1;
  NodoArriba.nivel := NodoArriba.nivel + 1;

  { Verifico que el del drama no haya sido la raiz }
  If PosNodo = RC.raiz then
    RC.raiz := NodoArriba.padre;

  seek(Arbol.I, PosNodo);
  Write(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.padre);
  Write(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Write(Arbol.C, RC);

  DisminuirNiveles(Arbol, NodoAbajo.hi);
  AumentarNiveles(Arbol, NodoArriba.hd);
end;

{ ****************************************************************************** }
Procedure LeftRight(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Var
  NodoArriba, NodoMedio, NodoAbajo, NodoAnterior: tNodoIndiceTri;
  RC: tControlTri;
  posAux, PosMedio, PosAbajo: tpostri;
begin

  seek(Arbol.I, PosNodo);
  Read(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.hi);
  Read(Arbol.I, NodoMedio);
  seek(Arbol.I, NodoMedio.hd);
  Read(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);

  PosMedio := NodoArriba.hi;
  PosAbajo := NodoMedio.hd;
  posAux := NodoArriba.padre;

  NodoArriba.padre := NodoMedio.hd;
  NodoArriba.hi := NodoAbajo.hd;

  NodoMedio.padre := NodoMedio.hd;
  NodoMedio.hd := NodoAbajo.hi;

  NodoAbajo.padre := posAux;
  NodoAbajo.hd := PosNodo;
  NodoAbajo.hi := PosMedio;

  If NodoAbajo.padre <> _posnula_tri then
  begin
    seek(Arbol.I, NodoAbajo.padre);
    Read(Arbol.I, NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd := PosAbajo
    Else
      NodoAnterior.hi := PosAbajo;
    seek(Arbol.I, NodoAbajo.padre);
    Write(Arbol.I, NodoAnterior);
  end;
  { Cambio el campo nivel }
  NodoAbajo.nivel := NodoAbajo.nivel - 2;
  NodoArriba.nivel := NodoArriba.nivel + 1;

  { Verifico que el del drama no haya sido la raiz }
  If PosNodo = RC.raiz then
    RC.raiz := NodoArriba.padre;

  seek(Arbol.I, PosNodo);
  write(Arbol.I, NodoArriba);
  seek(Arbol.I, PosMedio);
  write(Arbol.I, NodoMedio);
  seek(Arbol.I, PosAbajo);
  write(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Write(Arbol.C, RC);

  DisminuirNiveles(Arbol, NodoArriba.hi);
  AumentarNiveles(Arbol, NodoArriba.hd);
  DisminuirNiveles(Arbol, NodoMedio.hd);

end;

{ ****************************************************************************** }
Procedure RightLeft(var Arbol: tMeIndiceTri; PosNodo: tpostri);
Var
  NodoArriba, NodoMedio, NodoAbajo, NodoAnterior: tNodoIndiceTri;
  RC: tControlTri;
  posAux, PosMedio, PosAbajo: tpostri;
begin

  seek(Arbol.I, PosNodo);
  Read(Arbol.I, NodoArriba);
  seek(Arbol.I, NodoArriba.hd);
  Read(Arbol.I, NodoMedio);
  seek(Arbol.I, NodoMedio.hi);
  Read(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Read(Arbol.C, RC);

  PosMedio := NodoArriba.hd;
  PosAbajo := NodoMedio.hi;
  posAux := NodoArriba.padre;

  NodoArriba.padre := NodoMedio.hi;
  NodoArriba.hd := NodoAbajo.hi;

  NodoMedio.padre := NodoMedio.hi;
  NodoMedio.hi := NodoAbajo.hd;

  NodoAbajo.padre := posAux;
  NodoAbajo.hi := PosNodo;
  NodoAbajo.hd := PosMedio;

  If NodoAbajo.padre <> _posnula_tri then
  begin
    seek(Arbol.I, NodoAbajo.padre);
    Read(Arbol.I, NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd := PosAbajo
    Else
      NodoAnterior.hi := PosAbajo;
    seek(Arbol.I, NodoAbajo.padre);
    Write(Arbol.I, NodoAnterior);
  end;
  { Cambio el campo nivel }
  NodoAbajo.nivel := NodoAbajo.nivel - 2;
  NodoArriba.nivel := NodoArriba.nivel + 1;

  { Verifico que el del drama no haya sido la raiz }
  If PosNodo = RC.raiz then
    RC.raiz := NodoArriba.padre;

  seek(Arbol.I, PosNodo);
  write(Arbol.I, NodoArriba);
  seek(Arbol.I, PosMedio);
  write(Arbol.I, NodoMedio);
  seek(Arbol.I, PosAbajo);
  write(Arbol.I, NodoAbajo);
  seek(Arbol.C, 0);
  Write(Arbol.C, RC);

  DisminuirNiveles(Arbol, NodoArriba.hd);
  AumentarNiveles(Arbol, NodoArriba.hi);
  DisminuirNiveles(Arbol, NodoMedio.hi);

end;

Procedure AumentarNiveles(var Arbol: tMeIndiceTri; raiz: tpostri);
var
  N: tNodoIndiceTri;
begin
  If raiz = PosNula_Tri(Arbol) then
    exit;
  // Primero recursivo tendiendo a la Izquierda
  DisminuirNiveles(Arbol, ProximoIzq_Tri(Arbol, raiz));
  ObtenerNodo(Arbol, raiz, N);
  N.nivel := N.nivel + 1;
  seek(Arbol.I, raiz);
  Write(Arbol.I, N);
  // Recursividad tendiendo a la Derecha.
  DisminuirNiveles(Arbol, ProximoDer_Tri(Arbol, raiz));
end;


procedure BalancearArbol_Tri(var me: tMeIndiceTri);
var
  cont: integer;
  balanceado: boolean;
  pos: tpostri;
  N: tNodoIndiceTri;
begin
  balanceado := true;
  // AbrirMe_Indice (MeID);
  pos := _posnula_tri;
  AVL_Indice(me, Raiz_tri(me), pos, balanceado);
  if not balanceado then
  begin
    cont := 0;
    { El contador lo utilizo para prevenir que un bucle infinito por error
      acontezca, el cual seg�n lo probado no deberia pasar }
    While (cont <= 99999) and (not balanceado) Do
    begin
      balanceado := true;
      pos := _posnula_tri;
      // AbrirMe_Indice (MeID);
      AVL_Indice(me, Raiz_tri(me), pos, balanceado);
      If (not balanceado) then
      begin
        ObtenerNodo(me, pos, N);
        CasoDeDesequilibrio(me, pos);
      end;
      cont := cont + 1;
      // CerrarMe_Indice (MeID);
    end;
  end;
end;



end.
