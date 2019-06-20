unit UnitRegistrarJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LA_arbolbinario, LO_arbolbinario, JPEG,
  Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TFormRegistrarJugador = class(TForm)
    Label1: TLabel;
    EditNick: TEdit;
    Label2: TLabel;
    EditMail: TEdit;
    Label3: TLabel;
    EditContra: TEdit;
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
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure limpiarForm();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRegistrarJugador: TFormRegistrarJugador;

implementation

{$R *.dfm}

uses Login;

procedure TFormRegistrarJugador.ButtonBuscarImagenClick(Sender: TObject);
var
  dir: string;
  pic: TBitmap;
begin
  OpenPictureDialog1.Execute;
  dir := OpenPictureDialog1.FileName;
  EditImagen.Text := dir;
end;

procedure TFormRegistrarJugador.ButtonInsertarClick(Sender: TObject);
var
  jpg: TJpegImage;
  bmp, bmpDef: TBitmap;
  nick, nombre, pass, mail, dir, dirfull: string;
  ingresado: boolean;
  thumbnail: TBitmap;
  thumbRect: TRect;
const
  maxWidth = 200;
  maxHeight = 150;
begin
  if ((EditNombre.Text <> '') and (EditMail.Text <> '') and (EditContra.Text <> '') and (EditNick.Text <> '') and
    (EditImagen.Text <> '')) then
  begin
    nick := UpperCase(EditNick.Text);
    jpg := TJpegImage.Create;

    jpg.LoadFromFile(EditImagen.Text);

    bmp := TBitmap.Create;
    bmpDef := TBitmap.Create;
    bmp.Assign(jpg);

    try
      thumbRect.Left := 0;
      thumbRect.Top := 0;
      thumbnail := TBitmap.Create;
      thumbnail.Assign(jpg);
      if thumbnail.Width > thumbnail.Height then
      begin
        thumbRect.Right := maxWidth;
        thumbRect.Bottom := (maxWidth * thumbnail.Height) div thumbnail.Width;
      end
      else
      begin
        thumbRect.Bottom := maxHeight;
        thumbRect.Right := (maxHeight * thumbnail.Width) div thumbnail.Height;
      end;
      thumbnail.Canvas.StretchDraw(thumbRect, thumbnail);
      // resize image
      thumbnail.Width := thumbRect.Right;
      thumbnail.Height := thumbRect.Bottom;

      dir := ExpandFileName(GetCurrentDir + '\..\..\');
      dirfull := dir + 'imgs\' + nick + '.bmp';
      thumbnail.SaveToFile(dirfull);
    except
      on E: Exception do
        ShowMessage(E.ClassName + ' error raised, with message : ' + E.Message);
    end;

    nombre := EditNombre.Text;
    mail := EditMail.Text;
    pass := EditContra.Text; // editContra.Text;

    ingresado := LA_arbolbinario.AltaJugador(nick, nombre, mail, pass, jpg);
    if ingresado then
      ShowMessage('Jugador registrado con exito');
    limpiarForm;
    FormRegistrarJugador.Hide();
  end
  else
  begin
    ShowMessage('Ingrese todos los campos.');
  end;

  // FormLogin.Show();
end;

procedure TFormRegistrarJugador.FormActivate(Sender: TObject);
begin
  AbrirMe_Archivos(MeJugadores);
  AbrirMe_Indice(MeNick);
  AbrirMe_Indice(MeID);
end;

procedure TFormRegistrarJugador.FormCreate(Sender: TObject);
begin
  LO_arbolbinario.CrearMe_Indice(MeID, 'CONTROLID.CON', 'DATOSID.DAT');
  LO_arbolbinario.CrearMe_Indice(MeNick, 'CONTROLNICK.CON', 'DATOSNICK.DAT');
  LO_arbolbinario.CrearMe_Archivos(MeJugadores, 'CONTROLJUGADORES.CON',
    'DATOSJUGADORES.DAT');
  AbrirMe_Archivos(MeJugadores);
  AbrirMe_Indice(MeNick);
  AbrirMe_Indice(MeID);
  InsertarAdminCuandoMEVacio();
end;

procedure TFormRegistrarJugador.FormDeactivate(Sender: TObject);
begin
  CerrarMe_Archivos(MeJugadores);
  CerrarMe_Indice(MeNick);
  CerrarMe_Indice(MeID);
end;

procedure TFormRegistrarJugador.limpiarForm();
begin
   editnick.clear;
   editcontra.clear;
   editmail.clear;
   editimagen.clear;
   editnombre.clear;
end;

end.
