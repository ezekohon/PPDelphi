unit BolillasSacadas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, lo_hashabierto, lo_colasparciales, lo_pila,
  Vcl.Grids;

type
  TFormBolillasSacadas = class(TForm)
    grilla: TStringGrid;
  procedure CargarGrilla();      //ANDA BIEN.
    Procedure SetearHeaders();
    Procedure AgregarReglon(RD: tipodato; IndexRenglon: Integer);
    procedure LimpiarGrilla();
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual: tRegDatosHash;
  end;

var
  FormBolillasSacadas: TFormBolillasSacadas;

implementation

{$R *.dfm}

procedure TFormBolillasSacadas.CargarGrilla();
var
  i: Integer;
  reg, raux: tipodato;
  arr: array of Integer;
begin
  SetearHeaders;
  i := 1;
  while not lo_colasparciales.colaVacia(metiradas, JuegoActual.ID) do
  begin
    lo_colasparciales.tope(metiradas, reg ,JuegoActual.ID);
    decolar(metiradas,JuegoActual.ID);

    SetLength(arr, Length(arr) + 1);
    arr[Length(arr) - 1] := reg.Numero;

    AgregarReglon(reg, i);
    i := i + 1;
  end;

  for i := Low(arr) to High(arr) do
  begin
    raux.Numero := arr[i];
    encolar(metiradas, raux,JuegoActual.ID);
  end;
end;


procedure TFormBolillasSacadas.FormShow(Sender: TObject);
begin
  OutputDebugString(PChar('TFormBolillasSacadas.FormShow'));
  limpiarGrilla;
  CargarGrilla;
end;

Procedure TFormBolillasSacadas.SetearHeaders();
Begin
  with grilla do
  Begin
    // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');

    Cells[0, 0] := 'BOLILLA';

  End;
End;

Procedure TFormBolillasSacadas.AgregarReglon(RD: tipodato;
  IndexRenglon: Integer);
Begin

  with grilla do
  Begin
    Cells[0, IndexRenglon] := IntToStr(RD.Numero);

    FixedRows := 1;
  End;

End;

procedure TFormBolillasSacadas.LimpiarGrilla();
var
  I: Integer;
begin
  for I := 0 to grilla.RowCount - 1 do
    grilla.Rows[I].Clear;
  grilla.RowCount := 76;
end;

end.
