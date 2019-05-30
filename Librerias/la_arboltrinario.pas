unit la_arboltrinario;  //GANADORES

interface

uses
  SysUtils,StrUtils ,lo_arboltrinario, lo_pila, lo_hashabierto,lo_arbolbinario,Dialogs,globals;

  function generarClaveGanador(idUsuario:tidusuario; nombreEvento:string):string;
  Function AltaGanador(claveBusqueda: string; tipoPremio:tTipoPremio; importe:real; idCarton:integer):Boolean;
  procedure restarPremioAPozoAcumulado(juego:tRegDatosHash; importePremio:real);
  function importePorTipoPremio(juego:tRegDatosHash; tipoPremio:tTipoPremio):real;
  function esJuegoBuscado(claveBusqueda:string; nombreEvento:string):boolean;
  function espremioYaEntregadoAGanador(cabeceraPila:integer; tipoPremio:tTipoPremio):boolean;

implementation


Function AltaGanador(claveBusqueda: string; tipoPremio:tTipoPremio; importe:real; idCarton:integer):Boolean;
Var
  PosTri:tPosTri;
  Reg:tDatoPila;
  ExisteGANADOR:Boolean;
  N:tNodoIndiceTri;
  cabeceraPila: integer;
  //claveBusqueda: string[100];
Begin



  //Busco si existe ya la clave idUsuario_idJuego a cargar...
  AltaGanador:=False;

  ExisteGANADOR:= BuscarNodo_Tri (meindiceganadores,claveBusqueda,PosTri);

  Reg.tipoPremio:= tipoPremio; //id autogenerado.
  reg.importe:= importe;
  reg.idCarton := idCarton;

  //CASO 1: Ganador(combinacion jugador+juego) no existe
  If not ExisteGANADOR then
  Begin
    //En este caso, primero inserto el nodo del arbol

    //obtener cabeceraPila
    cabeceraPila:= Obtener_UltimaCabeceraPila(MeIndiceGanadores);
    Aumentar_UltimaCabeceraPila(MeIndiceGanadores);

    //insertar control cabecera pila
    insertarCabeceraControl(MePilaGanadores,cabeceraPila);

    //inserto nodo
    n.hm :=  cabeceraPila;
    n.idGanador:= claveBusqueda;
    InsertarNodo_Tri(MeIndiceGanadores,n,PosTri);


    //insertar reg datos pila


    lo_pila.apilar(MePilaGanadores,reg,cabeceraPila);

    result:=True;
    ShowMessage('Indice Insertado' + '  -  cabeceraPila' + inttostr(cabeceraPila) + '  - clave' + n.idGanador);
  End
  else
  begin
      //CASO 2: ya existe el ganador, lo encuentro e inserto en la pila
      //o hacerlo en 2 metodos separados?
      ObtenerNodo(MeIndiceGanadores,PosTri,N);
      apilar(MePilaGanadores,reg,n.hm); //hm es la pos a la cabecera de la pila

      ShowMessage('pila Insertado' + '  -  cabeceraPila' + inttostr(n.hm) + '  - clave' + n.idGanador);


     result := true;
  end;

End;

function generarClaveGanador(idUsuario:tidusuario; nombreEvento:string):string;
begin
  result:=  idUsuario + '_' + nombreEvento;
end;

function importePorTipoPremio(juego:tRegDatosHash; tipoPremio:tTipoPremio):real;
//dado un juego y un tipo de premio, devuelve el importe del premio
//hay que restar al pozo acumulado la cantidad que estoy dando de premio
var
  valor: real;
begin
  Case tipoPremio of
       LineaHorizontal : valor := juego.PozoAcumulado * juego.PorcentajePremioLinea;
       LineaVertical  : valor := juego.PozoAcumulado * juego.PorcentajePremioLinea;
       Diagonal1 : valor := juego.PozoAcumulado * juego.PorcentajePremioDiagonal;
       Diagonal2 : valor := juego.PozoAcumulado * juego.PorcentajePremioDiagonal;
       Cruz : valor := juego.PozoAcumulado * juego.PorcentajePremioCruz;
       CuadradoChico : valor := juego.PozoAcumulado * juego.PorcentajePremioCuadradoChico;
       CuadradoGrande : valor := juego.PozoAcumulado * juego.PorcentajePremioCuadradoGrande;
       Bingo : valor := juego.PozoAcumulado;
  else ShowMessage('unexpected shit');
  end;
  result:= valor;
end;

procedure restarPremioAPozoAcumulado(juego:tRegDatosHash; importePremio:real);
var
  pos: tPosHash;
  reg: tRegDatosHash;
begin
    BuscarHash(MeJuego,juego.nombreEvento,pos);
    CapturarInfoHash(MeJuego,pos,reg);
    reg.PozoAcumulado := reg.PozoAcumulado - importePremio;
    ModificarHash(MeJuego,pos,reg);
end;

function esPremioYaEntregadoAGanador(cabeceraPila:integer; tipoPremio:tTipoPremio):boolean;
//Determina si ya se insert� el premio X en la pila de un ganador determinado
begin
    result:= buscarPremio(MePilaGanadores,tipoPremio, cabeceraPila);
end;

function esPremioYaEntregadoEnJuego(juego:tRegDatosHash; tipoPremio:ttipoPremio):boolean;
//busca en el arbol, si ya se entreg� el premio a alg�n jugador de la partida actual
begin
     //hay que traversar todo el arbol, shit
end;

function esJuegoBuscado(claveBusqueda:string; nombreEvento:string):boolean;
//con una clave de ganador, y una clave de evento, devuelve si el ganador corresponde al evento
begin
  result:= Copy(claveBusqueda, pos('_',claveBusqueda)+1, Length(claveBusqueda)) = nombreEvento;
end;

end.
