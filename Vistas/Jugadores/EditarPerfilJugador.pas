unit EditarPerfilJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LO_ArbolBinario, Vcl.ExtDlgs,
  Vcl.StdCtrls,  cryptoUtils, cypher;

type
  TFormEditarPerfilJugador = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditNick: TEdit;
    EditMail: TEdit;
    EditContra: TEdit;
    EditNombre: TEdit;
    EditImagen: TEdit;
    ButtonBuscarImagen: TButton;
    ButtonInsertar: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormShow(Sender: TObject);
 
    procedure ButtonInsertarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    JugadorActual: tRegDatos;
  end;

var
  FormEditarPerfilJugador: TFormEditarPerfilJugador;

implementation

{$R *.dfm}

procedure TFormEditarPerfilJugador.ButtonInsertarClick(Sender: TObject);
var
  PosID, PosNICK:tPosArbol;
  posEnDatos: tposarchi;
   reg: tRegDatos;
begin
  BuscarNodo_Indice(MeID,JugadorActual.clave,posID);
  posEnDatos := ObtenerInfo_Indice(MeID,posID).PosEnDatos;
  ObtenerInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);

  reg.nombre := EditNombre.Text;
  JugadorActual.nombre :=   EditNombre.Text;

  reg.mail := EditMail.Text;
  JugadorActual.mail := EditMail.Text;

  if EditContra.GetTextLen > 0 then
    reg.password := EncryptStr(EditContra.text, 3);
  ModificarInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
end;


procedure TFormEditarPerfilJugador.FormShow(Sender: TObject);
begin


  EditNick.Text := JugadorActual.nick;
  EditMail.Text := JugadorActual.mail;
  EditNombre.Text := JugadorActual.nombre;
  //EditContra.Text := JugadorActual.password;
  //EditImagen.Text := JugadorActual.foto.ToString;
end;

end.
