unit lo_pila;


interface

uses
  classes, sysutils;

const
  _RUTA = 'C:\Users\Ezequiel\Google Drive\Juan23\PROG2\MIO\TRABAJOFINALDELPHI\Archivos\';
  _ARCHIVO_DATOS = 'BolilleroPila.DAT';
  _ARCHIVO_CONTROL = 'BolilleroPila.CON';
  __POSNULA=-1;
  __CLAVENULA='';
  __LONGCLAVE = 4;
  __TOKEN = 'XXX';

type
TipoPos = longint;

TipoClave = string[__LONGCLAVE];

TipoDato =  Record
            Numero: integer;
            Enlace: tipoPos;
            End;

TipoArchivoDato = file of TipoDato;

TipoControl = Record
              Pri: tipopos;
              Ult: tipopos;
              bajas: tipopos;
              End;

TipoArchivoControl = file of TipoControl;

TipoPila = record
         D: TipoArchivoDato;
         C: TipoArchivoControl;
         end;
var
  MeBOLILLERO: tipopila;

procedure crearME(var pila:tipoPila; archivo:string);
Procedure AbrirMe (Var pila:tipoPila);
Procedure CerrarMe (Var pila:tipoPila);
function pilaVacia(var pila:tipopila):boolean;
procedure tope (var pila:tipopila; var reg:tipoDato);
procedure apilar (var pila:tipoPila; reg:tipoDato);  //push
procedure desapilar(var cola:tipoPila);              //pop
procedure ordenarPila(var pila:tipoPila);

implementation

procedure crearME(var pila:tipoPila; archivo:string);
var
   berrrorcontrol,berrordatos: boolean;
   rc: tipoControl;
begin
     assign(pila.D, _RUTA + _ARCHIVO_DATOS);
     assign(pila.C, _RUTA + _ARCHIVO_CONTROL);
     {$I-}
     reset(pila.c);
     berrrorcontrol:=ioresult<>0;
     reset(pila.d);
     berrordatos:=ioresult<>0;
     if berrrorcontrol and berrordatos then
     begin
             rewrite(pila.C);
             rewrite(pila.D);
             rc.Pri:=__POSNULA;
             rc.ult:=__POSNULA;
             rc.bajas:=__POSNULA;
             seek(pila.c, 0); //siempre hacer seek
             write(pila.C, rc);

     end;      ///habria que agregar los casos para si hay error en control y otro si hay error en datos

     close(pila.C);
     close(pila.D);
     {$I+}
end;

Procedure AbrirMe (Var pila:tipoPila);
// reset a los 2 archivos del M.E.
Begin
     reset(pila.D);
     reset(pila.C);
End;

Procedure CerrarMe (Var pila:tipoPila);
// close M.E.
Begin
     close(pila.D);
     close(pila.C);
End;

function pilaVacia(var pila:tipopila):boolean;
var
  rc: tipocontrol;
begin
     seek(pila.C, 0);
     read(pila.c, rc);
     pilaVacia:= (rc.pri = __POSNULA);
end;

procedure apilar (var pila:tipoPila; reg:tipoDato);
var
  rc: tipocontrol;
  rd: tipodato;
  pos: tipopos;
begin
     seek(pila.C, 0);
     read(pila.c, rc);
     if rc.bajas = __POSNULA then
        pos:= fileSize(pila.d)
        else
          begin
               pos:= rc.bajas;
               seek(pila.d, pos);
               read(pila.d, rd);
               rc.bajas:= rd.enlace;
          end;
     reg.enlace:= rc.pri;
     rc.pri:=pos;
     seek(pila.d, pos);
     write(pila.d, reg);
     seek(pila.c, 0);
     write(pila.c,rc);
end;

//desapilar es igual que decolar
procedure desapilar(var cola:tipoPila);
var
    rc: tipocontrol;
  rd, raux: tipodato;
  pos, posBorrado: tipopos;
begin
     seek(cola.C, 0);
     read(cola.c, rc);
     if rc.pri = rc.ult then //cola con 1 elemento
     begin //elimino y queda cola vacia
          posBorrado:= rc.pri;
          rc.pri:= __POSNULA;
          rc.ult:= __POSNULA;

     end
     else //caso general
     begin
          posBorrado:= rc.pri;
          seek(cola.d, posBorrado);
          read(cola.d, raux);
          rc.pri:= raux.enlace;   //raux.enlace es el segundo
                                  //pongo como primero lo que antes era el segundo
     end;

     seek(cola.d, posBorrado);
     read(cola.d, raux);
     raux.enlace:= rc.bajas;
     rc.bajas:= posBorrado;
     seek(cola.c, 0);
     write(cola.c, rc);
     seek(cola.D, posBorrado);
     write(cola.d, raux);
end;
//tope es igual a frente
procedure tope (var pila:tipopila; var reg:tipoDato);
var
  rc: tipocontrol;
begin
     seek(pila.C, 0);
     read(pila.c, rc);
     seek(pila.d, rc.pri);
     read(pila.d, reg);
end;

procedure ordenarPila(var pila:tipoPila);
var
  Ord, aux: tipoPila;

    rc: tipocontrol;
  rd, r2, Rord, raux: tipodato;
  pos: tipopos;
begin
    crearME(Ord, '');  //copia de original
    crearME(aux, '');
    abrirME(Ord);
    abrirME(aux);

    while not pilavacia(pila) do
    begin
      tope(pila, rd);
      desapilar(pila);
      apilar(ord,rd);
    end;                             ///queda al reves

    while not pilavacia(pila) do
    begin
      tope(pila, r2);
      desapilar(pila);
      tope(ord, Rord);
      if (Rord.Numero < r2.Numero) then
         apilar(aux,r2)
      else
      begin
        desapilar(Ord);
        apilar(aux,Rord);
        apilar(ord, r2);
      end;
    end;

    //vuelco
    while not pilavacia(aux) do
    begin
      tope(aux, raux);
      desapilar(aux);
      apilar(pila,raux);
    end;

    //vuelco
    while not pilavacia(ord) do
    begin
      tope(ord,rord);
      apilar(pila,rOrd);
      desapilar(Ord);
    end;

end;

end.

