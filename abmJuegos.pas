unit abmJuegos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, lo_hashabierto, RTTI, DetalleJuego, Vcl.ComCtrls;

type
  TFormAbmJuegos = class(TForm)
    Grilla: TStringGrid;
    PanelABM: TPanel;
    ButtonAlta: TButton;
    ButtonModificar: TButton;
    ButtonEliminar: TButton;
    PanelCampos: TPanel;
    PanelGuardar: TPanel;
    ButtonCancelar: TButton;
    ButtonGuardar: TButton;
    EditValor: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    EditNombreEvento: TEdit;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;

    //propios
    procedure AltaJuego(nombreEvento:string; valor:real; fecha:tdatetime);
    procedure ModificarJuego(nombreEvento:string; valor:real; fecha:tdatetime);
    procedure LimpiarCampos();
    procedure PonerEnEstadoInicial();
    procedure CargarGrilla();
    Procedure SetearHeaders();
    Procedure AgregarReglon (RD: tRegDatosHash; IndexRenglon:Integer);
    function TieneCartonesVendidos():boolean;

    procedure FormCreate(Sender: TObject);
    procedure ButtonAltaClick(Sender: TObject);
    procedure ButtonModificarClick(Sender: TObject);
    procedure ButtonGuardarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonEliminarClick(Sender: TObject);
    procedure GrillaDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FormAbmJuegos: TFormAbmJuegos;


implementation

var
   AccionActual: char;
   PosModificar: tposhash;

{$R *.dfm}

//como en c#. pasar por parametro un char A(alta), M(modif)


procedure TFormAbmJuegos.ButtonAltaClick(Sender: TObject);
begin
  AccionActual := 'A';
  PanelABM.Enabled := false;
  PanelGuardar.Enabled := true;
  PanelCampos.Enabled := true;
end;

procedure TFormAbmJuegos.ButtonCancelarClick(Sender: TObject);
begin
  PonerEnEstadoInicial;
end;

procedure TFormAbmJuegos.ButtonEliminarClick(Sender: TObject);
var
  ClaveAux:String;
  Pos:tPosHash;
begin
  ClaveAux:=grilla.Cells[0,grilla.Row];
  If (ClaveAux<>'') and (grilla.Row>0) then
   begin
    If TieneCartonesVendidos() then
      Application.MessageBox( 'El juego tiene Cartones vendidos. No puede ser eliminado.','Acción no permitida', MB_ICONSTOP )
    Else
    begin
      if Application.MessageBox( PChar('¿Está seguro de que desea eliminar el juego: ' +
                                ClaveAux +'?'), 'Eliminando juego',
                                  MB_ICONQUESTION OR MB_YESNO ) = ID_YES then
      begin
      //-AbrirMe_Hash(MeJuego);
      if BuscarHash (MeJuego,ClaveAux,Pos) then  //deberia ser siempre true
         EliminarHash(MeJuego,Pos);
      //-CerrarMe_Hash(MeJuego);
      end;

    end;
  End
  Else
    ShowMessage ('Seleccione un registro válido.');
  CargarGrilla;
end;

procedure TFormAbmJuegos.LimpiarCampos();
begin
  EditNombreEvento.Clear;
  EditValor.Clear;
end;

procedure TFormAbmJuegos.PonerEnEstadoInicial();
begin
  LimpiarCampos;
  PanelCampos.Enabled := false;
  PanelGuardar.Enabled :=  false;
  PanelABM.Enabled   := true;
end;

procedure TFormAbmJuegos.ButtonGuardarClick(Sender: TObject);
var
  nEvento: nombreEventoHash;
  valor: real;
  fecha: tdatetime;
begin
  nEvento:= UpperCase(EditnombreEvento.text);
  valor:= StrToFloat (editValor.text);
  fecha:= datetimepicker1.DateTime;
  if (AccionActual = 'A') then
     AltaJuego(nEvento, valor, fecha)
  else
    ModificarJuego(nEvento, valor,fecha);

  CargarGrilla;
end;

procedure TFormAbmJuegos.ButtonModificarClick(Sender: TObject);
var
  ClaveAux: nombreEventoHash;
  Pos:tPosHash;
  Reg:tRegDatoshash;
begin
   AccionActual := 'M';
  PanelABM.Enabled := false;
  PanelGuardar.Enabled := true;
  PanelCampos.Enabled := true;


  ClaveAux:=Grilla.Cells[0,Grilla.Row];
  If (ClaveAux<>'') and (Grilla.Row>0) then
  begin
    //-AbrirMe_Hash(MeJuego);
    If BuscarHash (MeJuego,ClaveAux,Pos) then
    begin
      CapturarInfoHash(MeJuego,Pos,Reg);
      EditNombreEvento.text := reg.nombreEvento;
      EditValor.text := FloatToStr(reg.ValorVenta);
      posmodificar:= pos;
    end;
    //-CerrarMe_Hash(MeJuego);
  end;

  //buscar el reg seleccionado en la grilla y ponerlo en los campos
end;

procedure TFormAbmJuegos.FormActivate(Sender: TObject);
begin
    AbrirMe_Hash(MeJuego);
end;

procedure TFormAbmJuegos.FormCreate(Sender: TObject);
begin
  CrearMe_Hash(MeJuego);
end;

procedure TFormAbmJuegos.FormDeactivate(Sender: TObject);
begin
    CerrarMe_Hash(MeJuego);
end;

procedure TFormAbmJuegos.FormShow(Sender: TObject);
begin
  AbrirMe_Hash(MeJuego);
  CargarGrilla;
end;

procedure TFormAbmJuegos.GrillaDblClick(Sender: TObject);
var
  nombreEvento: string;
  pos: tPosHash;
  reg: tRegDatosHash;
begin
  nombreEvento := Grilla.Cells[0, grilla.Row];
  BuscarHash(MeJuego,nombreEvento,pos);
  CapturarInfoHash(MeJuego,pos,reg);
  FormDetalleJuego.JuegoActual := reg;
  FormDetalleJuego.ShowModal;
end;

procedure TFormAbmJuegos.AltaJuego(nombreEvento:string; valor:real; fecha:tdatetime);
var
   reg:tRegDatosHash;
   pos: tPosHash;
begin
   //-AbrirMe_Hash(MeJuego);

   reg.nombreEvento := nombreEvento;
   reg.valorVenta := valor;
   reg.fechaEvento := fecha;
   reg.estado := tEstadoJuego.NoJugado;
   reg.ocupado := True;
   reg.prox := _POSNULA;
   reg.id := ObtenerProximoID(MeJuego);
   reg.TotalCartonesVendidos := 0;
   reg.pozoAcumulado := 0;
   reg.PorcentajePremioLinea:= 2;
   reg.PorcentajePremioDiagonal:= 3;
   reg.PorcentajePremioCruz:= 3;
   reg.PorcentajePremioCuadradoChico:= 5;
   reg.PorcentajePremioCuadradoGrande:= 7;


  If HashLleno (MeJuego) then
        Showmessage('Archivo sin lugares disponibles.')
  else
    begin
      If (not BuscarHash (MeJuego,reg.nombreEvento,Pos)) and (Pos<>_POSNULA) then
      begin
          Reg.Ant:=Ultimo(MeJuego);
          CambiarSiguiente(MeJuego,pos);
          InsertarHash (MeJuego,Reg,Pos);
          CambiarCabeceraInsercion (MeJuego,pos);
      end
      Else
        begin
          Showmessage('La clave que intenta guardar ya existe.');
        end;
      //-CerrarMe_Hash(MeJuego);
    end;
end;

procedure TFormAbmJuegos.ModificarJuego(nombreEvento:string; valor:real; fecha: tdatetime);
var
   reg:tRegDatosHash;
   pos: tPosHash;
begin
  //-AbrirMe_Hash(MeJuego);
  CapturarInfoHash(MeJuego,PosModificar,Reg);
  reg.nombreEvento := nombreEvento;
  reg.valorVenta := valor;
  reg.fechaEvento := fecha;

  InsertarHash (MeJuego,Reg,PosModificar);

  //-CerrarMe_Hash(MeJuego);

end;

procedure TFormAbmJuegos.CargarGrilla();
var
  pos: tPosHash;
  reg: tRegDatosHash;
begin
  //-AbrirMe_Hash(MeJuego);
  If Total (MeJuego)>0 then
    Begin
      Begin
        grilla.RowCount:=1;
        SetearHeaders;
        Pos:=Primero (MeJuego);
        While pos <> _posnula do
          Begin
            CapturarInfoHash(MeJuego,pos,Reg);
            grilla.RowCount:=grilla.RowCount+1;
            AgregarReglon (reg,grilla.RowCount-1);
            pos:=Proximo(MeJuego,pos);
          End;
    End;

end;
end;

function TFormAbmJuegos.TieneCartonesVendidos():boolean;
var
   ret: boolean;
   pos: tPosHash;
  reg: tRegDatosHash;
begin

      ret:= false;
     //-AbrirMe_Hash(MeJuego);
     CapturarInfoHash(MeJuego,PosModificar,Reg);
     if reg.TotalCartonesVendidos > 0 then
      ret:= true;
     //-CerrarMe_Hash(MeJuego);

     result:= ret;
end;

Procedure TFormAbmJuegos.SetearHeaders();
Begin
  with grilla do
  Begin
  // Título de las columnas
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxx');
    //ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    //ColWidths[4] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxx');
    Cells[0, 0] := 'NOMBRE EVENTO';
    Cells[1, 0] := 'ESTADO';
    Cells[2, 0] := 'CARTONES VENDIDOS';
    //Cells[3, 0] := 'APELLIDO';
    //Cells[4, 0] := 'TEL';
  End;
End;

Procedure TFormAbmJuegos.AgregarReglon (RD: tRegDatosHash; IndexRenglon:Integer);
Begin
  If RD.ocupado then
  Begin
    with grilla do
    Begin
      Cells[0, IndexRenglon] := RD.nombreEvento;
      Cells[1, IndexRenglon] := TRttiEnumerationType.GetName( RD.estado);
      Cells[2, IndexRenglon] := IntToStr(RD.TotalCartonesVendidos);
      //Cells[3, IndexRenglon] := Rh.apellidos;
      //Cells[4, IndexRenglon] := Rh.telefono;
      FixedRows:=1;
    End;
  End;
End;

end.
