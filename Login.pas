unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, LO_ArbolBinario, la_arbolbinario,
    cypher, PantallaAdministrador, UnitRegistrarJugador, PantallaJugador, Globals, lo_dobleEnlace
    ,lo_pila, lo_colasparciales, lo_arboltrinario;

type
  TFormLogin = class(TForm)
    MainMenu1: TMainMenu;
    re1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    EditNick: TEdit;
    EditPassword: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure re1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;
const
    encryptionKey = 'MAKV2SPBNI99212';

implementation

{$R *.dfm}

procedure TFormLogin.Button1Click(Sender: TObject);
var
  nick: string;
  posEnDatos: tposarchi;
  posIndiceNICK: tposarbol;
  reg: tRegDatos;
  pass: string;
begin
  //si es usuario comun mandarlo a pantalla principal, si es admin al panel de control
    //-AbrirMe_Archivos(MeJugadores);
    //-AbrirMe_Indice(MeNick);
    if BuscarNodo_Indice(MeNick,string.UpperCase(EditNick.Text),posIndiceNick) then //si true es que existe jugador
    begin
        posEnDatos := ObtenerInfo_Indice(MeNick,posIndiceNick).PosEnDatos;
        ObtenerInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
        pass := DecryptStr(reg.password, 3) ;
        if  pass = EditPassword.Text then
        begin
              if reg.nick = 'ADMINISTRADOR' then
              begin
                  //FormLogin.Hide();
                  FormAdministrador.showmodal;//Show();
              end
              else
              begin
                  ObtenerInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
                  reg.estado := Conectado;
                  reg.fechaUltimaConexion := Now;
                  ModificarInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
                  FormJugador.JugadorActual := reg;
                  Globals.JugadorLogueado := reg;
                  //FormLogin.Hide();
                  FormJugador.ShowModal;
              end;
        end;

    end
    else
      ShowMessage ('Jugador no existe o contrase�a inv�lida.');

    //-CerrarMe_Archivos(MeJUGADORES);
    //-Cerrarme_indice(MeNick);
end;

procedure TFormLogin.FormActivate(Sender: TObject);
begin
    AbrirMe_Archivos(MeJugadores);
    AbrirMe_Indice(MeNick);
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
   lo_dobleEnlace.CrearMe(MeCartones);
   lo_pila.CrearMe(MeBolillero, lo_pila._RUTA_ARCHIVO_DATOS, lo_pila._RUTA_ARCHIVO_CONTROL);
   lo_pila.CrearMe(MePilaGanadores, _RUTA_ARCHIVO_PILA_DATOS, _RUTA_ARCHIVO_PILA_CONTROL);
   lo_arboltrinario.CrearMe_ArbolTri(MeIndiceGanadores);
   CrearMe(MeTiradas);

   //centralizar aca la creacion de MEs? total todos los forms se crean en arranque
end;

procedure TFormLogin.FormDeactivate(Sender: TObject);
begin
    CerrarMe_Archivos(MeJUGADORES);
    Cerrarme_indice(MeNick);
end;

procedure TFormLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if ord(Key) = VK_RETURN then
  begin
    Key := #0; // prevent beeping
    Button1Click(sender);
  end;
end;

procedure TFormLogin.re1Click(Sender: TObject);
begin
      //FormLogin.Hide();
      FormRegistrarJugador.Show();
end;

end.
