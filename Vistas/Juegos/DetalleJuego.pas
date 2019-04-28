unit DetalleJuego;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LO_HashAbierto;

type
  TFormDetalleJuego = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    JuegoActual:   tRegDatosHash;
  end;

var
  FormDetalleJuego: TFormDetalleJuego;

implementation

{$R *.dfm}

end.
