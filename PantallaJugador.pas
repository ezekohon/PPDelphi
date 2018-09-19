unit PantallaJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LO_ArbolBinario, Vcl.ExtCtrls;

type
  TFormJugador = class(TForm)
    Image1: TImage;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    JugadorActual: tRegDatos;
  end;

var
  FormJugador: TFormJugador;


implementation

{$R *.dfm}

procedure TFormJugador.FormShow(Sender: TObject);
var
dir,dirfull:string;
begin
  dir := ExpandFileName(GetCurrentDir + '\..\..\');
  dirfull :=  dir + 'imgs\'+ JugadorActual.nick+'.bmp';
  Image1.Picture.LoadFromFile(dirfull);
end;

end.