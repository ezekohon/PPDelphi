unit ComprarCartones;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, lo_hashabierto, lo_dobleenlace, la_dobleEnlace,
  Vcl.StdCtrls, Globals, la_hashabierto;

type
  TFormComprarCartones = class(TForm)
    Label1: TLabel;
    LabelJuego: TLabel;
    Label2: TLabel;
    EditCartones: TEdit;
    ButtonComprar: TButton;
    ButtonDevolucion: TButton;
   
    procedure ButtonComprarClick(Sender: TObject);
    procedure ButtonDevolucionClick(Sender: TObject);



    procedure toggleBotonDevolucion();

    procedure FormPaint(Sender: TObject);  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual: tRegDatosHash;
  end;

var
  FormComprarCartones: TFormComprarCartones;

implementation

{$R *.dfm}

procedure TFormComprarCartones.ButtonComprarClick(Sender: TObject);
var
  buttonSelected,i,cantidadCartones : Integer;
  precioTotal: real;
  grilla : tMatriz;
  posHash: tPosHash;
  reg: tRegDatosHash;
begin
  cantidadCartones := strtoint(editcartones.Text);
  precioTotal:= cantidadCartones*JuegoActual.ValorVenta;
   buttonSelected := messagedlg('El precio es $'+FloatToStr(strtoint(editcartones.Text)*JuegoActual.ValorVenta)+' por los '+editcartones.Text+' cartones.'+' Est� seguro que desea realizar la compra?',mtConfirmation, mbOKCancel, 0);
   if buttonSelected = mrOK     then
   begin
     //generar cartones,
     for I := 0 to cantidadCartones-1 do
     begin
       repeat
         grilla:= generarGrilla();
       until (not isGrillaEnMe(MeCartones, grilla));

       //falta chequear que la grilla no exista ya ( hacerlo en LA)
       altaCarton(Globals.JugadorLogueado.clave, juegoactual.nombreEvento, grilla);
     end;
     //cambiar cant cartones vendidos del juego,
     JuegoActual.TotalCartonesVendidos := JuegoActual.TotalCartonesVendidos + cantidadCartones;


     BuscarHash(MeJuego,juegoactual.nombreEvento,posHash);
     CapturarInfoHash(MeJuego,poshash, reg);
     reg.TotalCartonesVendidos := JuegoActual.TotalCartonesVendidos;
     ModificarHash(MeJuego,poshash,reg);


     //tirarle msg compra realizada con exito
     messagedlg('Compra realizada con �xito!', mtInformation, [mbOk], 0, mbOk);
     FormComprarCartones.CloseModal;
   end;
end;



procedure TFormComprarCartones.ButtonDevolucionClick(Sender: TObject);
var
  cantEliminados,buttonSelected:integer;
begin
    //proc en LA params: idJuego, idJugador , con confirmacion
    buttonSelected := messagedlg('Seguro que desea devolver todos sus cartones en el juego seleccionado?',mtConfirmation, mbOKCancel, 0);
    if buttonSelected = mrOK     then
    begin
      cantEliminados:= eliminarCartonesDeJugador(globals.JugadorLogueado.clave, juegoActual.ID, mecartones);
      restarCantidadCartonesVendidos(cantEliminados, juegoActual.nombreEvento);
    end;
end;


procedure TFormComprarCartones.FormPaint(Sender: TObject);
begin
     toggleBotonDevolucion();
end;

procedure TFormComprarCartones.toggleBotonDevolucion();
begin
    if la_dobleEnlace.tieneCartonesComprados(globals.JugadorLogueado.clave, juegoActual.ID, mecartones) then
      ButtonDevolucion.Enabled := True
    else
    begin
           ButtonDevolucion.Enabled := False;
    end;
end;

end.
