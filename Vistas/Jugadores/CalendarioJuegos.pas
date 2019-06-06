unit CalendarioJuegos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, lo_hashabierto, comprarCartones, la_arbolbinario,
  globals, lo_dobleEnlace,la_dobleEnlace;

type
  TFormCalendarioJuegos = class(TForm)
    grilla: TStringGrid;

    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon (RD: tRegDatosHash; IndexRenglon:Integer);
    procedure FormShow(Sender: TObject);
  
    procedure grillaDblClick(Sender: TObject);
    procedure grillaDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    rowsToColor : Array[1..100] of Integer;
  end;

var
  FormCalendarioJuegos: TFormCalendarioJuegos;

implementation

{$R *.dfm}


procedure TFormCalendarioJuegos.CargarGrilla();
var
  //pos: tPosHash;
   count: integer;
  reg: tRegDatosHash;
   pos: tPosHash;
begin
  SetearHeaders;
   count := 1;
    //for i := 0 to lo_hashabierto.Ultimo(MeJuego) do
    if Total(MeJuego)>0 then
    begin
    Pos:=lo_hashabierto.Primero (MeJuego);
    While pos <> _posnula do
      begin
        CapturarInfoHash(MeJuego,pos,reg);
         if reg.estado = NoActivado then
         begin
              AgregarReglon(reg,count);
             // if isTieneCartonesComprados(globals.JugadorLogueado.clave, reg.ID, mecartones)  then
              //    rowsToColor[i]:= count;
              count:= count + 1;
         end;
         pos:=lo_hashabierto.Proximo(MeJuego,pos);
      end;
    end;
end;


procedure TFormCalendarioJuegos.FormShow(Sender: TObject);
begin

  OutputDebugString(PChar('FormShow TFormCalendarioJuegos')) ;
  CargarGrilla;
end;

procedure TFormCalendarioJuegos.grillaDblClick(Sender: TObject);
var
  nombreEvento: string;
  pos: tPosHash;
  reg: tRegDatosHash;
begin
  nombreEvento := Grilla.Cells[0, grilla.Row];
  BuscarHash(MeJuego,nombreEvento,pos);
  CapturarInfoHash(MeJuego,pos,reg);
  FormComprarCartones.JuegoActual := reg;
  FormComprarCartones.ShowModal;
end;

procedure TFormCalendarioJuegos.grillaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
  var
  i: integer;
begin
  i:= 0;

  while rowsToColor[i]<>0 do
  begin
    if rowsToColor[i] = arow then
    begin
        grilla.Canvas.Brush.Color := clGreen;
        grilla.Canvas.FillRect(Rect);
        grilla.Canvas.TextRect(Rect,Rect.Left,Rect.top,grilla.Cells[ACol,ARow]);
     end;
    i:= i+1;
  end;

end;

Procedure TFormCalendarioJuegos.SetearHeaders();
Begin
  with grilla do
  Begin
  // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');
    ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxx');

    Cells[0, 0] := 'NOMBRE EVENTO';
    Cells[1, 0] := 'FECHA';
    Cells[2, 0] := 'POZO ACUMULADO';
    Cells[3, 0] := 'CARTONES VENDIDOS';

  End;
End;

Procedure TFormCalendarioJuegos.AgregarReglon (RD: tRegDatosHash; IndexRenglon:Integer);
Begin


    with grilla do
    Begin
      Cells[0, IndexRenglon] := RD.nombreEvento;
      Cells[1, IndexRenglon] := DateTimeToStr(RD.fechaEvento);
      Cells[2, IndexRenglon] := FloatToStr(RD.PozoAcumulado);//TRttiEnumerationType.GetName( RD.estado);
      Cells[3, IndexRenglon] := IntToStr(RD.TotalCartonesVendidos);//IntToStr(RD.TotalCartonesVendidos);

      FixedRows:=1;
    End;

End;

end.
