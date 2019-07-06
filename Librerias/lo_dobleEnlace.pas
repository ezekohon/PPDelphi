unit lo_dobleEnlace; // CARTONES

interface

uses SysUtils, math,globals;

const
  _posnula = -1;
  _ARCHIVO_DATOS = 'CARTONES.DAT';
  _ARCHIVO_CONTROL = 'CARTONES.CON';
  carpeta = 'D:\';
  //_RUTA = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\';

type
  tPos = _posnula .. maxint;
  tcantidad = longint;
  tcadena = String[40];
  numeroMatriz = 0 .. 75;

  tRegCampoMatriz = record
    numero: numeroMatriz;
    tachado: boolean;
  end;

  tMatriz = Array [0 .. 4, 0 .. 4] of tRegCampoMatriz;

  tRegControl_DE = record
    ultimoIdInterno: longint; // se autoincrementa(? inicial en 0
    // idJuego: String[10];  //de juegos.dat (lo_hashabierto)
    primero, ultimo: tPos;
    borrado: tPos;
    cantidad: integer;
  end;

  tRegDatos_DE = record
    idCarton: integer; // lo genera a partir del ultimoIdInterno
    // idJuego: integer;//String[10];   //de juegos.dat (lo_hashabierto)
    nombreEvento: string[20];
    idJugador: string[10]; // de jugadores.dat(lo_arbolbinario)
    grilla: tMatriz;
    ant, sig: tPos;
  end;

  archivoControl = File of tRegControl_DE;
  archivoDatos = File of tRegDatos_DE;

  MeDobleEnlace = record
    c: archivoControl;
    d: archivoDatos;
  end;

var
  MeCartones: MeDobleEnlace;

Procedure CrearMe(var me: MeDobleEnlace);
Function MeVacio(me: MeDobleEnlace): boolean;
procedure AbrirMe(var me: MeDobleEnlace);
Procedure Cerrarme(var me: MeDobleEnlace);
Function primero(var me: MeDobleEnlace): tPos;
Function ultimo(var me: MeDobleEnlace): tPos;
Function Borrados(var me: MeDobleEnlace; var pos: tPos): boolean;
Function cantidad(var me: MeDobleEnlace): tcantidad;
Function Anterior(var me: MeDobleEnlace; pos: tPos): tPos;
Function Proximo(var me: MeDobleEnlace; pos: tPos): tPos;
function CapturarInfo(var me: MeDobleEnlace; pos: tPos): tRegDatos_DE;
Procedure InsertarInfo(Var me: MeDobleEnlace; Reg: tRegDatos_DE; pos: tPos);
Function Buscar(var me: MeDobleEnlace; idCarton: integer; var pos: tPos)
  : boolean; { devuelve pos solo si encuentra al elemento }
Procedure Eliminar(Var me: MeDobleEnlace; pos: tPos);
Procedure Modificar(var me: MeDobleEnlace; pos: tPos; Reg: tRegDatos_DE);
function BuscarInfo(var me: MeDobleEnlace; Clave: integer; var pos: tPos)
  : boolean; { devuelve la pos en la que deberia ir }
Function ObtenerProximoIDInterno(var me: MeDobleEnlace): longint;

implementation

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Procedure CrearMe(var me: MeDobleEnlace);
var
  rc: tRegControl_DE;
begin

  assign(me.d, RUTA + _ARCHIVO_DATOS);
  assign(me.c, RUTA + _ARCHIVO_CONTROL);
  if (not FileExists(RUTA + _ARCHIVO_DATOS)) or
    (not FileExists(RUTA + _ARCHIVO_CONTROL)) then
  begin
    Rewrite(me.d);
    Rewrite(me.c);
    rc.primero := _posnula;
    rc.ultimo := _posnula;
    rc.borrado := _posnula;
    rc.cantidad := 0;
    rc.ultimoIdInterno := 0;
    seek(me.c, 0);
    write(me.c, rc);
  end
  else
  begin
    Reset(me.d);
    Reset(me.c);
  end;
  Close(me.d);
  Close(me.c);
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function MeVacio(me: MeDobleEnlace): boolean;
var
  rc: tRegControl_DE;
begin
  seek(me.c, filesize(me.c) - 1);
  read(me.c, rc);
  result := (rc.ultimo = _posnula);
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Procedure AbrirMe(var me: MeDobleEnlace);
begin
  Reset(me.d);
  Reset(me.c);
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Procedure Cerrarme(var me: MeDobleEnlace);
begin
  CloseFile(me.d);
  CloseFile(me.c);
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function primero(var me: MeDobleEnlace): tPos;
var
  rc: tRegControl_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  result := rc.primero;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function ultimo(var me: MeDobleEnlace): tPos;
var
  rc: tRegControl_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  result := rc.ultimo;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function Borrados(var me: MeDobleEnlace; var pos: tPos): boolean;
{ devuelve true y la posicion si hay borrados - si no devuelve -1 en pos y falso }
var
  rc: tRegControl_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  pos := rc.borrado;
  if pos = _posnula then
    result := false
  else
    result := true;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function cantidad(var me: MeDobleEnlace): tcantidad;
{ devuelve cantidad de elementos - si es PosNula, el archivo esta vacio }
var
  rc: tRegControl_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  result := rc.cantidad;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function Anterior(var me: MeDobleEnlace; pos: tPos): tPos;
var
  rc: tRegControl_DE;
  rd: tRegDatos_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  if (pos = _posnula) then
    result := _posnula
  else
  begin
    seek(me.d, pos);
    read(me.d, rd);
    result := rd.ant;
  end;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function Proximo(var me: MeDobleEnlace; pos: tPos): tPos;
var
  rc: tRegControl_DE;
  rd: tRegDatos_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  if (pos = _posnula) then
    result := _posnula
  else
  begin
    seek(me.d, pos);
    read(me.d, rd);
    result := rd.sig;
  end;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
function CapturarInfo(var me: MeDobleEnlace; pos: tPos): tRegDatos_DE;
var
  rd: tRegDatos_DE;
begin
  seek(me.d, pos);
  read(me.d, rd);
  result := rd;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Procedure InsertarInfo(Var me: MeDobleEnlace; Reg: tRegDatos_DE; pos: tPos);
Var
  RegControl: tRegControl_DE;
  RegDatos, RegDatosAnt, actualizoant: tRegDatos_DE;
  PosNueva: tPos;

Begin
  seek(me.c, 0);
  Read(me.c, RegControl);

  If (RegControl.borrado = _posnula) Then
    PosNueva := filesize(me.d)
  Else
  Begin
    PosNueva := RegControl.borrado;
    seek(me.d, PosNueva);
    Read(me.d, RegDatos);
    RegControl.borrado := RegDatos.sig;
    { actualizo enlace del siguiente borrado a -1 }
    if (RegDatos.sig <> _posnula) then
    begin
      seek(me.d, RegDatos.sig);
      read(me.d, actualizoant);
      actualizoant.ant := _posnula;
      seek(me.d, RegDatos.sig);
      write(me.d, actualizoant);
    end;
  End;

  If ((RegControl.primero = _posnula) And (RegControl.ultimo = _posnula)) Then
  Begin
    { Insertar al Principio. Esta vacio el ME }
    RegControl.primero := PosNueva;
    RegControl.ultimo := PosNueva;
    Reg.sig := _posnula;
    Reg.ant := _posnula;
  End
  Else
  Begin
    If (pos = RegControl.primero) Then
    Begin
      { Insertar al Principio }
      Reg.sig := RegControl.primero;
      Reg.ant := _posnula;

      seek(me.d, RegControl.primero);
      Read(me.d, RegDatos);
      RegDatos.ant := PosNueva;
      seek(me.d, RegControl.primero);
      Write(me.d, RegDatos);

      RegControl.primero := PosNueva;
    End
    Else If pos = _posnula // {(Pos <> RegControl.Ultimo)and}(pos<>-1)
    Then
    Begin
      { Insertar al Final }
      seek(me.d, RegControl.ultimo);
      Read(me.d, RegDatos);
      RegDatos.sig := PosNueva;
      seek(me.d, RegControl.ultimo);
      Write(me.d, RegDatos);

      Reg.ant := RegControl.ultimo;
      Reg.sig := _posnula;
      RegControl.ultimo := PosNueva;
    End
    else
    begin

      { MIRAR }                  { Insertar al Medio }                                       { MIRAR }
      { Leo el dato en la posicion donde debe ubicarse }
      seek(me.d, pos);
      Read(me.d, RegDatos);
      Reg.ant := RegDatos.ant;
      RegDatos.ant := PosNueva;
      seek(me.d, pos);
      Write(me.d, RegDatos);
      { Leo el dato ant donde debe ubicarse para cambiar su sig }
      seek(me.d, Reg.ant);
      Read(me.d, RegDatosAnt);
      Reg.sig := RegDatosAnt.sig;
      RegDatosAnt.sig := PosNueva;
      seek(me.d, PosNueva);
      write(me.d, Reg);
      seek(me.d, Reg.ant);
      write(me.d, RegDatosAnt);

    end;
  End;

  RegControl.cantidad := RegControl.cantidad + 1;
  RegControl.ultimoIdInterno := Reg.idCarton;
  seek(me.c, 0);
  Write(me.c, RegControl);
  seek(me.d, PosNueva);
  Write(me.d, Reg);
End;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Function Buscar(var me: MeDobleEnlace; idCarton: integer;
  var pos: tPos): boolean;
var
  rc: tRegControl_DE;
  Reg: tRegDatos_DE;
  posaux: tPos;
  siguiente: tPos;
  resultado: boolean;
begin
  seek(me.c, 0);
  read(me.c, rc);
  siguiente := rc.primero;
  posaux := siguiente;
  resultado := false;
  while (siguiente <> _posnula) and (not resultado) do
  begin
    seek(me.d, siguiente);
    read(me.d, Reg);
    if (idCarton = Reg.idCarton) then
    begin
      resultado := true;
      pos := posaux;
    end
    else
    begin
      siguiente := Reg.sig;
      posaux := Reg.sig;
    end;
  end;
  result := resultado;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////
Procedure Eliminar(Var me: MeDobleEnlace; pos: tPos);
Var
  rc: tRegControl_DE;
  rd, RDsig, RDant, RDborrados: tRegDatos_DE;
  posdelete: tPos;
  recuperaborrado: tPos;
Begin
  seek(me.c, 0);
  Read(me.c, rc);

  posdelete := rc.primero;

  If (rc.primero = rc.ultimo) Then
  Begin
    { Elimino la unica celula de la lista }
    posdelete := rc.primero;
    seek(me.d, posdelete);
    Read(me.d, rd);
    recuperaborrado := rc.borrado;
    rc.primero := _posnula;
    rc.ultimo := _posnula;
    rd.sig := recuperaborrado;

  End
  Else
  Begin
    If (pos = rc.primero) { Elimino la Primera celula }
    Then
    Begin
      posdelete := rc.primero;
      seek(me.d, posdelete);
      Read(me.d, rd);

      seek(me.d, rd.sig);
      Read(me.d, RDsig);
      RDsig.ant := _posnula;
      seek(me.d, rd.sig);
      Write(me.d, RDsig);

      rc.primero := rd.sig;

      rd.sig := rc.borrado;
      rd.ant := _posnula;
    End
    else if (pos = rc.ultimo) then { elimino la ultima celula }
    begin
      posdelete := rc.ultimo;
      seek(me.d, posdelete);
      Read(me.d, rd);
      seek(me.d, rd.ant);
      Read(me.d, RDant);
      RDant.sig := _posnula;
      seek(me.d, rd.ant);
      Write(me.d, RDant);
      rc.ultimo := rd.ant;
      rd.sig := rc.borrado;
      rd.ant := _posnula;
    end
    else
    begin { elimino del medio }
      posdelete := pos;
      seek(me.d, posdelete);
      read(me.d, rd);
      seek(me.d, rd.ant);
      read(me.d, RDant);
      seek(me.d, rd.sig);
      read(me.d, RDsig);
      RDant.sig := rd.sig;
      RDsig.ant := rd.ant;
      seek(me.d, rd.ant);
      write(me.d, RDant);
      seek(me.d, rd.sig);
      write(me.d, RDsig);
      rd.sig := rc.borrado;
      rd.ant := _posnula;
    end;
  End;
  If (rc.borrado <> _posnula) Then
  Begin
    seek(me.d, rc.borrado);
    Read(me.d, RDborrados);
    RDborrados.ant := posdelete;
    seek(me.d, rc.borrado);
    Write(me.d, RDborrados);
  End;
  rc.borrado := posdelete;
  rc.cantidad := rc.cantidad - 1;
  seek(me.d, posdelete);
  Write(me.d, rd);
  seek(me.c, 0);
  Write(me.c, rc);
End;

/// ////////////////////////////////////////////////////////////////////////////
Procedure Modificar(var me: MeDobleEnlace; pos: tPos; Reg: tRegDatos_DE);
begin
  seek(me.d, pos);
  write(me.d, Reg);
end;

function BuscarInfo(var me: MeDobleEnlace; Clave: integer;
  var pos: tPos): boolean;
var
  rc: tRegControl_DE;
  PosAnt, p: tPos;
  corte, encontre: boolean;
  rd: tRegDatos_DE;
begin
  seek(me.c, 0);
  Read(me.c, rc);
  pos := rc.primero;
  encontre := false;
  corte := false;
  While (Not encontre) and (Not corte) and (pos <> _posnula) do
  begin
    seek(me.d, pos);
    Read(me.d, rd);
    If rd.idCarton = Clave then
      encontre := true
    else if rd.idCarton > Clave then
      corte := true
    else
    begin
      // PosAnt:= pos;
      pos := rd.sig;
    end;

  end;
  BuscarInfo := encontre;
  // pos:= posant;
end;

/// ////////////////////////////////////////////////////////////////////
Function ObtenerProximoIDInterno(var me: MeDobleEnlace): longint;
var
  rc: tRegControl_DE;
begin
  seek(me.c, 0);
  read(me.c, rc);
  result := rc.ultimoIdInterno + 1;
end;

end.
