unit LO_ArbolBinario; //JUGADORES

interface

uses SysUtils, Math, Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

const
  _posnula_arbol = -1;
  _posnula_archivo = -1;
  _clave_nula_archivo='00000000';
  _nombre_carpeta = 'Archivos\';
  _RUTA = 'C:\Users\Ezequiel\Google Drive\Juan23\PROG2\MIO\TrabajoFINAL\Archivos\';
  _ARCHIVO_DATOS = 'ArbolBinario.DATOS';
  _ARCHIVO_CONTROL = 'ArbolBinario.Control';

  _ARCHIVO_INDICE_ID = 'ArbolBinario.ID';
  _ARCHIVO_INDICE_NICK = 'ArbolBinario.NICK';

type
  tIDusuario = string[10];
  tcodrubro = 100..999;
  tClaveArchi= tIDusuario;
  tClaveArbol= string[60];
  tcadena = string[40];
  tposarbol = _posnula_arbol..maxint;
  tposarchi = _posnula_archivo..maxint;


  //ARCHIVOS  ///////////////////////////////////////

  tRegDatos = record
    nick: string[10];   //10 caracteres en mayus
    password: string[20];
    clave: tIDusuario;   //es el ID USUARIO
    nombre: string[10];
    fechaAlta: TDateTime ; //sysdate de la fecha alta
    foto: TBitmap;
    mail: string[20];
    estado: char;        //C(conectado)- D(desco)- B(baja) - X(bloqueado por admin)
    ultimaConexion: TDateTime;
  end;

  tRegControl = record
    ultimo: tposarchi;
    ultimoIDinterno: string[10];
  end;

 ArchivoControl = file of tRegControl;
 ArchivoDatos = file of tRegDatos;

 MeArchivos = record
   D: ArchivoDatos;
   C: ArchivoControl;
 end;

  //ARBOLES ////////////////////////////////

  tNodoIndice = record
    clave: tclavearbol;    //esto va a ser el ID o el NICK
    PosEnDatos: tposarchi;
    padre, hi, hd: tposarbol;
    borrado: boolean;
    nivel: integer;
  end;

  tControlArbol = record
    raiz: tposarbol;
    borrados: tposarbol;
    cantidad:integer;
    cant_niveles: integer;
  end;

  ArchivoIndiceArbol = file of tNodoIndice;
  ArchivoControlArbol = file of tControlArbol;

  MeArbol = record
    D: ArchivoIndiceArbol;
    C: ArchivoControlArbol;
  end;

 var
  MeJUGADORES: MeArchivos;
  MeID:  MeArbol;
  MeNICK: MeArbol;
  NodoIndice: tNodoIndice;

//AUX
function IsOpen(const txt:textFile):Boolean;
function IsFileInUse(fName: string) : boolean;
//ARBOLES ///////////////////////////////////////////////
Procedure CrearMe_Indice(var Arbol:MeArbol; Nombre_Archivo_Control, Nombre_Archivo_Datos: string);
procedure AbrirMe_Indice(var arbol: MeArbol);
procedure Cerrarme_indice(var arbol: MeArbol);
Procedure InsertarNodo_Indice(var Arbol:MeArbol; var nodo:tNodoIndice; pos:tPosArchi );
Procedure EliminarNodo_Indice(var Arbol:MeArbol; pos:tPosArbol);
Procedure ModificarInfoMe_Indice(var Arbol:MeArbol;Pos:tPosArbol;
                                                          Nodo:tNodoIndice);
Function  Cantidad_Indice(var arbol:MeArbol):integer;
Function  ObtenerInfo_Indice(var Arbol:MeArbol; pos: tPosArbol):tNodoIndice;
Function  BuscarNodo_Indice (var Arbol:MeArbol; clave:tClaveArbol;
                                                     var pos:tPosArbol):boolean;
Function  ArbolVacio_Indice(Arbol:MeArbol):boolean;
Function  PosNula_Indice(arbol:MeArbol):tPosArbol;
Function  Raiz_Indice(var Arbol:MeArbol):tPosArbol;
Function  Anterior_Indice(var Arbol:MeArbol; pos:tPosArbol):tPosArbol;
Function  ProximoIzq_Indice(Arbol:MeArbol; pos:tPosArbol):tPosArbol;
Function  ProximoDer_Indice(var Arbol:MeArbol; pos:tPosArbol):tPosArbol;
//BALANCEO ARBOLES //////////////////////////////////////
Procedure AVL_Indice (Arbol:MeArbol; Raiz: tPosArbol; var PosNodo:tPosArbol;
                                                            Var Balance:Boolean);
Function ProfundidadNodo (Arbol:MeArbol; Raiz: tPosArbol):Integer;
Procedure RightRight (var Arbol:MeArbol;PosNodo:tPosArbol);
Procedure LeftLeft (var Arbol:MeArbol;PosNodo:tPosArbol);
Procedure LeftRight (var Arbol:MeArbol;PosNodo:tPosArbol);
Procedure RightLeft (var Arbol:MeArbol;PosNodo:tPosArbol);
Procedure DisminuirNiveles (var Arbol:MeArbol;Raiz:tPosArbol);
Function CantidadNiveles (Arbol:MeArbol):Integer;
Function FactorEquilibrio (Arbol:MeArbol;PosNodo:tPosArbol):Integer;
Procedure CasoDeDesequilibrio (Arbol:MeArbol;PosNodo:tPosArbol);

//ARCHIVOS (JUGADORES)//////////////////////////////////
Procedure CrearMe_Archivos(var me:MeArchivos;Nombre_Archivo_Control,
                                  Nombre_Archivo_Datos: string);
Procedure AbrirMe_Archivos(var me:MeArchivos);
Procedure CerrarMe_Archivos(var me:MeArchivos);
Procedure InsertarInfoMe_Archivos(Var me:MeArchivos; pos:tPosArchi;
                                                                  reg:tregdatos);
Procedure EliminarInfoMe_Archivos(var me:MeArchivos; pos:tPosArchi);
Procedure ModificarInfoMe_Archivos(var me:MeArchivos;pos:tPosArchi;
                                                                  reg:tregdatos);
Procedure ObtenerInfoMe_Archivos(var me:MeArchivos;pos:tPosArchi;
                                                              var reg:tregdatos);
Procedure EliminarRepetidos_Archivos(var me:MeArchivos);
Function  Primero_Archivos (var me:MeArchivos):tPosArchi;
Function  Ultimo_Archivos (var me:MeArchivos):tPosArchi;
Function  Proximo_Archivos(var me:MeArchivos; pos:tPosArchi):tPosArchi;
Function  Anterior_Archivos(var me:MeArchivos; pos:tPosArchi):tPosArchi;
Function  BuscarInfoMe_Archivos(var me:MeArchivos;clave:tClaveArchi;
                                                      var pos:tPosArchi):boolean;
Function  MeVacio_Archivos(var me:MeArchivos):boolean;
Function  MeLleno_Archivos(var me:MeArchivos):boolean;
Function  PosNula_Archivos(var me:MeArchivos):tPosArchi;
Function  ClaveNula_Archivos(var me:MeArchivos):tClaveArchi;
Function ObtenerUltimoID_Archivos(var me:MeArchivos):tidusuario;
Function ObtenerProximoID_Archivos(var me:MeArchivos):tidusuario;

implementation

Procedure CrearMe_Indice(var Arbol:MeArbol;
                              Nombre_Archivo_Control, Nombre_Archivo_Datos: string);
var
    RC:tControlArbol;
    ioD,ioC:integer;
begin
  assign(Arbol.D, 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\' + Nombre_Archivo_Datos);
  assign(Arbol.C,'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\' + Nombre_Archivo_Control);
  {$I-}
  reset(Arbol.D); ioD:=IoResult;
  reset(Arbol.C); ioC:=IoResult;
  if (IoD<>0) or (IoC<>0) then
    begin
      Rewrite(Arbol.D);
      ReWrite(Arbol.C);
      RC.raiz:=_posnula_arbol;
      RC.cantidad:=0;
      RC.cant_niveles:=0;
      RC.borrados:=_posnula_arbol;
      Write(Arbol.C,rc);
    end;
  Close(Arbol.D);
  Close(Arbol.C);
  {$I+}
end;

procedure AbrirMe_Indice(var arbol: MeArbol);
begin
  Reset(arbol.c);
  Reset(arbol.d);

end;

procedure CerrarMe_indice(var arbol: MeArbol);
begin
    if IOResult <> 0 then   //no se si esto esta bien
   begin
    Close(arbol.c);
    Close(arbol.d);
  end;


end;

Procedure InsertarNodo_Indice(var Arbol:MeArbol; var nodo:tNodoIndice;
                                                                pos:tPosArchi );
var //El pos que entra es la posicion fisica de su padre...
	posnueva:tPosArbol;
	reg,rd:tNodoIndice;
	RC:tControlArbol;
begin
  seek(Arbol.C,0);
  read(Arbol.C,RC);
  if RC.borrados=_posnula_arbol then
  begin
    posnueva:=filesize(Arbol.D);
	end
  else
   begin
     Posnueva:=RC.Borrados;
     seek(arbol.D,posnueva);
     read(arbol.D,rD);
     RC.Borrados:=rD.hi;
	end;

   if (RC.Raiz=_posnula_arbol) then//Arbol vacio
   begin
		nodo.padre:=_posnula_arbol;
		nodo.hi:=_posnula_arbol;
	  nodo.hd:=_posnula_arbol;
    nodo.nivel:=1;
	  RC.Raiz:=posnueva;
   end
   else //Hoja
   begin
		seek(Arbol.D,pos);
    read(Arbol.D,reg);
  	nodo.padre:= pos;
	  nodo.hd:= _posnula_arbol;
		nodo.hi:= _posnula_arbol;
    nodo.nivel:=Reg.Nivel+1;
    if (nodo.clave<=reg.clave) then
		begin
			reg.hi:=posnueva;
		end
		else
		begin
      reg.hd:=posnueva;
		end;
    seek(Arbol.d,pos); write(Arbol.d,reg);
    end;

    If Nodo.nivel > RC.cant_niveles then
      RC.cant_niveles := Nodo.nivel;
		rc.cantidad:=rc.cantidad+1;
		seek(Arbol.d,posnueva); write(Arbol.d,nodo); //se escribe el elemento en el archivo
		seek(Arbol.c,0); write(Arbol.c,rc);	// se actualiza el registro control

end;

Procedure EliminarNodo_Indice(var Arbol:MeArbol; pos:tPosArbol);
var
	RD:tNodoIndice;
	RC:tControlArbol;
  rAux,RHD,RDP,RHI:tNodoIndice;
  posAux:tPosArbol;

begin
	seek(Arbol.c,0); read(Arbol.c,rc);
	seek(Arbol.d,pos); read(Arbol.d,rd);
	if (pos=rc.raiz) and (rd.hi=_posnula_arbol) and (rd.hd=_posnula_arbol) then
	begin
		Rc.Raiz:=_posnula_arbol;
	end
	else
	begin
		if (rd.hi=_posnula_arbol) and (rd.hd=_posnula_arbol) then //eliminar de una hoja
		begin
			Seek(Arbol.D,rd.padre);read(arbol.d,rdp);
      If rdp.hi=pos then
        rdp.hi:=_posnula_arbol
        else
        rdp.hd:=_posnula_arbol;
		  Seek(Arbol.d,rd.padre);write(arbol.d,RDP);
    end
		else
		begin
			if (rd.hi <> _posnula_arbol) and (rd.hd <> _posnula_arbol) then //Caso general
			begin
        If pos<>RC.raiz then
        begin
          Seek(arbol.d,rd.padre);read(arbol.d,rdp);
          If rdp.hi=pos then
            rdp.hi:=rd.hd
          else
            rdp.hd:=rd.hd;
          Seek(Arbol.d,RD.padre);Write(Arbol.d,rdp);
        end
        else
          RC.raiz:=rd.hd;

        Seek(Arbol.d,rd.hd);read(arbol.d,RHD);
        RHD.padre:=RD.padre;
        posAux:=RD.hd;
        rAux:=RHD;
        While rAux.hi<>_posnula_arbol do
        begin
          Seek(arbol.d,posAux);read(arbol.d,RAux);
         If raux.hi<>_posnula_arbol then
          posaux:=rAux.hi;
        end;
        Seek(Arbol.d,RD.hi);Read(Arbol.d,RHI);
        RHI.padre:=posAux;
        RAux.hi:=RD.hi;
        Seek(Arbol.d,RD.hi);Write(Arbol.d,RHI);
        Seek(Arbol.d,posAux);Write(Arbol.d,raux);
        If posAux<>RD.hd then
        begin
         Seek(Arbol.d,RD.hd);Write(Arbol.d,RHD);
        end;
 			end
      else
			begin
        If pos<>RC.Raiz then
        begin
          Seek(arbol.D,RD.padre);Read(arbol.D,RDP);
          If RDP.hi=pos then
           begin
             If RD.hi=_posnula_arbol then
             begin
              Rdp.hi:=RD.hd;
              Seek(arbol.D,RD.hd);read(arbol.d,RHD);
              RHD.padre:=RD.padre;
              Seek(arbol.d,RD.hd);write(arbol.d,RHD);
             end
             else
              begin
                Rdp.hi:=RD.hi;
                Seek(arbol.D,RD.hi);read(arbol.d,RHI);
                RHI.padre:=RD.padre;
                Seek(arbol.d,RD.hi);write(arbol.d,RHI);
              end
           end
           else
             If RD.hi=_posnula_arbol then
              begin
                Rdp.hd:=RD.hd;
                Seek(arbol.D,RD.hd);read(arbol.d,RHD);
                RHD.padre:=RD.padre;
                Seek(arbol.d,RD.hd);write(arbol.d,RHD);
              end
              else
               begin
                Rdp.hd:=RD.hi;
                Seek(arbol.D,RD.hi);read(arbol.d,RHI);
                RHI.padre:=RD.padre;
                Seek(arbol.d,RD.hi);write(arbol.d,RHI);
               end;
          Seek(arbol.d,rd.padre);write(arbol.d,rdp);
        end
        else
            If RD.hi=_posnula_arbol then
              RC.Raiz:=RD.hd
             else
               RC.raiz:=RD.hi;
			end;
		end;
	end;
  RD.hi:=RC.borrados;
  RD.hd:=RC.borrados;
	RC.borrados:=pos;
  RC.Cantidad:=RC.Cantidad-1;
  Seek(arbol.c,0);write(arbol.c,rc);
end;

Procedure ModificarInfoMe_Indice(var Arbol:MeArbol;Pos:tPosArbol;Nodo:tNodoIndice);
begin
  seek(Arbol.d,pos);
  write(Arbol.d,Nodo);
end;

function Cantidad_Indice(var arbol:MeArbol):integer;
var
  Rc:tControlArbol;
begin
  seek(arbol.C,0);
  read(arbol.c,Rc);
  Cantidad_Indice:=Rc.Cantidad;
end;

Function  ArbolVacio_Indice(Arbol:MeArbol):boolean;
var
RC:tControlArbol;
begin
Seek(Arbol.C,0);
Read(Arbol.C,RC);
  If RC.Raiz= _posnula_arbol then
    ArbolVacio_Indice:=true else ArbolVacio_Indice:=false;
end;

Function  Raiz_Indice(var Arbol:MeArbol):tPosArbol;
var
   RC:tControlArbol;
begin
   seek(Arbol.C,0);
   read(Arbol.C,RC);
   Raiz_Indice:=RC.Raiz;
end;

Function  Anterior_Indice(var Arbol:MeArbol; pos:tPosArbol):tPosArbol;
var
   RD:tNodoIndice;
begin
   seek(Arbol.D,pos);read(Arbol.D,RD);
   Anterior_Indice:=RD.Padre;
end;

Function  ProximoIzq_Indice(Arbol:MeArbol; pos:tPosArbol):tPosArbol;
var
   RD:tNodoIndice;
begin
   seek(Arbol.D,pos);read(Arbol.D,RD);
   ProximoIzq_Indice:=RD.hi;
end;

Function  ProximoDer_Indice(var Arbol:MeArbol; pos:tPosArbol):tPosArbol;
var
   RD:tNodoIndice;
begin
   seek(Arbol.D,pos);read(Arbol.D,RD);
   ProximoDer_Indice:=RD.hd;
end;

Function  ObtenerInfo_Indice(var Arbol:MeArbol; pos: tPosArbol):tNodoIndice;
var
  rd:tNodoIndice;
begin
  seek(Arbol.D,pos);
  read(Arbol.D,rd);
  ObtenerInfo_Indice:=rd;
end;

Function  BuscarNodo_Indice (var Arbol:MeArbol; clave:tClaveArbol;
                                  var pos:tPosArbol):boolean; //Buscar iterativo
var
	reg:tNodoIndice;
	RC:tControlArbol;
	encont:boolean;
	posPadre:tposArbol;
begin
	seek(Arbol.c,0); read(Arbol.c,rc);
	pos:=rc.raiz; encont:=false;
	posPadre:=_posnula_arbol;
	while (not encont) and (pos<>_posnula_arbol) do
	begin
		seek(Arbol.d,pos); read(Arbol.d,reg);
		if (clave=reg.clave) then
		begin
			encont:=true;
		end
		else
		begin
			if (reg.clave>clave) then
			begin
				posPadre:=pos;
				pos:=reg.hi;
			end
			else
			begin
				posPadre:=pos;
				pos:=reg.hd;
			end;
		end;
	end;
	if (not encont) then
	begin
		pos:=posPadre;
	end;
	BuscarNodo_Indice:=encont;
end;

Function  PosNula_Indice(arbol:MeArbol):tPosArbol;
begin
  PosNula_Indice:=_posnula_arbol;
end;

Procedure DisminuirNiveles (var Arbol:MeArbol;Raiz:tPosArbol);
var
N:tNodoIndice;
begin
  If raiz =PosNula_Indice (Arbol) then exit;
  //Primero recursivo tendiendo a la Izquierda
  DisminuirNiveles (Arbol,ProximoIzq_Indice(Arbol,Raiz));
    N:=ObtenerInfo_Indice (Arbol,Raiz);
    N.nivel:=N.nivel-1;
    Seek (Arbol.D,Raiz); Write(Arbol.D,N);
  //Recursividad tendiendo a la Derecha.
  DisminuirNiveles (Arbol,ProximoDer_Indice(Arbol,Raiz));
end;
{******************************************************************************}
Procedure AumentarNiveles (var Arbol:MeArbol;Raiz:tPosArbol);
var
N:tNodoIndice;
begin
  If raiz =PosNula_Indice (Arbol) then exit;
  //Primero recursivo tendiendo a la Izquierda
  DisminuirNiveles (Arbol,ProximoIzq_Indice(Arbol,Raiz));
    N:=ObtenerInfo_Indice (Arbol,Raiz);
    N.nivel:=N.nivel+1;
    Seek (Arbol.D,Raiz); Write(Arbol.D,N);
  //Recursividad tendiendo a la Derecha.
  DisminuirNiveles (Arbol,ProximoDer_Indice(Arbol,Raiz));
end;
{******************************************************************************}
Procedure RightRight (var Arbol:MeArbol;PosNodo:tPosArbol);
Var
  NodoArriba,NodoAbajo,NodoAnterior:tNodoIndice;
  RC:tControlArbol;
  PosAux:tPosArbol;
begin

  Seek (Arbol.D,PosNodo); Read (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.hd); Read (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Read(Arbol.C,RC);

  {Cambio enlaces}
  PosAux:=NodoAbajo.hi;
  NodoAbajo.padre:=NodoArriba.padre;
  NodoAbajo.hi:=PosNodo;
  NodoArriba.padre:=NodoArriba.hd;
  NodoArriba.hd := PosAux; ;

  {Es necesario cambiar al nodo anterior?}
  {********************************}
  If NodoAbajo.padre <> _posnula_arbol then
  begin
    Seek (Arbol.D,NodoAbajo.padre); Read (Arbol.D,NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd :=NodoArriba.padre
    Else
      NodoAnterior.hi :=NodoArriba.padre;
    Seek (Arbol.D,NodoAbajo.padre); Write (Arbol.D,NodoAnterior);
  end;
  {********************************}

  {Cambio el campo nivel}
  NodoAbajo.nivel:=NodoAbajo.nivel-1;
  NodoArriba.nivel := NodoArriba.nivel+1;

  {Verifico que el del drama no haya sido la raiz}
  If PosNodo=RC.Raiz then
    RC.raiz := NodoArriba.padre;

  Seek (Arbol.D,PosNodo); Write (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.padre); Write (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Write(Arbol.C,RC);

  DisminuirNiveles (Arbol,NodoAbajo.hd);
  AumentarNiveles (Arbol,NodoArriba.hi);
end;
{******************************************************************************}
Procedure LeftLeft (var Arbol:MeArbol;PosNodo:tPosArbol);
Var
  NodoArriba,NodoAbajo,NodoAnterior:tNodoIndice;
  RC:tControlArbol;
  PosAux:tPosArbol;
begin

  Seek (Arbol.D,PosNodo); Read (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.hi); Read (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Read(Arbol.C,RC);

  {Cambio enlaces}
  PosAux:=NodoAbajo.hd;
  NodoAbajo.padre:=NodoArriba.padre;
  NodoAbajo.hd:=PosNodo;
  NodoArriba.padre:=NodoArriba.hi;
  NodoArriba.hi := PosAux; ;

  {Es necesario cambiar al nodo anterior?}
  {********************************}
  If NodoAbajo.padre <> _posnula_arbol then
  begin
    Seek (Arbol.D,NodoAbajo.padre); Read (Arbol.D,NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd :=NodoArriba.padre
    Else
      NodoAnterior.hi :=NodoArriba.padre;
    Seek (Arbol.D,NodoAbajo.padre); Write (Arbol.D,NodoAnterior);
  end;
  {********************************}

  {Cambio el campo nivel}
  NodoAbajo.nivel:=NodoAbajo.nivel-1;
  NodoArriba.nivel := NodoArriba.nivel+1;

  {Verifico que el del drama no haya sido la raiz}
  If PosNodo=RC.Raiz then
    RC.raiz := NodoArriba.padre;

  Seek (Arbol.D,PosNodo); Write (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.padre); Write (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Write(Arbol.C,RC);

  DisminuirNiveles (Arbol,NodoAbajo.hi);
  AumentarNiveles (Arbol,NodoArriba.hd);
end;

{******************************************************************************}
Procedure LeftRight (var Arbol:MeArbol;PosNodo:tPosArbol);
Var
  NodoArriba,NodoMedio,NodoAbajo,NodoAnterior:tNodoIndice;
  RC:tControlArbol;
  PosAux,PosMedio,PosAbajo:tPosArbol;
begin

  Seek (Arbol.D,PosNodo); Read (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.hi); Read (Arbol.D,NodoMedio);
  Seek (Arbol.D,NodoMedio.hd); Read (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Read(Arbol.C,RC);

  PosMedio:=NodoArriba.hi;
  PosAbajo:=NodoMedio.hd;
  PosAux:=NodoArriba.padre;

  NodoArriba.padre:=NodoMedio.hd ;
  NodoArriba.hi:=NodoAbajo.hd;

  NodoMedio.padre:=NodoMedio.hd;
  NodoMedio.hd:= NodoAbajo.hi;

  NodoAbajo.padre:=PosAux;
  NodoAbajo.hd:=PosNodo;
  NodoAbajo.hi:=PosMedio;

  If NodoAbajo.padre <> _posnula_arbol then
  begin
    Seek (Arbol.D,NodoAbajo.padre); Read (Arbol.D,NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd :=PosAbajo
    Else
      NodoAnterior.hi :=PosAbajo;
    Seek (Arbol.D,NodoAbajo.padre); Write (Arbol.D,NodoAnterior);
  end;
  {Cambio el campo nivel}
  NodoAbajo.nivel:=NodoAbajo.nivel-2;
  NodoArriba.nivel:= NodoArriba.nivel+1;

  {Verifico que el del drama no haya sido la raiz}
  If PosNodo=RC.Raiz then
    RC.raiz := NodoArriba.padre;

  Seek (Arbol.D,PosNodo); write (Arbol.D,NodoArriba);
  Seek (Arbol.D,PosMedio); write (Arbol.D,NodoMedio);
  Seek (Arbol.D,PosAbajo); write (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Write (Arbol.C,RC);

  DisminuirNiveles (Arbol,NodoArriba.hi);
  AumentarNiveles (Arbol, NodoArriba.hd);
  DisminuirNiveles (Arbol,NodoMedio.hd);

end;
{******************************************************************************}
Procedure RightLeft (var Arbol:MeArbol;PosNodo:tPosArbol);
Var
  NodoArriba,NodoMedio,NodoAbajo,NodoAnterior:tNodoIndice;
  RC:tControlArbol;
  PosAux,PosMedio,PosAbajo:tPosArbol;
begin

  Seek (Arbol.D,PosNodo); Read (Arbol.D,NodoArriba);
  Seek (Arbol.D,NodoArriba.hd); Read (Arbol.D,NodoMedio);
  Seek (Arbol.D,NodoMedio.hi); Read (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Read(Arbol.C,RC);

  PosMedio:=NodoArriba.hd;
  PosAbajo:=NodoMedio.hi;
  PosAux:=NodoArriba.padre;

  NodoArriba.padre:=NodoMedio.hi;
  NodoArriba.hd:=NodoAbajo.hi;

  NodoMedio.padre:=NodoMedio.hi;
  NodoMedio.hi:= NodoAbajo.hd;

  NodoAbajo.padre:=PosAux;
  NodoAbajo.hi:=PosNodo;
  NodoAbajo.hd:=PosMedio;

  If NodoAbajo.padre <> _posnula_arbol then
  begin
    Seek (Arbol.D,NodoAbajo.padre); Read (Arbol.D,NodoAnterior);
    If NodoAnterior.hd = PosNodo then
      NodoAnterior.hd :=PosAbajo
    Else
      NodoAnterior.hi :=PosAbajo;
    Seek (Arbol.D,NodoAbajo.padre); Write (Arbol.D,NodoAnterior);
  end;
  {Cambio el campo nivel}
  NodoAbajo.nivel:=NodoAbajo.nivel-2;
  NodoArriba.nivel:= NodoArriba.nivel+1;

  {Verifico que el del drama no haya sido la raiz}
  If PosNodo=RC.Raiz then
    RC.raiz := NodoArriba.padre;

  Seek (Arbol.D,PosNodo); write (Arbol.D,NodoArriba);
  Seek (Arbol.D,PosMedio); write (Arbol.D,NodoMedio);
  Seek (Arbol.D,PosAbajo); write (Arbol.D,NodoAbajo);
  Seek (Arbol.C,0);Write (Arbol.C,RC);

  DisminuirNiveles (Arbol,NodoArriba.hd);
  AumentarNiveles (Arbol, NodoArriba.hi);
  DisminuirNiveles (Arbol,NodoMedio.hi);

end;
{******************************************************************************}
Procedure AVL_Indice (Arbol:MeArbol; Raiz: tPosArbol;
                                     var PosNodo: tPosArbol;Var Balance:Boolean);
{Indica si el Arbol DNI esta balanceado. Si no lo esta me envia la pos del nodo
que esta causando el desequilibrio. Este siempre es el nodo de mas ALTO nivel.
La idea es ir balanceandolo de los nodos mas pesados hasta llegar a la raiz.}
var
  Result:Integer;
begin
  //Si lo que entra es posNula sale.
  If (raiz =PosNula_Indice (Arbol)) then exit;
  //Recursivo tendiendo a la Izquierda
  AVL_Indice (Arbol,ProximoIzq_Indice(Arbol,Raiz),posNodo,Balance);
  //Recursivo tendiendo a la derecha
  AVL_Indice (Arbol,ProximoDer_Indice(Arbol,Raiz),PosNodo,Balance);

  Result:=FactorEquilibrio (Arbol,Raiz);

  If Result<0 then
    Result:=Result*(-1);

  {Cuando conoce la posicion del nodo en desequilibrio no lo cambia}
  If (Result>1) then
    Balance:=False;

  If (posNodo=PosNula_Indice (Arbol)) and (not Balance)then
    posNodo:=Raiz;
end;
{******************************************************************************}
Function FactorEquilibrio (Arbol:MeArbol;PosNodo:tPosArbol):Integer;
var
  N:tNodoIndice;
  Ti,Td:Integer;
begin
  If PosNodo = -1 then
    FactorEquilibrio:=0
  Else
  begin
    //Guardo en N el nodo indice.
    N:=ObtenerInfo_Indice (Arbol,PosNodo);

    //Calculo la profundidad de ambos hijos.
    If N.hi <>PosNula_Indice (Arbol) then
      Ti:=ProfundidadNodo(Arbol,N.hi)
    Else
      Ti:=0;
    If N.hd <>PosNula_Indice (Arbol) then
      Td:=ProfundidadNodo(Arbol,N.hd)
    Else
      Td:=0;

    {-->AVL es cuando de todo nodo |Altura(Ti)-Altura(Td)|<=1.
    --->Ti y Td son los subarboles de un nodo.
    --> Aca Ti y Td contienen la Altura de dicho subarbol.}
    FactorEquilibrio:=Ti-Td;
  end;
end;
{******************************************************************************}
Procedure CasoDeDesequilibrio (Arbol:MeArbol;PosNodo:tPosArbol);
var
  N:tNodoIndice;
begin

  N:=ObtenerInfo_Indice (Arbol,PosNodo);
  {Si el factor de desequilibrio es Positivo
  significa que hay que revisar el lado izquierdo}
  If FactorEquilibrio (Arbol,PosNodo)>=0 then
  begin
    If FactorEquilibrio (Arbol,N.hi)>=0 then
      LeftLeft(Arbol,PosNodo)
    Else
      LeftRight(Arbol,PosNodo);
  end
  Else
  begin
    If FactorEquilibrio (Arbol,N.hd)>=0 then
      RightLeft(Arbol,PosNodo)
    Else
      RightRight(Arbol,PosNodo);
  end;

end;
{******************************************************************************}
Function ProfundidadNodo (Arbol:MeArbol; Raiz: tPosArbol):Integer;
var
Nodo:tNodoIndice;
Profundidad:Integer;
{Procedimiento interno.........................................................}
  Procedure ProfundidadArbol (Arbol:MeArbol; Raiz: tPosArbol; var Prof:Integer);
  var
    N:tNodoIndice;
  begin
    If raiz =PosNula_Indice (Arbol) then exit;
    //Primero recursivo tendiendo a la Izquierda
    ProfundidadArbol (Arbol,ProximoIzq_Indice(Arbol,Raiz),Prof);
    //Recursividad tendiendo a la Derecha.
    ProfundidadArbol (Arbol,ProximoDer_Indice(Arbol,Raiz),prof);


     //Guardo en N el nodo indice.
    N:=ObtenerInfo_Indice (Arbol,Raiz);

    If N.nivel >  Prof then
      Prof:=N.nivel;
  end;
  {............................................................................}
Begin
  Profundidad:=0;
  Nodo:=ObtenerInfo_Indice (Arbol,Raiz);
  ProfundidadArbol (Arbol,Raiz,Profundidad);
  ProfundidadNodo:=(Profundidad-Nodo.nivel)+1;
End;
{******************************************************************************}
Function CantidadNiveles (Arbol:MeArbol):Integer;
var
  RC:tControlArbol;
begin
  Seek (Arbol.C,0);Read (Arbol.C,RC);
  CantidadNiveles:=RC.cant_niveles;
end;


//ARCHIVOS /////////////////////////////////////////////////////////////////////
Procedure CrearMe_Archivos(var me:MeArchivos;
                    Nombre_Archivo_Control, Nombre_Archivo_Datos: string);
Var
 Rc:tRegControl;
Begin
  assign(Me.D, 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\' + Nombre_Archivo_Datos);
  assign(ME.C, 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\'  + Nombre_Archivo_Control);
  {$I-}
     Reset(Me.D);
     If IoResult<>0
     then
       rewrite(me.D);
     Reset(me.C);
     If Ioresult<>0
     then
       begin
         ReWrite(me.c);
         rc.ultimoIDinterno:= '0';
         Rc.ultimo:=_posnula_archivo;
         Write(me.c,rc);
       end;
     close(me.c);
     close(me.d);
  {$I+}
end;
{******************************************************************************}
Procedure AbrirMe_Archivos(var me:MeArchivos);
Begin
  reset(Me.D);
  reset(me.C);
end;
{******************************************************************************}
Procedure CerrarMe_Archivos(var me:MeArchivos);
Begin


   if IOResult <> 0 then
   begin
   close(me.D);
   close(me.C);

  end;
end;

function IsOpen(const txt:textFile):Boolean;
const
  fmTextOpenRead = 55217;
  fmTextOpenWrite = 55218;
begin
  Result := (TTextRec(txt).Mode = fmTextOpenRead) or (TTextRec(txt).Mode = fmTextOpenWrite)
end;

function IsFileInUse(fName: string) : boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(fName) then begin
    Exit;
  end;

  HFileRes := CreateFile(PChar(fName)
    ,GENERIC_READ or GENERIC_WRITE
    ,0
    ,nil
    ,OPEN_EXISTING
    ,FILE_ATTRIBUTE_NORMAL
    ,0);

  Result := (HFileRes = INVALID_HANDLE_VALUE);

  if not(Result) then begin
    CloseHandle(HFileRes);
  end;
end;
{******************************************************************************}
Function Primero_Archivos (var me:MeArchivos):TPosArchi;
var
 Rc:Tregcontrol;
begin
   Seek(Me.C,0);
   read(me.c,rc);
   If rc.ultimo=_posnula_archivo then
     Primero_Archivos:=_posnula_archivo
   else
     Primero_Archivos:=0;
end;
{******************************************************************************}
Function Ultimo_Archivos(Var me:MeArchivos):tposArchi;
var
 rc:tregcontrol;
Begin
   Seek(Me.C,0);
   read(me.c,rc);
   Ultimo_Archivos:=rc.ultimo;
end;
{******************************************************************************}
Function Proximo_Archivos(var me:MeArchivos; pos:tposArchi):tposArchi;
var
  rc:tregcontrol;
begin
   Seek(Me.C,0);
   read(me.c,rc);
   If pos<> rc.ultimo
   then
     Proximo_Archivos:=pos+1
   else
     Proximo_Archivos:=_posnula_archivo;
end;
{******************************************************************************}
Function Anterior_Archivos(var me:MeArchivos; pos:tposArchi):tposArchi;
var
  rc:tregcontrol;
begin
   Seek(Me.C,0);
   read(me.c,rc);
   If pos<>0
   then
      Anterior_Archivos:=pos-1
   else
      Anterior_Archivos:=_posnula_archivo;
end;
{******************************************************************************}
Procedure InsertarInfoMe_Archivos(Var me:MeArchivos; pos:tposArchi;
                                                                  reg:tregdatos);
Var
  Rc:tregcontrol;
  aux:tregdatos;
  i:tposArchi;
begin
   Seek(Me.C,0);
   read(me.c,rc);

   for i:=rc.ultimo downto Pos do
    begin
      seek(me.D,i);
      read(me.d,aux);
      seek(me.D,i+1);
      write(Me.d,aux);
    end;

   seek(me.D,pos);
   write(me.d,reg);
   rc.ultimo:=rc.ultimo+1;
   rc.ultimoIDinterno:= reg.clave;//inttostr(strtoint(rc.ultimoIDinterno)+1);
   Seek(Me.C,0);
   write(me.c,rc);
end;
{******************************************************************************}
Procedure EliminarInfoMe_Archivos(var me: MeArchivos; pos:tposArchi);
var
 Rc: Tregcontrol;
 aux:tregdatos;
 i:tposArchi;
Begin
   Seek(Me.C,0);
   read(me.c,rc);

   for i:=pos+1 to rc.ultimo do
     begin
       seek(me.d,i);
       read(me.d,aux);
       seek(me.d,i-1);
       write(me.d,aux);
     end;

   Rc.ultimo:=rc.ultimo-1;
   Seek(Me.C,0);
   write(me.c,rc);
end;
{******************************************************************************}
Function  BuscarInfoMe_Archivos(var me:MeArchivos;clave:tClaveArchi;
                                                    var pos:tPosArchi):boolean;
//busca en el archivo por la clave. Si encuentra devuelve la pos donde esta, dependiendo si esta vacio o no
//la ultima posicion+1 o la posicion 0
Var
  Rc:tregcontrol;
  Rd:tregdatos;
  Encont:boolean;
  i,f,m:tposArchi;
Begin
   Seek(Me.C,0);
   Read(Me.c,Rc);
   i:=0;
   f:=Rc.ultimo;
   Encont:=False;

   While(i<=f)and (not encont) do
    begin
        m:=(i+f)div 2;
        seek(me.D,m);
        read(me.d,rd);
        If rd.clave=clave
        then
          encont:=false
        else
          If clave<rd.clave
          then
            f:=m-1
          else
           i:=m+1;
   end;

  BuscarInfoMe_Archivos:=Encont;
  If encont then
    pos:=m
  else
    If Rc.ultimo=-1 then
        pos:=0
    Else
      pos:=Rc.ultimo+1;
end;
{******************************************************************************}
Function Mevacio_Archivos(var me:MeArchivos):boolean;
Var
 Rc:tregcontrol;
Begin
  seek(me.C,0);
  read(me.c,rc);
  Mevacio_Archivos:=(rc.ultimo=_posnula_archivo);
end;
{******************************************************************************}
Function MeLleno_Archivos(var me:MeArchivos):boolean;
begin
  MeLleno_Archivos:=false;
end;
{******************************************************************************}
Procedure ModificarInfoMe_Archivos(var me:MeArchivos;pos:tposArchi;
                                                                  reg:tregdatos);
begin
  seek(me.d,pos);
  write(me.d,reg);
end;
{******************************************************************************}
Procedure ObtenerInfoMe_Archivos(var me:MeArchivos;pos:tposArchi;
                                                              var reg:tregdatos);
begin
  seek(me.d,pos);
  read(me.d,reg);
end;
{******************************************************************************}
Function PosNula_Archivos(var me:MeArchivos):tposArchi;
begin
  PosNula_Archivos:=_posnula_archivo;
end;
{******************************************************************************}
Function  ClaveNula_Archivos(var me:MeArchivos):tClaveArchi;
Begin
    ClaveNula_Archivos:=_clave_nula_archivo;
end;
{******************************************************************************}
Procedure EliminarRepetidos_Archivos(var me:MeArchivos);
Var
 rc:tregcontrol;
 aux,r1,r2:tregdatos;
 i,pos1,pos2:tposArchi;
Begin
  seek(me.C,0);
  read(me.c,rc);
  pos1:=0;

  While pos1<rc.ultimo do
   begin
     pos2:=pos1+1;
     seek(me.D,pos1);
     read(me.d,r1);
     seek(me.d,pos2);
     read(me.d,r2);
     if r1.clave=r2.clave
     then
       begin
         for i:=pos2 to rc.ultimo do
          begin
            seek(me.d,i);
            read(me.d,aux);
            seek(me.D,i-1);
            write(me.d,aux);
          end;
       end
     else
       pos1:=pos2
   end;
  seek(me.C,0);
  write(me.c,rc);
end;

Function ObtenerUltimoID_Archivos(var me:MeArchivos):tidusuario;
var
  rc:tregcontrol;
begin
   seek(me.C,0);
   read(me.c,rc);
   result:= rc.ultimoIDinterno;
end;

Function ObtenerProximoID_Archivos(var me:MeArchivos):tidusuario;
var
  rc:tregcontrol;
begin
   seek(me.C,0);
   read(me.c,rc);
   result:= inttostr(strtoint(rc.ultimoIDinterno)+1);
end;

end.
