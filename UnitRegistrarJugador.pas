unit UnitRegistrarJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LA_arbolbinario, LO_arbolbinario, JPEG,
  Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TFormRegistrarJugador = class(TForm)
    Label1: TLabel;
    EditNick: TEdit;
    Label2: TLabel;
    EditMail: TEdit;
    Label3: TLabel;
    EditClave: TEdit;
    Label4: TLabel;
    EditNombre: TEdit;
    Label5: TLabel;
    EditImagen: TEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    ButtonBuscarImagen: TButton;
    ButtonInsertar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonBuscarImagenClick(Sender: TObject);
    procedure ButtonInsertarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRegistrarJugador: TFormRegistrarJugador;

implementation

{$R *.dfm}

procedure TFormRegistrarJugador.ButtonBuscarImagenClick(Sender: TObject);
var
  dir: string;
  pic: TBitmap;
begin
   OpenPictureDialog1.Execute;
   dir:= OpenPictureDialog1.FileName;
   EditImagen.Text := dir;
end;

procedure TFormRegistrarJugador.ButtonInsertarClick(Sender: TObject);
var
  jpg: TJpegImage;
  bmp: TBitmap;
  nick, nombre, pass, mail: string;
begin
    jpg:= Tjpegimage.Create;
    jpg.LoadFromFile(EditImagen.Text);
    bmp:= TBitmap.Create;
    bmp.Assign(jpg);

    nick:= UpperCase(editNick.Text);
    nombre:=  editNombre.Text;
    mail:=   EditMail.Text;
    pass:= editClave.Text;

    LA_arbolbinario.AltaJugador(nick,nombre,mail,pass, bmp);

end;

procedure TFormRegistrarJugador.FormCreate(Sender: TObject);
begin
  LO_ArbolBinario.CrearMe_Indice(MeID, 'CONTROLID.CON', 'DATOSID.DAT');
  LO_ArbolBinario.CrearMe_Indice(MeNICK, 'CONTROLNICK.CON', 'DATOSNICK.DAT');
  LO_ArbolBinario.CrearMe_Archivos(MeJugadores, 'CONTROLJUGADORES.CON', 'DATOSJUGADORES.DAT');
  InsertarAdminCuandoMEVacio();
end;

end.
