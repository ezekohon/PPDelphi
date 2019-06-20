unit la_hashabierto;

interface

uses
  Classes, SysUtils,Graphics, LO_HashAbierto, Dialogs, la_pila, globals;

procedure restarCantidadCartonesVendidos(cantidad:integer; nombreEvento:nombreEventoHash);
function hayPartidaJugando(me:tmehash; out nombreEvento:string):boolean;
procedure empezarJuego(nombreEvento:string);
procedure finalizarJuego(nombreEvento:string);
procedure modificarPremioEntregado(juego: tRegDatosHash; tipoPremio: ttipopremio); //PROBAR
function isPremioEntregado (juego: tRegDatosHash; tipoPremio: ttipopremio):boolean;



implementation

//alta y modificacion juego

function GenerarProximoIDusuario():tid;
var
  id:integer;//string;
begin
  //AbrirMe_Archivos(MeJugadores);
  if (HashVacio(MeJuego)) then
     id := 0//'0'
  else
       id:= ObtenerUltimoID(MeJuego)+1;//inttostr(strtoint(ObtenerUltimoID(MeJuego))+1);
  //CerrarMe_Archivos(MeJugadores);
  result:= id;
end;

procedure restarCantidadCartonesVendidos(cantidad:integer; nombreEvento:nombreEventoHash);
var
  pos: tposhash;
  reg: tRegDatosHash;
begin
    BuscarHash(MeJuego,nombreEvento,pos);
    CapturarInfoHash(MeJuego,pos,reg);
    reg.TotalCartonesVendidos := reg.TotalCartonesVendidos-cantidad;
    ModificarHash(MeJuego,pos,reg);
end;

function hayPartidaJugando(me:tmehash; out nombreEvento:string):boolean; //PROBAR
//chequea en el me si hay una partida jugandose y si hay, devulve el nombre
var
  //i: integer;
  reg: tRegDatosHash;
  pos: tPosHash;
  hayJugando: boolean;
begin
      hayJugando:= false;
      Pos:=lo_hashabierto.Primero (MeJuego);
      While ((pos <> _posnula) and (not hayJugando)) do
     //  for i := 0 to lo_hashabierto.Ultimo(Me) do
      begin
        CapturarInfoHash(Me,pos,reg);
        if (reg.estado = Jugando) then
         begin
              nombreEvento:= reg.nombreEvento;
              hayJugando:= true;

         end;
         pos:=lo_hashabierto.Proximo(MeJuego,pos);
      end;

      result:= hayJugando;
end;

procedure empezarJuego(nombreEvento:string);
var
pos: tPosHash;
  reg: tRegDatosHash;
begin
        //modificar estado de la partida
        BuscarHash(MeJuego,nombreEvento,pos);
        CapturarInfoHash(MeJuego,pos,reg);
        reg.estado := Jugando;
        ModificarHash(MeJuego,pos,reg);

        //generar bolillero
        generarBolilleroMezclado();
end;

procedure finalizarJuego(nombreEvento:string);
var
  pos: tPosHash;
  reg: tRegDatosHash;
begin
        //modificar estado de la partida
        BuscarHash(MeJuego,nombreEvento,pos);
        CapturarInfoHash(MeJuego,pos,reg);
        reg.estado := tEstadoJuego.Finalizado;
        ModificarHash(MeJuego,pos,reg);
end;

procedure modificarPremioEntregado(juego: tRegDatosHash; tipoPremio: ttipopremio);
var
  pos: tPosHash;
  reg: tRegDatosHash;
begin
    BuscarHash(MeJuego,juego.nombreEvento,pos);
    CapturarInfoHash(MeJuego,pos,reg);

    reg.arrPremiosEntregados[integer(tipoPremio)].entregado := true;

    ModificarHash(MeJuego,pos,reg);
end;

function isPremioEntregado (juego: tRegDatosHash; tipoPremio: ttipopremio):boolean;
begin
    result:= juego.arrPremiosEntregados[integer(tipoPremio)].entregado;
end;



end.
