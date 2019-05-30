unit FichaJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, lo_arbolbinario, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, lo_dobleenlace, la_dobleenlace, lo_hashabierto;

type
  TFormFichaJugador = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    JugadorEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    FechaIngresoEdit: TEdit;
    PremiosAcumuladosEdit: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    CartonesEdit: TEdit;
    Label6: TLabel;
    PremiosGanadosEdit: TEdit;
    grilla: TStringGrid;
    Cartón: TLabel;
    grillaCarton: TStringGrid;
    Label7: TLabel;
    StringGrid1: TStringGrid;
    panel1: TPanel;
    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon(RD: tRegDatos_DE; IndexRenglon: Integer);
    procedure LimpiarGrilla();
  private
    { Private declarations }
  public
    { Public declarations }
    JugadorActual: tRegDatos;
    JuegoActual: tRegDatosHash;
  end;

var
  FormFichaJugador: TFormFichaJugador;

implementation

{$R *.dfm}

procedure TFormFichaJugador.CargarGrilla();
var
  i, j,count: Integer;
  reg, raux: tRegDatos_DE;
  arr: array of Integer;
  idJugador: tidUsuario;
  idJuego: tId;
begin
  SetearHeaders;
  i := 1;
  count := 1;
  if not MeVacio(MeCartones) then
  begin
    j := lo_dobleenlace.Primero(MeCartones);
    // while j <> _posnula do
    repeat
      reg := lo_dobleenlace.CapturarInfo(MeCartones, j);

      if ((reg.idJugador = jugadoractual.clave) and (reg.idJuego = juegoactual.id)) then
        AgregarReglon(reg, count);
      j := lo_dobleenlace.Proximo(MeCartones, j);

    until (j = _posnula);
  end;

end;

Procedure TFormFichaJugador.SetearHeaders();
Begin
  with grilla do
  Begin
    // Título de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');

    Cells[0, 0] := 'CARTÓN';
    Cells[1, 0] := 'PREMIOS';
    Cells[2, 0] := 'DINERO';

  End;
End;

Procedure TFormFichaJugador.AgregarReglon(RD: tRegDatos_DE; IndexRenglon: Integer);
Begin

  with grilla do
  Begin
    Cells[0, IndexRenglon] := IntToStr(RD.idcarton);
    Cells[1, IndexRenglon] := 'HACER';
    Cells[2, IndexRenglon] := 'HACER';

    FixedRows := 1;
  End;

End;

procedure TFormFichaJugador.LimpiarGrilla();
var
  i: Integer;
begin
  for i := 0 to grilla.RowCount - 1 do
    grilla.Rows[i].Clear;
  grilla.RowCount := 76;
end;

end.
