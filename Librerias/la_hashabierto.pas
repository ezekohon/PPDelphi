unit la_hashabierto;

interface

uses
  Classes, SysUtils,Graphics, LO_HashAbierto, Dialogs;

implementation

//alta y modificacion juego

function GenerarProximoIDusuario():tid;
var
  id:string;
begin
  //AbrirMe_Archivos(MeJugadores);
  if (HashVacio(MeJuego)) then
     id := '0'
  else
       id:= inttostr(strtoint(ObtenerUltimoID(MeJuego))+1);
  //CerrarMe_Archivos(MeJugadores);
  result:= id;
end;

end.
