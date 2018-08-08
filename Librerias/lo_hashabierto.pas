unit lo_hashabierto;

interface

uses
  MATH;

const
  _CategMin='A';
  _maxHash = 40;
  _fila = 60;
  _posnula_hash = -1;
  _RUTA= 'C:\Users\Ezequiel\Google Drive\Juan23\PROG2\MIO\TrabajoFINAL\Archivos\';
  _cobertura_de_venta= 15;
  tEstadoJuego = ['N' ,'J','F'];

type
 //tCodHash = String [3]  ;
 nombreEventoHash = String[20];
 tID = integer;
 tPosHash= _posnula_hash.._maxHash;


 tRegDatosHash = record
    ID: tID;
    nombreEvento: nombreEventoHash;
    posBolillero: integer;
    fechaEvento: tDate;
    estado: tEstadoJuego; //N(no activado), J(jugando), F(finalizado)
    ValorVenta: real;
    TotalCartonesVendidos: 0..100;
    PorcentajePremioLinea: integer;
    PorcentajePremioDiagonal: integer;
    PorcentajePremioCruz: integer;
    PorcentajePremioCuadradoChico: integer;
    PorcentajePremioCuadradoGrande: integer;
    ocupado:Boolean;
    Ant,Prox:tPosHash;

    end;

 tRegControlHash =  record
  primero, ultimo:tPosHash;
  ultimoIDinterno:tID;
  total:integer;
  borrados:tPosHash;
end;

 Hash_Datos  = file of tRegDatosHash;
 Hash_Control= file of tRegControlHash;


 tMeHash= record
              H:Hash_Datos;
              C:Hash_Control;
            end;

Procedure AbrirMe_Hash(var MeHash:tMeHash);
  Procedure CerrarMe_Hash(var MeHash:tMeHash);
  Procedure CrearMe_HashAbierto(var MeHash:tMeHash;
                              Nombre_Archivo_Control, Nombre_Archivo_Datos:string;
                              Directory:string);

  Procedure InsertarHash(var MeHash:tMeHash; RDEntrante: tRegDatosHash;pos:tPosHash);

  Function HashVacio(MeHash:tMeHash):boolean;
  Function CantMaxima (MeHash: tMeHash): Integer;
  Function FuncionHash (k:integer):Integer; {Devuelve posicion hash. Utiliza ValorHash}
  Function ValorHash (Cod:nombreEventoHash):Integer;{Devuelve un num, no la pos hash} //usara nombre del evento
  Function BuscarHash(var MeHash:tMeHash; CodBuscado:nombreEventoHash;
                      var PosFisica:tPosHash):boolean;
  Function Total (MeHash: tMeHash): integer;
  Procedure CapturarInfoHash(MeHAsh:tMeHash; Pos: tPosHash; var RH: tRegDatosHash);
  Function Primero (MeHash:tMeHash):tPosHash;
  Function Ultimo (MeHash:tMeHash):tPosHash;
  Procedure CambiarSiguiente (MeHash: tMeHash; Sig:tPoshash);
  Function Proximo (MeHash:tMeHash; Pos: tPosHash):tposHash;
  Procedure EliminarHash (MeHash:tMeHash; Pos:tPosHash);
 
  Function HashLleno(MeHash:tMeHash):boolean;
  Procedure CambiarCabeceraInsercion (var MeHash:tMeHash;pos:tPosHash);

  var
  MeJuego:tMeHash;

implementation

Procedure EliminarHash (MeHash:tMeHash; Pos:tPosHash);
Var
  RH,RH_Anterior,RH_Proximo:tRegDatosHash;
  RC:tRegControlHash;
Begin
  {LEO REGISTRO A BORRAR Y EL DE CONTROL}
  Seek (MeHash.H,Pos); Read (MeHash.H,RH);
  Seek (MeHash.C,0); Read (MeHash.C,RC);

  {************************************}
  {MODIFICO LOS REG ANTERIOR Y PROXIMO ENLAZANDOLOS}
  If RH.Ant <> _posnula_hash then
  begin
    Seek (MeHash.H,RH.Ant); Read (MeHash.H,RH_Anterior);
    RH_Anterior.Prox := RH.Prox;
    Seek (MeHash.H,RH.Ant); Write (MeHash.H,RH_Anterior);
  end;
  If RH.Prox <>_posnula_hash then
  begin
    Seek (MeHash.H,RH.Prox); Read (MeHash.H,RH_Proximo);
    RH_Proximo.Ant:=RH.Ant;
    Seek (MeHash.H,RH.Prox); Write (MeHash.H,RH_Proximo);
  end;

  {************************************}
  {SI ERA EL PRIMERO O EL ULTIMO SE LO INFORMO AL ARCHIVO DE CONTROL}
  if pos=RC.primero then
    RC.primero :=RH.Prox ;
  If pos=RC.ultimo then
    RC.ultimo:=RH.Ant;
  {************************************}

  {EL REGISTRO VA A LA PILA DE BORRADOS}
  RH.ocupado:=False;
  RH.Prox:=RC.borrados;
  RC.borrados:=Pos;
  RC.total:=RC.total-1;
  {************************************}

  {GRABO AMBOS REGISTROS}
  Seek (MeHash.C,0); Write (MeHash.C,RC);
  Seek (MeHash.H,Pos); Write (MeHash.H,RH);
End;
{******************************************************************************}
Procedure CrearMe_HashAbierto(var MeHash:tMeHash;
                            Nombre_Archivo_Control, Nombre_Archivo_Datos: string;
                              Directory:string);
var
    RC:tRegControlHash;
    RD:tRegDatosHash;
    x:integer;
    ioD,ioC:integer;
begin

  assign(MeHash.H,_RUTA + Nombre_Archivo_Datos);
  assign(MeHash.C,_RUTA + Nombre_Archivo_Control);
   {$I-}
  reset(MeHash.H); ioD:=IoResult;
  reset(MeHash.C); ioC:=IoResult;
  if (IoD<>0) or (IoC<>0) then
    begin
      Rewrite(MeHash.H);
      rd.nombreEvento:='';

      rd.ocupado:=false;
      For x:=1 to _maxHash do
      Begin
       seek(MeHash.H,x-1);
       write(MeHash.H,rd);
      end;
      ReWrite(MeHash.C);
      RC.primero:=_posnula_hash;
      RC.total:=0;
      RC.borrados:=_posnula_hash;
      RC.ultimo :=_posnula_hash;

      write(MeHash.C,rc);

    end;
  Close(MeHash.H);
  Close(MeHash.C);
  {$I+}
end;
{******************************************************************************}

Function HashVacio(MeHash:tMeHash):boolean;
var
 RC:tRegControlHash;
begin
     seek(MeHash.C,0);
     read(MeHash.C,RC);
     if RC.total=0 then
       HashVacio:=true
     else
       HashVacio:=false;
end;
{******************************************************************************}
Function HashLleno(MeHash:tMeHash):boolean;
var
 RC:tRegControlHash;
begin
     seek(MeHash.C,0);
     read(MeHash.C,RC);
     if RC.total=_maxHash then
       HashLleno:=true
     else
       HashLleno:=false;
end;
{******************************************************************************}
Procedure CambiarCabeceraInsercion (var MeHash:tMeHash;pos:tPosHash);
var
  RC:tRegControlHash;
begin
  {Es la 1era vez que inserto?}
  seek(MeHash.c,0);read(MeHash.c,rc);
  If rc.total = 0 then rc.primero := pos;
  {Siempre el ultimo en entrar es este}
  rc.ultimo :=pos;
  rc.total := rc.total+1;
  seek(MeHash.c,0);
  write(MeHash.c,rc);
end;
{******************************************************************************}
Procedure InsertarHash(var MeHash:tMeHash; RDEntrante: tRegDatosHash; pos:tPosHash);
begin
  seek(MeHash.h,pos);write(MeHash.h,RDEntrante);
end;
{******************************************************************************}
Function BuscarHash(var MeHash:tMeHash; CodBuscado:nombreEventoHash; var PosFisica:tPosHash):boolean;
{En caso de Colision busca hacia adelante y hacia atras de la posicion saltando.}
{Si lo encuentra devuelve TRUE y la Posicion donde estaba}
{Si no lo encuentra y HayLugar devuelve False y la PosFisica donde deberia ir}
{Si no HayLugar entonces devuelve un False pero en PosFisica devuelve PosNula}
var
 rc:tRegControlHash;
 rd:tRegDatosHash;
 Esta,HayLugar:boolean;
 VHash:integer;
 Pos,Pos_Esta, Pos_HayLugar:tPosHash;
 i,CantSaltos:integer;
begin
  seek(MeHash.c,0);
  read(MeHash.c,rc);
  Esta:=False;
  HayLugar:=False;
  {Obtengo el Valor Hash, es un num entero}
  VHash:=ValorHash(CodBuscado);
  {Obtengo la posicion de hash de dicho valor}
  pos:=FuncionHash (VHash);
  {Arranco suponiendo que es PosNula}
  PosFisica:=_posnula_hash;
  {Contador de saltos que dare}
  i:=0;
  {Mayor diferencia de la Posicion Hash con los extremos}
  {Esto me indicara la cant de saltos necesario para recorrer el archivo}
  If (_maxHash-(pos+1))<pos then
    CantSaltos:=pos
  else
    CantSaltos:=_maxHash-(pos+1);
  {Si esta vacio la pos donde deberia ir es la que devuelve la formula hash}
  If rc.total = 0 then
    PosFisica:=Pos
  Else
  begin
  {Cuando i=0 lee la posicion devuelta por la formula hash}
    While (i<=CantSaltos) and not Esta Do
    begin
      {Busco hacia adelante siempre que haya lugares}
      If (pos+i)<=(_maxHash-1) then
      begin
        seek(MeHash.h,pos+i);read(MeHash.h,rd);
        if (rd.ocupado) and (rd.nombreEvento=CodBuscado) then
        begin
          Esta:=True;
          Pos_Esta:=pos+i;
        end
        else
          If not Rd.ocupado and not HayLugar then
          begin
            HayLugar:=True;
            Pos_HayLugar:=pos+i;
          end;
      end;
      {Busco hacia atras siempre que haya lugares y no lo haya encontrado aun}
      If ((pos-i)>=0) and (not Esta) then
      begin
        seek(MeHash.h,pos-i);read(MeHash.h,rd);
        if (rd.ocupado) and (rd.nombreEvento=CodBuscado) then
        begin
          Esta:=True;
          Pos_Esta:=pos-i;
        end
        else
          If not Rd.ocupado and not HayLugar then
          begin
            HayLugar:=True;
            Pos_HayLugar:=pos-i;
          end;
      end;
      i:=i+1;
    end;
    If Esta then
      PosFisica:=Pos_Esta
    Else
      If HayLugar then
        PosFisica:=Pos_HayLugar
      Else
        PosFisica:= _posnula_hash;
  end;
  BuscarHash:=Esta;
end;
{******************************************************************************}
Function CantMaxima (MeHash: tMeHash): Integer;
Begin
  CantMaxima:= _maxHash;
End;
{******************************************************************************}
Function FuncionHash (k:integer):Integer;
Begin                                    //Hashing por division
  FuncionHash:=1+k mod (_maxHash-1);
end;
{******************************************************************************}
Function ValorHash (Cod:nombreEventoHash):Integer; //2
var
  i, Sum, iteraciones:Integer;
Begin
  iteraciones:= 3;
  Sum:=0;
  For i:=1 to iteraciones Do
  Begin
    //Floor es para pasar de Extended que devuelve el Power a Integer
    //El power eleva a una potencia.
    Sum:=Sum + Floor(Ord(Cod[i])* Power(3,i));
  End;
  ValorHash:=Sum;
End;
{******************************************************************************}
Procedure AbrirMe_Hash(var MeHash:tMeHash);
begin
   reset(MeHash.H);
   reset(MeHash.C);
end;
{******************************************************************************}
Procedure CerrarMe_Hash(var MeHash:tMeHash);
Begin
  close(MeHash.H);
  close(MeHash.C);
end;
{******************************************************************************}
Function Total (MeHash: tMeHash): integer;
Var
  Rc: tRegControlHash ;
Begin
  Seek(MeHash.C,0);Read(MeHash.C,Rc);
  Total:=RC.Total;
End;
{******************************************************************************}
Procedure CapturarInfoHash(MeHash:tMeHash; Pos: tPosHash; var RH: tRegDatosHash);
begin
  Seek(MeHash.H,Pos);Read(MeHash.H,RH);
end;
{******************************************************************************}
Function Ultimo (MeHash:tMeHash):tPosHash;
Var
  RC: tRegControlHash;
Begin
  Seek(Mehash.C,0);Read(Mehash.C,RC);
  Ultimo:=RC.ultimo;
End;
{******************************************************************************}
Function Primero (MeHash:tMeHash):tPosHash;
Var
  RC: tRegControlHash;
Begin
  Seek(Mehash.C,0);Read(Mehash.C,RC);
  Primero:=RC.primero;
End;
{******************************************************************************}
Procedure CambiarSiguiente (MeHash: tMeHash; Sig:tPoshash);
Var
  RH: tRegDatosHash;
  RC: tRegControlHash;
Begin
  Seek (MeHash.C,0); Read(MeHash.C,RC);
  If RC.ultimo <> _posnula_hash then
  Begin
    Seek (Mehash.H, RC.ultimo); Read (MeHash.H,RH);
    RH.Prox:=Sig;
    Seek (Mehash.H, RC.ultimo); Write (MeHash.H,RH);
  End;
End;
{******************************************************************************}
Function Proximo (MeHash:tMeHash; Pos: tPosHash):tposHash;
Var
  RH: tRegDatosHash;
Begin
  Seek (MeHash.H,Pos); Read (MeHash.H,RH);
  Proximo:= RH.Prox;
End;
{******************************************************************************}


end.