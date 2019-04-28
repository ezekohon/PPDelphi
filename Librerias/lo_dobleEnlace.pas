unit lo_dobleEnlace;    //CARTONES

interface

uses SysUtils, math;

const
     _posnula = -1;
    _ARCHIVO_DATOS = 'CARTONES.DAT';
    _ARCHIVO_CONTROL = 'CARTONES.CON';
    carpeta='D:\';
   _RUTA= 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\';

type
    tPos = _posnula..maxint;
    tcantidad= longint;
    tcadena = String[40];
    numeroMatriz = 0..75;

    tRegCampoMatriz = record
      numero :  numeroMatriz;
      tachado : boolean;
    end;

    tMatriz = Array[0..4, 0..4] of tRegCampoMatriz;

    tRegControl_DE = record
      ultimoIdInterno: LongInt; //se autoincrementa(? inicial en 0
      idJuego: String[10];  //de juegos.dat (lo_hashabierto)
      primero,ultimo:  tPos;
      borrado: tPos;
      cantidad: integer;
    end;

    tRegDatos_DE = record
        idCarton : longInt; //lo genera a partir del ultimoIdInterno
        idJugador : string[10]; //de jugadores.dat(lo_arbolbinario)
        grilla : tMatriz;
        ant,sig : tPos;
    end;

    archivoControl= File of tRegControl_DE;
    archivoDatos= File of tRegDatos_DE;


    MeDobleEnlace= record
            c:archivoControl;
            d:archivoDatos;
          end;

var
    MeCartones: MeDobleEnlace;

Procedure CrearMe (var me:MeDobleEnlace);
Function MeVacio (me: MeDobleEnlace):boolean;
procedure AbrirMe (var me:MeDobleEnlace);
Procedure Cerrarme (var me: MeDobleEnlace);
Function Primero (var me:MeDobleEnlace): tPos;
Function Ultimo (var me:MeDobleEnlace): tPos;
Function Borrados (var me:MeDobleEnlace; var pos:tPos):boolean;
Function Cantidad (var me:MeDobleEnlace): tcantidad;
Function Anterior (var me:MeDobleEnlace; pos:tPos): tPos;
Function Proximo (var me:MeDobleEnlace; pos:tPos): tPos;
function CapturarInfo (var me:MeDobleEnlace; pos:tPos): tRegDatos_DE;
Procedure InsertarInfo (Var Me:MeDobleEnlace; Reg:tRegDatos_DE; Pos:tPos);
Function Buscar (var me:MeDobleEnlace; idCarton:integer; var pos:tPos):boolean; {devuelve pos solo si encuentra al elemento}
Procedure Eliminar (Var Me:MeDobleEnlace; Pos:tPos);
Procedure Modificar (var me:MeDobleEnlace; pos:tPos; reg:tRegDatos_DE);
/////////////////////////////////////////////////////////////NUEVOS
Function LeerRegControl(var me:MeDobleEnlace;pos:tPos):tRegControl_DE;
Function LeerRegDatos(var me:MeDobleEnlace;pos:tPos):tRegDatos_DE;
Procedure ModSig(var reg:tRegDatos_DE; sig:tPos);
Procedure ModAnt(var reg:tRegDatos_DE; ant:tPos);
Procedure ModPrim(var me:MeDobleEnlace;pos:tPos);
Procedure ModUlt (var me:MeDobleEnlace;pos:tPos);
Function RecuperaridCarton(reg:tRegDatos_DE):integer;
Function RecuperarAnt (reg:tRegDatos_DE):tPos;
Function RecuperarSig (reg:tRegDatos_DE):tPos;
Function RecuperarBorrado (var me:MeDobleEnlace): tPos;
function BuscarInfo(var Me:MeDobleEnlace; Clave:integer;var Pos:tPos):Boolean; {devuelve la pos en la que deberia ir}
Function ObtenerProximoIDInterno(var Me:MeDobleEnlace):LongInt;
////////////////////////////////////////////////////FIN NUEVOS
implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////
Procedure CrearMe (var me:MeDobleEnlace);
var
   rc:tRegControl_DE;
begin

      assign(me.d, _Ruta + _archivo_datos);
      assign(me.c ,_Ruta + _archivo_control);
      if (not FileExists(_Ruta + _archivo_datos)) or
      (not FileExists(_Ruta + _archivo_control)) then
            begin
                      Rewrite(me.d);
                      Rewrite(me.c);
                      rc.primero:= _posnula;
                      rc.ultimo:= _posnula;
                      rc.borrado:= _posnula;
                      rc.cantidad:= 0;
                      rc.ultimoIdInterno:= 0;
                      seek(me.c, 0);
                      write(me.c,rc);
             end
             else
                  begin
                       Reset(me.d);
                       Reset(me.c);
                   end;
       Close(me.d);
       Close(me.c);
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function MeVacio (me: MeDobleEnlace):boolean;
var
  rc:tRegControl_DE;
begin
    seek(me.c,filesize(me.c)-1);
    read(me.c,rc);
    result:= (rc.ultimo= _posnula);
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Procedure Abrirme (var me: MeDobleEnlace);
begin
     Reset (me.d);
     Reset (me.c);
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Procedure Cerrarme (var me: MeDobleEnlace);
begin
     CloseFile (me.d);
     CloseFile (me.c);
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Primero (var me:MeDobleEnlace): tPos;
var
   rc:tRegControl_DE;
begin
    seek (me.c,0);
    read (me.c,rc);
    result:= rc.primero;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Ultimo (var me:MeDobleEnlace): tPos;
var
   rc:tRegControl_DE;
begin
    seek (me.c,0);
    read (me.c,rc);
    result:= rc.Ultimo;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Borrados (var me:MeDobleEnlace; var pos:tPos):boolean;     {devuelve true y la posicion si hay borrados - si no devuelve -1 en pos y falso}
var
   rc: tRegControl_DE;
begin
     seek (me.c,0);
     read (me.c,rc);
     pos:= rc.borrado;
     if pos = _posnula then
      result:= false
     else
      result:= true;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Cantidad (var me:MeDobleEnlace): tcantidad;      {devuelve cantidad de elementos - si es PosNula, el archivo esta vacio}
var
   rc:tRegControl_DE;
begin
     seek (me.c,0);
     read (me.c,rc);
     result:= rc.cantidad;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Anterior (var me:MeDobleEnlace; pos:tPos): tPos;
var
   rc:tRegControl_DE;
   rd: tRegDatos_DE;
begin
     seek (me.c,0);
     read (me.c,rc);
     if (pos= _posnula) then
       result:= _posnula
     else
       begin
           seek (me.d,pos);
           read (me.d,rd);
           result:=rd.ant;
       end;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Proximo (var me:MeDobleEnlace; pos:tPos): tPos;
var
   rc:tRegControl_DE;
   rd: tRegDatos_DE;
begin
     seek (me.c,0);
     read (me.c,rc);
     if (pos= _posnula) then
       result:= _posnula
     else
       begin
           seek (me.d,pos);
           read (me.d,rd);
           result:=rd.sig;
       end;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
function CapturarInfo (var me:MeDobleEnlace; pos:tPos): tRegDatos_DE;
var
   rd:tRegDatos_DE;
begin
     seek(me.d,pos);
     read(me.d,rd);
     result:=rd;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Procedure InsertarInfo (Var Me:MeDobleEnlace; Reg:tRegDatos_DE; Pos:tPos);
Var RegControl:tRegControl_DE;
	  RegDatos,RegDatosAnt,actualizoant:tRegDatos_DE;
	  PosNueva:tPos;

Begin
	Seek(Me.C,0);
	Read(Me.C,RegControl);

	If (RegControl.borrado = _posnula)
		Then PosNueva:= FileSize(Me.D)
		Else Begin
				    PosNueva:= RegControl.Borrado;
				    Seek(Me.D,PosNueva);
				    Read(Me.D,RegDatos);
				    RegControl.Borrado:= RegDatos.Sig;
            {actualizo enlace del siguiente borrado a -1}
            if (regdatos.sig<>_posnula) then
            begin
              Seek(me.d,regdatos.sig);
              read (me.d,actualizoant);
              actualizoant.ant:=_posnula;
              seek (me.d,regdatos.sig);
              write (me.d,actualizoant);
            end;
			   End;

	If ((RegControl.Primero = _posnula) And (RegControl.Ultimo = _posnula))
		Then Begin
				    {Insertar al Principio. Esta vacio el ME}
            RegControl.Primero:= PosNueva;
				    RegControl.Ultimo:= PosNueva;
				    Reg.Sig:= _posnula;
            Reg.Ant:= _posnula;
			   End
		Else Begin
				    If (Pos = RegControl.Primero)
					    Then Begin
							        {Insertar al Principio}
							        Reg.Sig:= RegControl.Primero;
                      Reg.Ant:= _posnula;

                      Seek(Me.D,RegControl.Primero);
                      Read(Me.D,RegDatos);
                      RegDatos.Ant:= PosNueva;
                      Seek(Me.D,RegControl.Primero);
                      Write(Me.D,RegDatos);

							        RegControl.Primero:= PosNueva;
						       End
					    Else
							        If pos = _POSNULA//{(Pos <> RegControl.Ultimo)and}(pos<>-1)
								        Then
								         Begin
                                {Insertar al Final}
                                Seek(Me.D,RegControl.Ultimo);
										            Read(Me.D,RegDatos);
										            RegDatos.Sig:= PosNueva;
										            Seek(Me.D,RegControl.Ultimo);
										            Write(Me.D,RegDatos);

                                Reg.Ant:= RegControl.Ultimo;
                                Reg.Sig:= _posnula;
										            RegControl.Ultimo:= PosNueva;
									           End
                         else
                         begin

       {MIRAR}                  {Insertar al Medio}                                       {MIRAR}
                                {Leo el dato en la posicion donde debe ubicarse}
                                Seek(Me.D,Pos);
										            Read(Me.D,RegDatos);
                                Reg.Ant:=RegDatos.Ant;
                                RegDatos.Ant:=posNueva;
                                Seek(Me.D,pos);
                                Write(Me.D,RegDatos);
                                {Leo el dato ant donde debe ubicarse para cambiar su sig}
                                Seek(Me.D,Reg.Ant);
                                Read(Me.D,RegDatosAnt);
                                Reg.Sig:=RegDatosAnt.Sig;
                                RegDatosAnt.Sig:=posNueva;
                                Seek(Me.D,posnueva);
                                write(Me.D,Reg);
                                Seek(Me.D,Reg.Ant);
                                write(Me.D,RegDatosAnt);

                         end;
			   End;

	RegControl.Cantidad:= RegControl.Cantidad + 1;
  RegControl.ultimoIdInterno:= reg.idCarton;
	Seek(Me.C,0);
	Write(Me.C,RegControl);
	Seek(Me.D,PosNueva);
	Write(Me.D,Reg);
End;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Function Buscar (var me:MeDobleEnlace; idCarton:integer; var pos:tPos):boolean;
var
   rc: tRegControl_DE;
   reg: tRegDatos_DE ;
   posaux:tPos;
   siguiente: tPos;
   resultado:boolean;
begin
     seek (me.c,0);
     read (me.c,rc);
     siguiente:= rc.primero;
     posaux:=siguiente;
     resultado:=false;
     while (siguiente <> _posnula) and ( not resultado) do
      begin
           seek (me.d,siguiente);
           read (me.d,reg);
           if (idCarton= reg.idCarton) then
            begin
              resultado:=true;
              pos:=posaux;
            end
           else
             begin
              siguiente:= reg.sig;
              posaux:= reg.sig;
             end;
      end;
     result:= resultado;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////
Procedure Eliminar (Var Me:MeDobleEnlace; Pos:tPos);
Var
    RC: tRegControl_DE;
    RD, RDsig, RDant , RDborrados: tRegDatos_DE;
    posdelete: tPos;
    recuperaborrado: tPos;
Begin
	Seek(Me.C,0);
	Read(Me.C,RC);

  PosDelete:= RC.Primero;

	If (RC.Primero = RC.Ultimo)
		Then Begin
				    {Elimino la unica celula de la lista}
				    PosDelete:= Rc.Primero;
            Seek(Me.D,PosDelete);
            Read(Me.D,RD);
            recuperaborrado:= rc.borrado;
				    Rc.Primero:= _posnula;
				    Rc.Ultimo:= _posnula;
            rd.sig:=recuperaborrado;

			   End
		Else Begin
				    If (Pos = Rc.Primero) {Elimino la Primera celula}
					    Then Begin
                      PosDelete:= Rc.Primero;
							        Seek(Me.D,PosDelete);
							        Read(Me.D,RD);

                      Seek(Me.D,RD.Sig);
                      Read(Me.D,RDsig);
                      Rdsig.Ant:= _posnula;
                      Seek(Me.D,RD.Sig);
                      Write(Me.D,RDsig);

                      RC.Primero:= RD.Sig;

                      RD.Sig:= RC.Borrado;
                      RD.Ant:= _posnula;
						       End
                   else
                   if (pos= RC.Ultimo) then {elimino la ultima celula}
                      begin
                          posdelete:= RC.Ultimo;
                          Seek (ME.D,posdelete);
                          Read(ME.D,RD);
                          Seek (ME.D, RD.Ant);
                          Read (ME.D,RDant);
                          RDant.sig:= _posnula;
                          Seek (ME.D,RD.ant);
                          Write (ME.D,RDant);
                          RC.ultimo:= RD.Ant;
                          RD.sig:= RC.Borrado;
                          RD.ant:= _posnula;
                      end
                      else
                          begin   {elimino del medio}
                           posdelete:= pos;
                           seek (ME.D,posdelete);
                           read (ME.D,Rd);
                           seek (ME.D,RD.ant);
                           read (ME.D,RDant);
                           seek (ME.D, rd.sig);
                           read (ME.D, rdsig);
                           rdant.sig:= rd.sig;
                           rdsig.ant:= rd.ant;
                           seek (ME.D, rd.ant);
                           write (ME.D, rdant);
                           seek (ME.D, rd.sig);
                           write (ME.D, rdsig);
                           rd.sig:= rc.borrado;
                           rd.ant:=  _posnula;
                          end;
   			   End;
    If (Rc.Borrado <> _posnula)
    Then Begin
            Seek(ME.D,Rc.Borrado);
            Read(ME.D,rdborrados);
            rdborrados.Ant:= PosDelete;
            Seek(ME.D,Rc.Borrado);
            Write(ME.D,rdborrados);
         End;
  Rc.Borrado:= PosDelete;
  Rc.Cantidad:= Rc.Cantidad - 1;
  Seek(ME.d,PosDelete);
  Write(ME.d,rd);
 	Seek(Me.c,0);
	Write(Me.c,rc);
End;
///////////////////////////////////////////////////////////////////////////////
Procedure Modificar (var me:MeDobleEnlace; pos:tPos; reg:tRegDatos_DE);
begin
      seek(me.d,pos);
      write (me.d,reg);
end;
///////////////////////////////////////////////////////////////////////
Function LeerRegControl(var me:MeDobleEnlace;pos:tPos):tRegControl_DE;
var
   rc:tRegControl_DE;
begin
     seek(me.c,pos);
     read (me.c,rc);
     LeerRegControl:=rc;
end;
/////////////////////////////////////////////////
Function LeerRegDatos(var me:MeDobleEnlace;pos:tPos):tRegDatos_DE;
var
   rd:tRegDatos_DE;
begin
     seek(me.d,pos);
     read (me.d,rd);
     LeerRegDatos:= rd;
end;

/////////////////////////////////////////////////
Procedure ModSig(var reg:tRegDatos_DE; sig:tPos);
begin
     reg.sig:= sig;
end;
/////////////////////////////////////////////////
Procedure ModAnt(var reg:tRegDatos_DE; ant:tPos);
begin
     reg.ant:= ant;
end;
/////////////////////////////////////////////////
Procedure ModPrim(var me:MeDobleEnlace;pos:tPos);
var
   rc:tRegControl_DE  ;
begin
     seek(me.c,0);
     read (me.c,rc);
     rc.primero:= pos;
     seek(me.c,0);
     write (me.c,rc);
end;
/////////////////////////////////////////////////
Procedure ModUlt (var me:MeDobleEnlace;pos:tPos);
var
   rc:tRegControl_DE ;
begin
     seek(me.c,0);
     read (me.c,rc);
     rc.ultimo:= pos;
     seek(me.c,0);
     write (me.c,rc);
end;

/////////////////////////////////////////////////////////
Function RecuperaridCarton(reg:tRegDatos_DE):integer;
begin
    RecuperaridCarton:= reg.idCarton;
end;

/////////////////////////////////////////////////////////////
Function RecuperarAnt (reg:tRegDatos_DE):tPos;
begin
     RecuperarAnt:= reg.ant;
end;
/////////////////////////////////////////////////////////////
Function RecuperarSig (reg:tRegDatos_DE):tPos;
begin
     RecuperarSig:=reg.sig;
end;
/////////////////////////////////////////////////////////////
Function RecuperarBorrado (var me:MeDobleEnlace): tPos;
var
   rc:tRegControl_DE;
begin
     seek(me.c,0);
     read (me.c,rc);
     RecuperarBorrado:= rc.borrado;
end;
/////////////////////////////////////////////////////////////////
function BuscarInfo(var Me:MeDobleEnlace; Clave:integer;var Pos:tPos):Boolean;
var
  rc:tRegControl_DE;
  {PosAnt,p:TipoPosicion;}
  corte,encontre:Boolean;
  rd:tRegDatos_DE;
begin
     seek(Me.C, 0);
     Read(Me.C, RC);
     Pos:=rc.primero;
     Encontre:=False;
     Corte:=false;
     While (Not encontre) and (Not Corte) and (Pos <> _posnula) do
        begin
            seek(Me.D, Pos);
            Read(Me.d, RD);
            If RD.idCarton = Clave then
              encontre:=true
            else
              if RD.idCarton > clave then
                corte:=true
              else
                   pos:=RD.Sig;

        end;
     BuscarInfo:=Encontre;
end;
////////////////////////////////////////////////////////////
Function ObtenerProximoIDInterno(var Me:MeDobleEnlace):LongInt;
var
  rc:tRegControl_DE;
begin
   seek(me.C,0);
   read(me.c,rc);
   result:= rc.ultimoIDinterno+1;
end;

end.
