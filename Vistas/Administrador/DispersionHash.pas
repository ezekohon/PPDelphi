unit DispersionHash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, lo_hashabierto, rtti;

type
  TFormDispersionHash = class(TForm)
    grilla: TStringGrid;

    Procedure AgregarReglonVacio(IndexRenglon: Integer);
    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon(RD: tRegDatosHash; IndexRenglon: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDispersionHash: TFormDispersionHash;

implementation

{$R *.dfm}

procedure TFormDispersionHash.CargarGrilla();
var
  Pos: tposhash;
  Reg: tRegDatosHash;
  I: Integer;
begin
  // -AbrirMe_Hash(MeJuego);
  If Total(MeJuego) > 0 then
  Begin
    Begin
      grilla.RowCount := 1;
      SetearHeaders;
      { Pos := Primero(MeJuego);
        While Pos <> _POSNULA do
        Begin
        CapturarInfoHash(MeJuego, Pos, Reg);
        Grilla.RowCount := Grilla.RowCount + 1;
        if reg.ocupado then
        AgregarReglon(Reg, Grilla.RowCount - 1)
        else
        begin
        AgregarReglonVacio(Grilla.RowCount - 1);
        end;

        Pos := Proximo(MeJuego, Pos);
        End; }
      for I := 0 to CantMaxima(MeJuego)-1 do
      begin
        CapturarInfoHash(MeJuego, I, Reg);
        grilla.RowCount := grilla.RowCount + 1;
        if Reg.ocupado then
          AgregarReglon(Reg, grilla.RowCount - 1)
        else
        begin
          AgregarReglonVacio(grilla.RowCount - 1);
        end;
      end;
    End;

  end;
end;

Procedure TFormDispersionHash.SetearHeaders();
Begin
  with grilla do
  Begin
    // Título de las columnas
    ColWidths[0] := Canvas.TextWidth
      ('xxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxx');
    // ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    // ColWidths[4] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxx');
    Cells[0, 0] := 'NUM';
    Cells[1, 0] := 'NOMBRE EVENTO';
    Cells[2, 0] := 'ESTADO';
    // Cells[3, 0] := 'APELLIDO';
    // Cells[4, 0] := 'TEL';
  End;
End;

Procedure TFormDispersionHash.AgregarReglon(RD: tRegDatosHash;
  IndexRenglon: Integer);
Begin
  If RD.ocupado then
  Begin
    with grilla do
    Begin
      Cells[0, IndexRenglon] := IntToStr(IndexRenglon);
      Cells[1, IndexRenglon] := RD.nombreEvento;
      Cells[2, IndexRenglon] := TRttiEnumerationType.GetName(RD.estado);
      FixedRows := 1;
    End;
  End;
End;

Procedure TFormDispersionHash.AgregarReglonVacio(IndexRenglon: Integer);
Begin
  with grilla do
  Begin
    Cells[0, IndexRenglon] := IntToStr(IndexRenglon);
    Cells[1, IndexRenglon] := ' ';
    Cells[2, IndexRenglon] := ' ';
    FixedRows := 1;
  End;

End;

procedure TFormDispersionHash.FormShow(Sender: TObject);
begin
  CargarGrilla;
end;

end.
