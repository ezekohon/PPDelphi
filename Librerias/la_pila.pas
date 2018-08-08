unit la_pila;

interface

uses
  classes, sysutils, LO_PILA;

  const
    cantBolillas = 75;

procedure generarBolilleroMezclado();

implementation

procedure generarBolilleroMezclado();
var
  i,j,r,aux: integer;
  rd: tipodato;
  arrayBolillas: array[1..75] of integer;
begin

    Randomize;
    for i:=1 to cantBolillas do
    begin
        arrayBolillas[i]:=i;
    end;
    for i:=1 to cantBolillas do
    begin
      r:= Random(75)+1;
      Aux:=arrayBolillas[i];
      arrayBolillas[i]:=arrayBolillas[r];
      arrayBolillas[r]:=Aux;
    end;

    for j:= 1 to length(arrayBolillas) do
    begin
        rd.Numero := arrayBolillas[j];
        apilar(meBolillero,rd);
    end;

end;


end.
