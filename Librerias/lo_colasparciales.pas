unit lo_colasparciales;

interface

const
  _RUTA = 'C:\Users\Ezequiel\Google Drive\Juan23\PROG2\MIO\TRABAJOFINALDELPHI\Archivos\';
  _ARCHIVO_DATOS = 'TiradasCola.DAT';
  _ARCHIVO_CONTROL = 'TiradasCola.CON';
  __POSNULA= -1;
  __LONGCLAVE = 4;

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

TipoCola = record
         D: TipoArchivoDato;
         C: TipoArchivoControl;
         end;

procedure crearME(var cola:TipoCola; archivo:string);
Procedure AbrirMe (Var cola:TipoCola);
Procedure CerrarMe (Var cola:TipoCola);
function colaVacia(var cola:tipocola):boolean;
procedure encolar(var cola:tipoCola; reg:tipoDato; esCabecera:boolean);
procedure decolar(var cola:tipocola);
procedure tope (var cola:tipocola; var reg:tipoDato);

var
  MeTIRADAS: tipocola;



implementation

procedure crearME(var cola:TipoCola; archivo:string);
var
   berrrorcontrol,berrordatos: boolean;
   rc: tipoControl;
begin
     assign(cola.D, _RUTA + _ARCHIVO_DATOS);
     assign(cola.C, _RUTA + _ARCHIVO_CONTROL);
     {$I-}
     reset(cola.c);
     berrrorcontrol:=ioresult<>0;
     reset(cola.d);
     berrordatos:=ioresult<>0;
     if berrrorcontrol and berrordatos then
     begin
             rewrite(cola.C);
             rewrite(cola.D);
             rc.Pri:=__POSNULA;
             rc.ult:=__POSNULA;
             rc.bajas:=__POSNULA;
             seek(cola.c, 0); //siempre hacer seek
             write(cola.C, rc);

     end;      ///habria que agregar los casos para si hay error en control y otro si hay error en datos

     close(cola.C);
     close(cola.D);
     {$I+}
end;

Procedure AbrirMe (Var cola:TipoCola);
// reset a los 2 archivos del M.E.
Begin
     reset(cola.D);
     reset(cola.C);
End;

Procedure CerrarMe (Var cola:TipoCola);
// close M.E.
Begin
     close(cola.D);
     close(cola.C);
End;

function colaVacia(var cola:tipocola):boolean;
var
  rc: tipocontrol;
begin
     seek(cola.C, 0);
     read(cola.c, rc);
     colaVacia:= (rc.pri = __POSNULA);
end;

procedure encolar(var cola:tipoCola; reg:tipoDato; esCabecera:boolean);
var
  rc: tipocontrol;
  rd, raux: tipodato;
  posNueva: tipoPos;
begin
     seek(cola.C, 0);
     read(cola.c, rc);

     //determinar posNueva
     if (rc.bajas=__POSNULA) then
        posNueva:= fileSize(cola.d)
     else
      begin
           posNueva:= rc.bajas;
           seek(cola.D, posNueva);
           read(cola.d, rd);
           rc.bajas:= rd.enlace;
      end;


     if rc.pri = __POSNULA then //si cola vacia
     begin
          rc.pri:= posNueva;
          rc.ult:= posNueva;
          reg.Enlace:= __POSNULA;
     end
     else      //caso general, encolo al final
     begin
          seek(cola.d, rc.ult);
          read(cola.d, raux);
          if (esCabecera) then
            rAux.Enlace:= __POSNULA
          else
            raux.enlace:= posNueva;


          seek(cola.d, rc.ult);  //lo guardo
          write(cola.d, raux);
          reg.Enlace:= __POSNULA;//posNueva; //__POSNULA????
          rc.ult:= posNueva;
     end;

     seek(cola.C, 0);
     write(cola.C, rc);
     seek(cola.d, posnueva);
     write(cola.d, reg);
end;

procedure decolar(var cola:tipocola);
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
procedure tope (var cola:tipocola; var reg:tipoDato);
var
  rc: tipocontrol;
begin
     seek(cola.C, 0);
     read(cola.c, rc);
     seek(cola.d, rc.pri);
     read(cola.d, reg);
end;

end.
