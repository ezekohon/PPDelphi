unit BalanceoGanadores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, lo_arboltrinario;

type
  TFormBalanceoGanadores = class(TForm)
    grilla: TStringGrid;
    VerificarButton: TButton;
    procedure VerificarButtonClick(Sender: TObject);
    Procedure ListarPorNiveles ;
    Procedure ListarNivel(Arbol:tMeIndiceTri; Raiz:tPosTri;Nivel:integer);
    Procedure AgregarReglon(Arbol:tMeIndiceTri;N:tNodoIndiceTri);
    procedure Encabezado;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBalanceoGanadores: TFormBalanceoGanadores;

implementation

{$R *.dfm}

procedure TFormBalanceoGanadores.VerificarButtonClick(Sender: TObject);
Var
  Balanceado:Boolean;
  Pos:tPosTri;
  N:tNodoIndiceTri;
  Cont:integer;
begin
    Balanceado:=True;
    //AbrirMe_Indice (MeID);
    pos:=_posnula_tri;
    AVL_Indice (MeIndiceGanadores,Raiz_Tri(MeIndiceGanadores),pos,Balanceado);
    //CerrarMe_Indice (MeID);

    If Balanceado then
      ShowMessage ('El Arbol se encuentra balanceado')
    Else
    begin
      if MessageDlg('Arbol NO balanceado. �Desea equilibrarlo?', mtConfirmation,
                                                    [mbYes, mbNo], 0)=mrYes then
      begin
        cont:=0;
        {El contador lo utilizo para prevenir que un bucle infinito por error
        acontezca. Comprobe que no se dan errores, pero aun asi mas vale prevenir}
        While (Cont<=99999) and (not Balanceado) Do
        begin
          Balanceado:=True;
          pos:=_posnula_tri;
          //AbrirMe_Indice (MeID);
            AVL_Indice (MeIndiceGanadores,Raiz_Tri(MeIndiceGanadores),pos,Balanceado);
            If (not Balanceado)then
            begin
              ObtenerNodo (MeIndiceGanadores,pos, N);
              CasoDeDesequilibrio (MeIndiceGanadores,pos);
            end;
            cont:=cont+1;
          //CerrarMe_Indice (MeID);
        end;
      end;
    end;
    ListarPorNiveles;

end;

Procedure TFormBalanceoGanadores.ListarPorNiveles ;
var
  i:integer;
begin
  Encabezado;
  //AbrirMe_Indice (MeID);
  For i:=1 to CantidadNiveles (MeIndiceGanadores) Do
  Begin
    ListarNivel (MeIndiceGanadores,Raiz_Tri(MeIndiceGanadores),i);
  end;
  //CerrarMe_Indice (MeID);
end;

Procedure TFormBalanceoGanadores.ListarNivel(Arbol:tMeIndiceTri; Raiz:tPosTri;
                                                                  Nivel:integer);
var
  //Rd: tRegDatos;
  N:tNodoIndiceTri;
  Ti,Td,Result:Integer;
begin
  If (raiz =PosNula_Tri (Arbol)) then exit;
  ListarNivel (Arbol,ProximoIzq_tri(Arbol,Raiz),Nivel);
  ObtenerNodo (Arbol,Raiz,n);

  If N.nivel = Nivel then
  begin
    AgregarReglon(Arbol,N);
  end;

  ListarNivel(Arbol,ProximoDer_Tri(Arbol,Raiz),Nivel);
end;

Procedure TFormBalanceoGanadores.AgregarReglon(Arbol:tMeIndiceTri;N:tNodoIndiceTri);
var
  Nodo:tNodoIndiceTri;
begin
  with grilla do
  Begin
      RowCount:=RowCount+1;
      Cells[0, RowCount-1] := N.idGanador;

      If N.hi <> PosNula_Tri (Arbol) then
        ObtenerNodo (Arbol,N.hi, Nodo)
      Else
        Nodo.idGanador:='Null';
      Cells[1, RowCount-1] := Nodo.idGanador;

      If N.hd <> PosNula_Tri (Arbol) then
        ObtenerNodo (Arbol,N.hd, Nodo)
      Else
        Nodo.idGanador:='Null';
      Cells[2, RowCount-1] := Nodo.idGanador;

      Cells[3, RowCount-1] := Inttostr(N.nivel);
      FixedRows:=1;

  End;
End;

procedure TFormBalanceoGanadores.Encabezado;
begin
  with grilla do
  Begin
  // T�tulo de las columnas
    RowCount:=1;
    ColWidths[0] := Canvas.TextWidth('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    ColWidths[1] := Canvas.TextWidth('xxxxxxxxxxxxx');
    ColWidths[2] := Canvas.TextWidth('xxxxxxxxxxxxx');
    ColWidths[3] := Canvas.TextWidth('xxxxxxxxxxxxx');
    Cells[0, 0] := 'CLAVE';
    Cells[1, 0] := 'HIJO IZQ';
    Cells[2, 0] := 'HIJO DER';
    Cells[3, 0] := 'NIVEL';
  End;
end;
procedure TFormBalanceoGanadores.FormShow(Sender: TObject);
begin
   ListarPorNiveles;
end;

end.
