unit abmJugadores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, lo_arbolbinario, la_arbolbinario,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormABMJugadores = class(TForm)
    grilla: TStringGrid;
    RadioGroup1: TRadioGroup;
    RadioListadoGeneral: TRadioButton;
    RadioPorCartones: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;

    //propios
    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon (RD: tRegDatos; IndexRenglon:Integer);
    Procedure EnOrden (Arbol:MeArbol; Raiz: tPosArbol);



    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormABMJugadores: TFormABMJugadores;

implementation

{$R *.dfm}

procedure TFormAbmJugadores.CargarGrilla();
var
  //pos: tPosHash;
  i: integer;
  reg: tRegDatos;
begin
  SetearHeaders;
  AbrirMe_Archivos(MeJugadores);

  if RadioListadoGeneral.Checked then
  begin
    for i := 0 to Ultimo_Archivos(MeJugadores) do
      begin
        ObtenerInfoMe_Archivos(MeJUGADORES,i,reg);
        AgregarReglon(reg,i+1);
      end;
  end;


end;

Procedure TFormAbmJugadores.EnOrden (Arbol:MeArbol; Raiz: tPosArbol);
var
  Rd: tRegDatos;
  N:tNodoIndice;
begin
    If raiz =PosNula_Indice (Arbol) then exit;

    //Primero recursivo tendiendo a la Izquierda
    EnOrden (Arbol,ProximoIzq_Indice(Arbol,Raiz));

    //Guardo en N el nodo indice.
    N:=ObtenerInfo_Indice (Arbol,Raiz);

    //De N utilizo la posicion en Clientes para leer el registro.
    ObtenerInfoMe_Archivos(MeJUGADORES,N.PosEnDatos,RD);
    AgregarReglon (Rd);

    //Recursividad tendiendo a la Derecha.
    EnOrden (Arbol,ProximoDer_Indice(Arbol,Raiz));
end;


Procedure TFormABMJugadores.SetearHeaders();
Begin
  with grilla do
  Begin
  // T�tulo de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[4] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    Cells[0, 0] := 'CLAVE';
    Cells[1, 0] := 'MAIL';
    Cells[2, 0] := 'NICK';
    Cells[3, 0] := 'ESTADO';
    Cells[4, 0] := 'NOMBRE';
    //Cells[3, 0] := 'APELLIDO';
    //Cells[4, 0] := 'TEL';
  End;
End;

Procedure TFormABMJugadores.AgregarReglon (RD: tRegDatos; IndexRenglon:Integer);
Begin

    with grilla do
    Begin

      Cells[0, IndexRenglon] := RD.clave;
      Cells[1, IndexRenglon] := RD.MAIL;//TRttiEnumerationType.GetName( RD.estado);
      Cells[2, IndexRenglon] := RD.nick;//IntToStr(RD.TotalCartonesVendidos);
      Cells[3, IndexRenglon] := RD.estado;
      Cells[4, IndexRenglon] := RD.nombre;
      FixedRows:=1;
    End;

End;

procedure TFormABMJugadores.FormCreate(Sender: TObject);
begin
  LO_ArbolBinario.CrearMe_Indice(MeID, 'CONTROLID.CON', 'DATOSID.DAT');
  LO_ArbolBinario.CrearMe_Indice(MeNICK, 'CONTROLNICK.CON', 'DATOSNICK.DAT');
  LO_ArbolBinario.CrearMe_Archivos(MeJugadores, 'CONTROLJUGADORES.CON', 'DATOSJUGADORES.DAT');
  InsertarAdminCuandoMEVacio();
end;

procedure TFormABMJugadores.FormShow(Sender: TObject);
begin
  RadioListadoGeneral.Checked := true;
  CargarGrilla;
end;

end.
