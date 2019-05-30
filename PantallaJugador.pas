unit PantallaJugador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LO_ArbolBinario, Vcl.ExtCtrls, Vcl.Menus, EditarPerfilJugador,
   JugadoresActivos, CalendarioJuegos, lo_dobleEnlace, lo_hashabierto, PruebaCartones,
  Vcl.StdCtrls, Vcl.Grids;

type
  TFormJugador = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    SalirMenuItem: TMenuItem;
    EditarPerfil1: TMenuItem;
    EditarPerfil2: TMenuItem;
    Verjugadoresconectados1: TMenuItem;
    CalendariodeJuegos1: TMenuItem;
    Pruebas1: TMenuItem;
    CARTONES1: TMenuItem;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SalirMenuItemClick(Sender: TObject);
    procedure EditarPerfil1Click(Sender: TObject);
    procedure Verjugadoresconectados1Click(Sender: TObject);
  
    procedure CalendariodeJuegos1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CARTONES1Click(Sender: TObject);

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

procedure TFormJugador.CalendariodeJuegos1Click(Sender: TObject);
begin
  FormCalendarioJuegos.ShowModal;
end;

procedure TFormJugador.CARTONES1Click(Sender: TObject);
begin
      FormPruebaCartones.ShowModal;
end;

procedure TFormJugador.EditarPerfil1Click(Sender: TObject);
begin
     FormEditarPerfilJugador.JugadorActual := self.JugadorActual;

     FormEditarPerfilJugador.ShowModal;
end;


procedure TFormJugador.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CerrarMe_Archivos(MeJUGADORES);
  Cerrarme_indice(MeID);
   CerrarMe(MeCartones);
   CerrarMe_Hash(MeJuego);
    OutputDebugString(PChar('Cierro MES'));
end;

procedure TFormJugador.FormCreate(Sender: TObject);
var
  mii: TMenuItemInfo;
  MainMenu: hMenu;
  Buffer: array[0..79] of Char;
begin
  //Alineo a la derecha el menuitem Salir
  MainMenu := Self.Menu.Handle;
  mii.cbSize := SizeOf(mii) ;
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer) ;
  GetMenuItemInfo(MainMenu, SalirMenuItem.Command, false, mii) ;
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  SetMenuItemInfo(MainMenu, SalirMenuItem.Command, false, mii) ;
end;


procedure TFormJugador.FormShow(Sender: TObject);
var
dir,dirfull:string;
begin
  dir := ExpandFileName(GetCurrentDir + '\..\..\');
  dirfull :=  dir + 'imgs\'+ JugadorActual.nick+'.bmp';
  Image1.Picture.LoadFromFile(dirfull);


   AbrirMe_Archivos(MeJugadores);
   AbrirMe_Indice(MeID);
   AbrirMe_Indice(MeNICK);
    AbrirMe(MeCartones);
    AbrirMe_Hash(MeJuego);
  //   OutputDebugString(PChar('Abro MES'));
end;

procedure TFormJugador.SalirMenuItemClick(Sender: TObject);
var
  clave: tIDusuario;
  posEnDatos: tposarchi;
  posIndiceID: tposarbol;
  reg: tRegDatos;
begin

    if BuscarNodo_Indice(MeID,jugadoractual.clave,posIndiceID) then //simpre true, para buscar la posIndiceID
    begin
        posEnDatos := ObtenerInfo_Indice(MeID,posIndiceID).PosEnDatos;
        ObtenerInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
        reg.estado := Desconectado;
        ModificarInfoMe_Archivos(MeJUGADORES,posEnDatos,reg);
    end;
    
    FormJugador.Close;


end;

procedure TFormJugador.Verjugadoresconectados1Click(Sender: TObject);
begin
  FormJugadoresActivos.ShowModal;
end;

end.
