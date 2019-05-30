unit JugadoresActivos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LA_arbolbinario, LO_arbolbinario, Vcl.Grids, JPEG;

type
  TFormJugadoresActivos = class(TForm)
    grilla: TStringGrid;
  


        //propios
    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon (RD: tRegDatos; IndexRenglon:Integer);
    procedure FormShow(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormJugadoresActivos: TFormJugadoresActivos;

implementation

{$R *.dfm}

procedure TFormJugadoresActivos.FormShow(Sender: TObject);
begin
  CargarGrilla;
end;



Procedure TFormJugadoresActivos.AgregarReglon (RD: tRegDatos; IndexRenglon:Integer);
var
dir,dirfull:string;
jpg: TJpegImage;
bmp, bmpDef: TBitmap;
Begin


    with grilla do
    Begin

      Cells[0, IndexRenglon] := RD.nick;
      Cells[1, IndexRenglon] := DateTimeToStr(RD.fechaUltimaConexion);//TRttiEnumerationType.GetName( RD.estado);

       dir := ExpandFileName(GetCurrentDir + '\..\..\');
       dirfull :=  dir + 'imgs\'+ Rd.nick+'.bmp';
       bmp:= TBitmap.Create;
        bmpDef  := TBitmap.Create;
        //bmp.Assign(jpg);
        bmp.LoadFromFile(dirfull);
        grilla.Canvas.StretchDraw(grilla.CellRect(2, IndexRenglon), bmp);
      //Cells[2, IndexRenglon] := RD.nombre;
      {Canvas.TextOut(0, IndexRenglon, RD.nick);
      Canvas.TextOut(1, IndexRenglon, DateTimeToStr(RD.fechaUltimaConexion));

        dir := ExpandFileName(GetCurrentDir + '\..\..\');
        dirfull :=  dir + 'imgs\'+ Rd.nick+'.bmp';

        //jpg:= Tjpegimage.Create;
        //jpg.LoadFromFile(dirfull);

        bmp:= TBitmap.Create;
        bmpDef  := TBitmap.Create;
        //bmp.Assign(jpg);
        bmp.LoadFromFile(dirfull);

      Canvas.Draw(2, IndexRenglon, bmp);}
      FixedRows:=1;
    End;

End;

procedure TFormJugadoresActivos.CargarGrilla();
var
  //pos: tPosHash;
  i, count: integer;
  reg: tRegDatos;
  arr: array[0..100] of tRegDatos;
begin
    SetearHeaders;
  //-AbrirMe_Archivos(MeJugadores);
  count := 1;
    for i := 0 to Ultimo_Archivos(MeJugadores) do
      begin

        ObtenerInfoMe_Archivos(MeJUGADORES,i,reg);
        if reg.estado = Conectado then
        begin
          AgregarReglon(reg,count);
          count:= count + 1;
        end;
      end;
end;




Procedure TFormJugadoresActivos.SetearHeaders();
Begin
  with grilla do
  Begin
  // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    //Canvas.TextOut(0, 0, 'NICK');
    //Canvas.TextOut(1, 0, 'FECHA CONEXI�N');
    //Canvas.TextOut(02, 0, 'FOTO');

    Cells[0, 0] := 'NICK';
    Cells[1, 0] := 'FECHA CONEXI�N';
    Cells[2, 0] := 'FOTO';

    //Cells[3, 0] := 'APELLIDO';
    //Cells[4, 0] := 'TEL';
  End;
End;

end.
