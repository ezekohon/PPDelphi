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

  _ARCHIVO_PILA_DATOS = 'DATOSGANADORES.DAT';
  _RUTA_ARCHIVO_PILA_DATOS = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\DATOSGANADORES.DAT';
  _ARCHIVO_PILA_CONTROL = 'DATOSGANADORES.CON';
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
  end;

  { tNodoDatosTri = record
    tipoPremio: tTipoPremio;
    importe: real;
    sig: integer;
    borrado: boolean;
    end;
  }
  tNivelesTri = record
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

  // tArchivoDatosTri =file of lo_pila.tipodato;
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
//Function BuscarNodo_Medio(var Arbol: tMeIndiceTri; clave: integer;                //CAMBIAR
//  var pos: tPosTri): boolean;
//Procedure InsertarNodo_Medio(var Arbol: tMeIndiceTri; var nodo: tNodoIndiceTri;   //CAMBIAR
//  pos, posPadre: tPosTri);

Function CantidadNodos(Arbol: tMeIndiceTri): integer;
Procedure ObtenerNodo(Arbol: tMeIndiceTri; pos: tPosTri; var nodo: tNodoIndiceTri);
Function ProximoDer_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
Function ProximoIzq_Tri(Arbol: tMeIndiceTri; pos: tPosTri): tPosTri;
Procedure Aumentar_UltimaCabeceraPila(var Arbol: tMeIndiceTri);
Function Obtener_UltimaCabeceraPila(Arbol: tMeIndiceTri): integer;

Var
  MeIndiceGanadores: tMeIndiceTri;


implementation

Procedure CrearMe_ArbolTri(var Arbol: tMeIndiceTri);
var
  RC: tControlTri;
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
    rc.ultimaCabeceraPila:= 0;
    RC.borrados := _posnula_tri;
    Write(Arbol.C, RC);
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

{ ****************************************************************************** }
{
Function BuscarNodo_Medio(var Arbol: tMeIndiceTri; clave: integer;
  var pos: tPosTri): boolean;
// Busca por clave secundaria: Si existe devuelve la posicion real, sino la pos
  //del padre.
  //La var pos viene con la posicion de el primer elemento. Seria el padre de la
  //raiz de el arbol binario por clave secundaria
var
  Reg: tNodoIndiceTri;
  RC: tControlTri;
  encont: boolean;
  posPadre, PosAux: tPosTri;
begin
  seek(Arbol.I, pos);
  read(Arbol.I, Reg);
  encont := false;
  pos := Reg.hm;
  posPadre := _posnula_tri;
  while (not encont) and (pos <> _posnula_tri) do
  begin
    seek(Arbol.I, pos);
    read(Arbol.I, Reg);
    if (clave = Reg.nroMovimiento) then
      encont := true
    else
    begin
      if (Reg.nroMovimiento > clave) then
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
  BuscarNodo_Medio := encont;
end;
}
/// /////////////////////////////////////////////////////////////////////////////
Procedure InsertarNodo_Tri(var Arbol: tMeIndiceTri; var nodo: tNodoIndiceTri;
  pos: tPosTri);
var // El pos que entra es la posicion fisica de su padre...
  posnueva: tPosTri;
  Reg, rd: tNodoIndiceTri;
  RC: tControlTri;
begin
  nodo.hm := _posnula_tri;
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

    { Cambio enlaces del padre }
    if (nodo.idGanador < Reg.idGanador) then
      Reg.hi := posnueva
    else
      Reg.hd := posnueva;
    { Grabo a su padre }
    seek(Arbol.I, pos);
    write(Arbol.I, Reg);
  end;

  RC.cantidad := RC.cantidad + 1;
  seek(Arbol.I, posnueva);
  write(Arbol.I, nodo); // se escribe el elemento en el archivo
  seek(Arbol.C, 0);
  write(Arbol.C, RC); // se actualiza el registro control

end;

{ ****************************************************************************** }

{
Procedure InsertarNodo_Medio(var Arbol: tMeIndiceTri; var nodo: tNodoIndiceTri;
  pos, posPadre: tPosTri);
// PosPadre contiene la posicion del Padre, asi el nodo que se vaya a insertar sea
//  o no Raiz del Sub Arbol Binario.
//  Pos contiene un -1 ante el caso de que el nodo a insertar sea raiz del
//  Sub Arbol Binario, o pos<>-1 si contiene la posicion del NodoPadre del Sub
//  Arbol Binario.

var
  posnueva: tPosTri;
  Reg, rd: tNodoIndiceTri;
  RC: tControlTri;
begin
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
  // Lo de arriba es para encontrar la nueva posicion fisica a utilizar
  /// //////////////////////////////////////////////////////////////////
  // Caso en el que es el primer elemento a insertar del Sub Arbol Binario
  If pos = _posnula_tri then
  begin
    seek(Arbol.I, posPadre);
    Read(Arbol.I, Reg);
    Reg.hm := posnueva;
    seek(Arbol.I, posPadre);
    write(Arbol.I, Reg);
    nodo.Padre := posPadre;
    nodo.hi := _posnula_tri;
    nodo.hd := _posnula_tri;
    nodo.hm := _posnula_tri;
  end
  Else
  // Caso que es hoja a insertar del Sub Arbol Binario
  begin
    seek(Arbol.I, pos);
    Read(Arbol.I, Reg);
    // Cambio enlaces del nodo a insertar
    nodo.Padre := pos;
    nodo.hd := _posnula_tri;
    nodo.hi := _posnula_tri;
    // Cambio enlaces del padre
    if (nodo.nroMovimiento < Reg.nroMovimiento) then
      Reg.hi := posnueva
    else
      Reg.hd := posnueva;
    seek(Arbol.I, pos);
    write(Arbol.I, Reg);
  end;
  RC.cantidad := RC.cantidad + 1;
  seek(Arbol.I, posnueva);
  write(Arbol.I, nodo);
  seek(Arbol.C, 0);
  write(Arbol.C, RC);
end;
}
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
Procedure ObtenerNodo(Arbol: tMeIndiceTri; pos: tPosTri; var nodo: tNodoIndiceTri);
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



end.