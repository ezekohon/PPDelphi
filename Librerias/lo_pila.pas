unit lo_pila; // BOLILLERO

interface

uses
  classes, sysutils, globals;

const
  _RUTA = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\';
  _RUTA_ARCHIVO_DATOS =
    'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\BOLILLERO.DAT';
  _RUTA_ARCHIVO_CONTROL =
    'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\BOLILLERO.CON';
  _ARCHIVO_BOLILLERO_DATOS = 'BOLILLERO.DAT';
  _ARCHIVO_BOLILLERO_CONTROL = 'BOLILLERO.CON';
    _ARCHIVO_PREMIOS_DATOS = 'PREMIOS.DAT';
  _ARCHIVO_PREMIOS_CONTROL = 'PREMIOS.CON';
  __POSNULA = -1;
  __CLAVENULA = '';
  __LONGCLAVE = 4;
  __TOKEN = 'XXX';

type
  TipoPos = longint;

  TipoClave = string[__LONGCLAVE];

  tDatoPila = Record
    Numero: integer; // bolillero
    tipoPremio: tTipoPremio; // ganadores
    importe: real; // ganadores
    idCarton: integer; // ganadores
    idJugador:string[15]; //mePremios
    Enlace: TipoPos;
    nivel: integer;
  End;

  TipoArchivoDato = file of tDatoPila;

  tControlPila = Record
    Pri: TipoPos;
    Ult: TipoPos;
    bajas: TipoPos;
    cantidad: integer;
  End;

  TipoArchivoControl = file of tControlPila;

  TipoPila = record
    D: TipoArchivoDato;
    C: TipoArchivoControl;
  end;

var
  MeBOLILLERO: TipoPila;
  MePilaGanadores: TipoPila;
  //MePremios: TipoPila;

procedure crearME(var pila: TipoPila; archivoDatos: string;
  archivoControl: string);
Procedure AbrirMe(Var pila: TipoPila);
Procedure CerrarMe(Var pila: TipoPila);
function pilaVacia(var pila: TipoPila; cabeceraControl: TipoPos = 0): boolean;
procedure tope(var pila: TipoPila; var reg: tDatoPila;
  cabeceraControl: TipoPos = 0);
procedure apilar(var pila: TipoPila; reg: tDatoPila;
  cabeceraControl: TipoPos = 0); // push
procedure desapilar(var me: TipoPila; cabeceraControl: TipoPos = 0); // pop
// procedure ordenarPila(var pila: TipoPila);
function cantidadElemEnPila(var pila: TipoPila;
  cabeceraControl: TipoPos = 0): integer;
procedure insertarCabeceraControl(var pila: TipoPila; cabeceraControl: TipoPos);
function buscarPremio(var pila: TipoPila; premio: tTipoPremio;
  cabeceraControl: TipoPos): boolean; // PROBAR

implementation

procedure crearME(var pila: TipoPila; archivoDatos: string;
  archivoControl: string);
var
  berrrorcontrol, berrordatos: boolean;
  rc: tControlPila;
begin
  assign(pila.D, archivoDatos); // _RUTA + _ARCHIVO_DATOS);
  assign(pila.C, archivoControl); // _RUTA + _ARCHIVO_CONTROL);
{$I-}
  reset(pila.C);
  berrrorcontrol := ioresult <> 0;
  reset(pila.D);
  berrordatos := ioresult <> 0;
  if berrrorcontrol and berrordatos then
  begin
    rewrite(pila.C);
    rewrite(pila.D);
    rc.Pri := __POSNULA;
    rc.Ult := __POSNULA;
    rc.bajas := __POSNULA;
    rc.cantidad := 0;
    seek(pila.C, 0);
    write(pila.C, rc);

  end;
  /// habria que agregar los casos para si hay error en control y otro si hay error en datos

  close(pila.C);
  close(pila.D);
{$I+}
end;

Procedure AbrirMe(Var pila: TipoPila);
// reset a los 2 archivos del M.E.
Begin
  reset(pila.D);
  reset(pila.C);
End;

Procedure CerrarMe(Var pila: TipoPila);
// close M.E.
Begin
  close(pila.D);
  close(pila.C);
End;

function pilaVacia(var pila: TipoPila; cabeceraControl: TipoPos = 0): boolean;
var
  rc: tControlPila;
begin
  seek(pila.C, cabeceraControl);
  read(pila.C, rc);
  pilaVacia := (rc.Pri = __POSNULA);
end;

procedure apilar(var pila: TipoPila; reg: tDatoPila;
  cabeceraControl: TipoPos = 0); // BIEN
var
  rc: tControlPila;
  rd: tDatoPila;
  pos: TipoPos;
begin
  seek(pila.C, cabeceraControl);
  read(pila.C, rc);
  if rc.bajas = __POSNULA then
    pos := fileSize(pila.D)
  else
  begin
    pos := rc.bajas;
    seek(pila.D, pos);
    read(pila.D, rd);
    rc.bajas := rd.Enlace;
  end;
  reg.Enlace := rc.Pri;
  rc.Pri := pos;
  seek(pila.D, pos);
  write(pila.D, reg);
  rc.cantidad := rc.cantidad + 1;
  seek(pila.C, cabeceraControl);
  write(pila.C, rc);

end;

procedure desapilar(var me: TipoPila; cabeceraControl: TipoPos = 0);
var
  rc: tControlPila;
  raux: tDatoPila;
  posBorrado: TipoPos;
begin

  seek(me.C, cabeceraControl);
  read(me.C, rc);
  if rc.Pri = rc.Ult then // cola con 1 elemento
  begin // elimino y queda cola vacia
    posBorrado := rc.Pri;
    rc.Pri := __POSNULA;
    rc.Ult := __POSNULA;

  end
  else // caso general
  begin
    posBorrado := rc.Pri;
    seek(me.D, posBorrado);
    read(me.D, raux);
    rc.Pri := raux.Enlace; // raux.enlace es el segundo  BIEN

    // pongo como primero lo que antes era el segundo
    // seek(me.d, raux.Enlace);
    // read(me.d, rd);

  end;

  seek(me.D, posBorrado);
  read(me.D, raux);
  raux.Enlace := rc.bajas;
  rc.bajas := posBorrado;

  rc.cantidad := rc.cantidad - 1;
  seek(me.C, cabeceraControl);
  write(me.C, rc);
  seek(me.D, posBorrado);
  write(me.D, raux);


  // seek(me.C, 0);
  // read(me.C, rc);
  // if rc.Pri = rc.Ult then // cola con 1 elemento
  // begin // elimino y queda cola vacia
  // posBorrado := rc.Pri;
  // rc.Pri := __POSNULA;
  // rc.Ult := __POSNULA;
  //
  // end
  // else // caso general
  // begin
  // posactual := filepos(me.D);
  //
  // { Pos tendra el tope de la pila }
  // pos := rc.Pri;
  // { Leo el tope de la pila }
  // seek(me.D, pos);
  // read(me.D, rd);
  //
  // { Ahora el primero de la pila es el enlace del tope }
  // rc.Pri := rd.Enlace;
  //
  // { El enlace del registro retirado apuntara al viejo primer borrado }
  // rd.Enlace := rc.bajas;
  //
  // { El nuevo primer borrado es el que acabo de retirar de la pila }
  // rc.Pri := pos;
  // end;
  //
  // seek(me.D, pos);
  // write(me.D, rd);
  // seek(me.C, 0);
  // write(me.C, rc);
  // seek(me.D, posactual);

end;

// tope es igual a frente
procedure tope(var pila: TipoPila; var reg: tDatoPila;
  cabeceraControl: TipoPos = 0);
var
  rc: tControlPila;
begin
  seek(pila.C, cabeceraControl);
  read(pila.C, rc);
  seek(pila.D, rc.Pri);
  read(pila.D, reg);
end;

// NO LO USO
{ procedure ordenarPila(var pila: TipoPila);
  var
  Ord, aux: TipoPila;

  rc: tControlPila;
  rd, r2, Rord, raux: tDatoPila;
  pos: TipoPos;
  begin
  crearME(Ord); // copia de original
  crearME(aux);
  AbrirMe(Ord);
  AbrirMe(aux);

  while not pilaVacia(pila) do
  begin
  tope(pila, rd);
  desapilar(pila);
  apilar(Ord, rd);
  end;
  /// queda al reves

  while not pilaVacia(pila) do
  begin
  tope(pila, r2);
  desapilar(pila);
  tope(Ord, Rord);
  if (Rord.Numero < r2.Numero) then
  apilar(aux, r2)
  else
  begin
  desapilar(Ord);
  apilar(aux, Rord);
  apilar(Ord, r2);
  end;
  end;

  // vuelco
  while not pilaVacia(aux) do
  begin
  tope(aux, raux);
  desapilar(aux);
  apilar(pila, raux);
  end;

  // vuelco
  while not pilaVacia(Ord) do
  begin
  tope(Ord, Rord);
  apilar(pila, Rord);
  desapilar(Ord);
  end;

  end;
}
function cantidadElemEnPila(var pila: TipoPila;
  cabeceraControl: TipoPos = 0): integer;
var
  rc: tControlPila;
begin
  seek(pila.C, cabeceraControl);
  read(pila.C, rc);
  result := rc.cantidad;
end;

procedure insertarCabeceraControl(var pila: TipoPila; cabeceraControl: TipoPos);
var
  rc: tControlPila;
begin
  reset(pila.C);
  rc.Pri := __POSNULA;
  rc.Ult := __POSNULA;
  rc.bajas := __POSNULA;
  rc.cantidad := 0;
  seek(pila.C, cabeceraControl);
  write(pila.C, rc);
end;

function buscarPremio(var pila: TipoPila; premio: tTipoPremio;
  cabeceraControl: TipoPos): boolean;
{ Metodo Recursivo }
var
  reg: tDatoPila;
begin
  If not pilaVacia(pila, cabeceraControl) then
  begin
    tope(pila, reg, cabeceraControl);
    desapilar(pila, cabeceraControl);

    If reg.tipoPremio = premio then
    begin
      result := true;
    end
    else
      buscarPremio(pila, premio, cabeceraControl);

    apilar(pila, reg, cabeceraControl);
  End
  else
  begin
    result := false;
  end;
end;

end.
