unit Globals;

interface

uses
  lo_arbolbinario,math,dialogs;

  type
   tTipoPremio = (LineaHorizontal, LineaVertical, Diagonal1,
    Diagonal2, Cruz, CuadradoChico, CuadradoGrande, Bingo);
   tModoEjecucion = (Normal, VManual, VAutomatica);
    function dosDecimales(numero:real):real;
    procedure mensajeInformacion(msg:string);
    function mensajeConfirmacion(msg:string):integer ;
    procedure mensajeError(msg:string);
var
  JugadorLogueado: lo_arbolbinario.tregdatos;
const
 ruta = 'C:\Users\ezeko\Google Drive\Juan 23\PROG 2\MIO\TRABAJOFINALDELPHI\Archivos\';

implementation

function dosDecimales(numero:real):real;
begin
  result:= RoundTo(numero,-2);
end;

procedure mensajeInformacion(msg:string);
begin
  messagedlg(msg, mtInformation, [mbOk], 0, mbOk);
end;

procedure mensajeError(msg:string);
begin
  messagedlg(msg, mtError, [mbOk], 0, mbOk);
end;

function mensajeConfirmacion(msg:string):integer ;
begin
  result:= messagedlg(msg,mtConfirmation, mbOKCancel, 0);
end;

end.
