unit ListadoJugadores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, lo_hashabierto, LO_ArbolBinario, la_dobleenlace,
  lo_dobleenlace,rtti;

type
  TFormListadoJugadores = class(TForm)
    grillaJugadores: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure CargarGrillaJugadores();
    Procedure InOrdenArbolBi(Arbol: MeArbol;
  Raiz: tPosArbol);
  Procedure SetearHeadersJugadores();
  Procedure AgregarReglonJugadores(RD: tRegDatos);
  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual: tRegDatosHash;
  end;

var
  FormListadoJugadores: TFormListadoJugadores;

implementation

{$R *.dfm}

procedure TFormListadoJugadores.CargarGrillaJugadores();
var
  // pos: tPosHash;
  i, count: Integer;
  reg: tRegDatos;
begin
  SetearHeadersJugadores;
  { count := 1;
    for i := 0 to Ultimo_Archivos(MeJugadores) do
    begin

    ObtenerInfoMe_Archivos(MeJugadores, i, reg);
    if isTieneCartonesComprados(reg.clave, JuegoActual.id, mecartones) then
    begin
    AgregarReglonJugadores(reg, count);
    count := count + 1;
    end;

    end; }
  InOrdenArbolBi(MeNick, Raiz_Indice(MeNick));
end;

Procedure TFormListadoJugadores.InOrdenArbolBi(Arbol: MeArbol;
  Raiz: tPosArbol);
var
  RD: tRegDatos;
  N: tNodoIndice;
begin
  If Raiz = PosNula_Indice(Arbol) then
    exit;

  // Primero recursivo tendiendo a la Izquierda
  InOrdenArbolBi(Arbol, ProximoIzq_Indice(Arbol, Raiz));

  // Guardo en N el nodo indice.
  N := ObtenerInfo_Indice(Arbol, Raiz);

  // De N utilizo la posicion en Clientes para leer el registro.
  ObtenerInfoMe_Archivos(MeJugadores, N.PosEnDatos, RD);

  if isTieneCartonesComprados(RD.clave, JuegoActual.nombreEvento, mecartones)
  then
    AgregarReglonJugadores(RD);


  // Recursividad tendiendo a la Derecha.

  InOrdenArbolBi(Arbol, ProximoDer_Indice(Arbol, Raiz));

end;

Procedure TFormListadoJugadores.SetearHeadersJugadores();
Begin
  with grillaJugadores do
  Begin
    // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');

    Cells[0, 0] := 'JUGADOR';
    Cells[1, 0] := 'ESTADO';
    Cells[2, 0] := 'CARTONES';
  End;
End;

procedure TFormListadoJugadores.FormShow(Sender: TObject);
begin
  CargarGrillaJugadores;
end;

Procedure TFormListadoJugadores.AgregarReglonJugadores(RD: tRegDatos);
// IndexRenglon: Integer);
Begin

  with grillaJugadores do
  Begin
    RowCount := RowCount + 1;
    Cells[0, RowCount - 1] := RD.nick;
    Cells[1, RowCount - 1] := TRttiEnumerationType.GetName(RD.estado);
    Cells[2, RowCount - 1] := IntToStr(cantidadCartonesComprados(RD.clave,
      JuegoActual.nombreEvento, mecartones));

    FixedRows := 1;
  End;

End;
end.
