unit EditarPerfilJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LO_ArbolBinario, Vcl.ExtDlgs,
  Vcl.StdCtrls, cryptoUtils, cypher, lo_hashabierto, la_hashabierto,
  la_dobleenlace,
  lo_dobleEnlace;

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
    BajaButton: TButton;
    procedure FormShow(Sender: TObject);

    procedure ButtonInsertarClick(Sender: TObject);
    procedure BajaButtonClick(Sender: TObject);
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

procedure TFormEditarPerfilJugador.BajaButtonClick(Sender: TObject);
var
  // i: integer;
  reg: tRegDatosHash;
  pos: tPosHash;
  tieneCartonesComprados: boolean;
  PosID, PosNICK: tPosArbol;
  posEnDatos: tposarchi;
  regJugador: tRegDatos;
  buttonSelected: integer;
begin
  // chequear que jugador no tenga cartones en partidas jugando o a jugar
  tieneCartonesComprados := false;
  pos := lo_hashabierto.Primero(MeJuego);
  While ((pos <> _posnula) and (not tieneCartonesComprados)) do
  begin
    CapturarInfoHash(MeJuego, pos, reg);
    if ((reg.estado = Jugando) or (reg.estado = NoActivado)) then
    begin
      tieneCartonesComprados := isTieneCartonesComprados(JugadorActual.clave,
        reg.nombreEvento, MeCartones)
    end;
    pos := lo_hashabierto.Proximo(MeJuego, pos);
  end;
  // actualizar su estado a baja
  if tieneCartonesComprados then
    MessageDlg
      ('No puede darse de baja. Tiene cartones comprados en un juego en desarrollo o por jugarse.',
      mtError, [mbOK], 0)
  else
  begin
    buttonSelected :=
      MessageDlg('Est� seguro que desea darse de baja como jugador?',
      mtConfirmation, mbOKCancel, 0);
    if buttonSelected = mrOK then
    begin
      BuscarNodo_Indice(MeID, JugadorActual.clave, PosID);
      posEnDatos := ObtenerInfo_Indice(MeID, PosID).posEnDatos;
      ObtenerInfoMe_Archivos(MeJUGADORES, posEnDatos, regJugador);
      regJugador.estado := Baja;
      ModificarInfoMe_Archivos(MeJUGADORES, posEnDatos, regJugador);
      FormEditarPerfilJugador.Close;

    end;
  end;

end;

procedure TFormEditarPerfilJugador.ButtonInsertarClick(Sender: TObject);
var
  PosID, PosNICK: tPosArbol;
  posEnDatos: tposarchi;
  reg: tRegDatos;
begin
  BuscarNodo_Indice(MeID, JugadorActual.clave, PosID);
  posEnDatos := ObtenerInfo_Indice(MeID, PosID).posEnDatos;
  ObtenerInfoMe_Archivos(MeJUGADORES, posEnDatos, reg);

  reg.nombre := EditNombre.Text;
  JugadorActual.nombre := EditNombre.Text;

  reg.mail := EditMail.Text;
  JugadorActual.mail := EditMail.Text;

  if EditContra.GetTextLen > 0 then
    reg.password := EncryptStr(EditContra.Text, 3);
  ModificarInfoMe_Archivos(MeJUGADORES, posEnDatos, reg);
end;

procedure TFormEditarPerfilJugador.FormShow(Sender: TObject);
begin

  EditNick.Text := JugadorActual.nick;
  EditMail.Text := JugadorActual.mail;
  EditNombre.Text := JugadorActual.nombre;
  // EditContra.Text := JugadorActual.password;
  // EditImagen.Text := JugadorActual.foto.ToString;
end;

end.
