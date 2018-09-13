unit la_arbolbinario;

 //C:\Users\ezeko\Google Drive\Juan 23\PROG 2\FinalesViejos\Programaci�n II - TP Final a�o 2010-Adan Gatica\Programaci�n II - TP Final a�o 2010-Adan Gatica\Librerias\Clientes

interface

uses
  Classes, SysUtils,Graphics, LO_ArbolBinario, Dialogs;

Function AltaJugador (Nick, Nombre, Mail, password: string; imagen: TBitmap):Boolean;
function BuscarMail(mail:string):boolean;
//function GenerarProximoIDusuario():tidusuario;
Procedure InsertarAdminCuandoMEVacio();

implementation

Function AltaJugador (Nick, Nombre, Mail, password: string; imagen: TBitmap):Boolean;
Var
  PosID, PosNICK:tPosArbol;
  PosJugador: tPosArchi;
  Reg:tRegDatos;
  ExisteNICK, ExisteMail:Boolean;
  N:tNodoIndice;
  IdUsuario: tIDusuario;
  ultimoid: tidusuario;
Begin

  //obtengo ultimo IDusuario
  AbrirMe_Archivos(MeJugadores);
  ultimoid:= ObtenerUltimoID_Archivos(MeJugadores);
  CerrarMe_Archivos(MeJugadores);

  //Busco en IndiceNick si existe el NICK a cargar...
  AltaJugador:=False;
  AbrirMe_Indice (MeNick);
  ExisteNICK:= BuscarNodo_Indice (MeNick,Nick,PosNICK);
  CerrarMe_Indice(MeNick);

  //por las dudas busco que no est�, y sino traigo ultima posicion
  AbrirMe_Indice (MeID);
  BuscarNodo_Indice (MeID,ultimoid,PosID);
  CerrarMe_Indice(MeID);

  //chequear si email se repite(una funcion aca en LA)
  AbrirMe_Archivos(MeJugadores);
  ExisteMail := BuscarMail(mail);
  //CerrarMe_Archivos(MeJugadores);

  If not ExisteNICK and not existeMail then //and existe mail = false
  Begin
    //Inserto en la ultima posicion de Clientes.
    AbrirMe_Archivos(MeJugadores);
    Reg.clave:= ObtenerProximoID_Archivos(MeJugadores); //id autogenerado (hacer metodo aca)
    reg.password:= password;
    Reg.nick := Nick;
    Reg.nombre:= Nombre;
    Reg.mail:= mail;

    BuscarInfoMe_Archivos (MeJugadores,idUsuario,PosJugador); //si no esta me da el ultimo+1. Solo para q me de ultimo+1
    InsertarInfoMe_Archivos (MeJugadores,PosJugador,Reg);
    CerrarMe_Archivos(MeJugadores);

    //Inserto en Indice NICK en la Posicion devuelta por BuscarNodo_Indice
    AbrirMe_Indice (MeNICK);
    N.PosEnDatos:= PosJugador;
    N.clave:= NICK;
    InsertarNodo_Indice (MeNICK,N,PosNICK);
    CerrarMe_Indice (MeNICK);

    //Inserto en Indice ID
    AbrirMe_Indice (MeID);
    N.PosEnDatos:=PosJugador;
    N.clave:= reg.clave; //el IDUSUARIO
    InsertarNodo_Indice (MeID,N,PosID);
    CerrarMe_Indice (MeID);


    AltaJugador:=True;
    ShowMessage('Insertado' + '  -  posendatos' + inttostr(posJugador) + '  - clave' + reg.clave);
  End
  else
    ShowMessage('Nick o eMail ya ingresado!');
End;

function BuscarMail(mail:string):boolean;
var
  encontrado: boolean;
  reg: tregdatos;
  i: integer;
begin
  encontrado:= false;
  AbrirMe_Archivos(MeJugadores);
  if MeVacio_Archivos(MeJugadores) then
    encontrado:= false
  else
  begin
     for i:= Primero_Archivos(MeJugadores) to Ultimo_archivos(meJugadores) do
      begin
         //AbrirMe_Archivos(MeJugadores);
         ObtenerInfoMe_Archivos(mejugadores,i,reg);
         //CerrarMe_Archivos(MeJugadores);
         if reg.mail = mail then
            encontrado:= true;
      end;
  end;

  CerrarMe_Archivos(MeJugadores);
  result:= encontrado;
end;

//function GenerarProximoIDusuario():tidusuario;
//var
//  id:string;
//begin
//  //AbrirMe_Archivos(MeJugadores);
//  if (MeVacio_Archivos(MeJugadores)) then
//     id := '0'
//  else
//       id:= inttostr(strtoint(ObtenerUltimoID_Archivos(MeJugadores))+1);
//  //CerrarMe_Archivos(MeJugadores);
//  result:= id;
//end;

Procedure InsertarAdminCuandoMEVacio();
begin
  AbrirMe_Archivos(MeJugadores);
  if MeVacio_Archivos(MeJugadores) then
      AltaJugador('ADMINISTRADOR', 'admin', 'admin@admin.com', 'mandrake', nil);
  CerrarMe_Archivos(MeJugadores);
end;

end.

