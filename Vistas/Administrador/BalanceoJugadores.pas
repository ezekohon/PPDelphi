unit BalanceoJugadores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, lo_arbolbinario;

type
  TFormBalanceoJugadores = class(TForm)
    grilla: TStringGrid;
    VerificarButton: TButton;
    ListarIDButton: TButton;
    ListarNICKButton: TButton;
    nom_listado: TLabel;

    procedure Encabezado;
    Procedure AgregarReglonID (Arbol:MeArbol;N:tNodoIndice);
    Procedure ListarPorNivelesID ;
    Procedure ListarNivelID(Arbol:MeArbol; Raiz:tPosArbol; Nivel:integer);
    procedure ListarIDButtonClick(Sender: TObject);
    procedure ListarNICKButtonClick(Sender: TObject);
    Procedure ListarNivelNICK(Arbol:mearbol; Raiz:tPosArbol;Nivel:integer);
    Procedure AgregarReglonNICK (Arbol:mearbol;N:tNodoIndice);
    Procedure ListarPorNivelesNICK;
    procedure VerificarButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBalanceoJugadores: TFormBalanceoJugadores;

implementation

{$R *.dfm}

Procedure TFormBalanceoJugadores.ListarPorNivelesID ;
var
  i:integer;
begin
  Encabezado;
  //AbrirMe_Indice (MeID);
  For i:=1 to CantidadNiveles (MeID) Do
  Begin
    ListarNivelID (MeID,Raiz_Indice(MeID),i);
  end;
  //CerrarMe_Indice (MeID);
end;

procedure TFormBalanceoJugadores.ListarIDButtonClick(Sender: TObject);
begin

      grilla.Visible:=True;
    //verificarButton.Visible:=True;
    ListarPorNivelesID;
    Nom_listado.Caption:='INDICE POR ID' ;
end;

procedure TFormBalanceoJugadores.ListarNICKButtonClick(Sender: TObject);
begin
    grilla.Visible:=True;
    //verificarButton.Visible:=True;
    ListarPorNivelesNICK;
    Nom_listado.Caption:='INDICE POR NICK' ;
end;

Procedure TFormBalanceoJugadores.ListarPorNivelesNICK;
var
  i:integer;
begin
  Encabezado;
  AbrirMe_Indice (MeNICK);
  For i:=1 to CantidadNiveles (MeNICK) Do
  Begin
    ListarNivelNICK (MeNICK,Raiz_Indice(MeNICK),i);
  end;
  CerrarMe_Indice (MeNICK);
end;

procedure TFormBalanceoJugadores.VerificarButtonClick(Sender: TObject);
Var
  Balanceado:Boolean;
  Pos:tPosArbol;
  N:tNodoIndice;
  Cont:integer;
begin
  If (Nom_listado.Caption ='INDICE POR ID') then
  begin
    Balanceado:=True;
    //AbrirMe_Indice (MeID);
    pos:=_posnula_arbol;
    AVL_Indice (MeID,Raiz_Indice(MeID),pos,Balanceado);
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
          pos:=_posnula_arbol;
          //AbrirMe_Indice (MeID);
            AVL_Indice (MeID,Raiz_Indice(MeID),pos,Balanceado);
            If (not Balanceado)then
            begin
              N:=ObtenerInfo_Indice (MeID,pos);
              CasoDeDesequilibrio (MeID,pos);
            end;
            cont:=cont+1;
          //CerrarMe_Indice (MeID);
        end;
      end;
    end;
    ListarPorNivelesID;
  end
  Else
  begin
    Balanceado:=True;
    //AbrirMe_Indice (MeNICK);
      pos:=_posnula_arbol;
      AVL_Indice (MeNICK,Raiz_Indice(MeNICK),pos,Balanceado);
    //CerrarMe_Indice (MeNICK);

    If Balanceado then
      ShowMessage ('El Arbol se encuentra balanceado')
    Else
    begin
      if MessageDlg('Arbol NO balanceado. �Desea equilibrarlo?', mtConfirmation,
                                                    [mbYes, mbNo], 0)=mrYes then
      begin
        cont:=0;
        While (Cont<=99999) and (not Balanceado) Do
        begin
          Balanceado:=True;
          pos:=_posnula_arbol;
          //AbrirMe_Indice (MeNICK);
            AVL_Indice (MeNICK,Raiz_Indice(MeNICK),pos,Balanceado);
            If (not Balanceado)then
            begin
              N:=ObtenerInfo_Indice (MeNICK,pos);
              CasoDeDesequilibrio (MeNICK,pos);
            end;
            cont:=cont+1;
          //CerrarMe_Indice (MeNICK);
        end;
      end;
    end;
    ListarPorNivelesNICK;
  end;
end;

Procedure TFormBalanceoJugadores.ListarNivelNICK(Arbol:mearbol; Raiz:tPosArbol;
                                                                  Nivel:integer);
var
  Rd: tRegDatos;
  N:tNodoIndice;
  Ti,Td,Result:Integer;
begin
  If (raiz =PosNula_Indice (Arbol)) then exit;
  ListarNivelNICK (Arbol,ProximoIzq_Indice(Arbol,Raiz),Nivel);
  N:=ObtenerInfo_Indice (Arbol,Raiz);

  If N.nivel = Nivel then
  begin
    AgregarReglonNICK (Arbol,N);
  end;

  ListarNivelNICK (Arbol,ProximoDer_Indice(Arbol,Raiz),Nivel);
end;

Procedure TFormBalanceoJugadores.AgregarReglonNICK (Arbol:mearbol;N:tNodoIndice);
var
  RD:tRegDatos;
  Nodo:tNodoIndice;
begin
  with grilla do
  Begin
      RowCount:=RowCount+1;
      Cells[0, RowCount-1] := N.clave;

      If N.hi <> PosNula_Indice (Arbol) then
        Nodo:=ObtenerInfo_Indice (Arbol,N.hi)
      Else
        Nodo.clave:='Null';
      Cells[1, RowCount-1] := Nodo.clave;

      If N.hd <> PosNula_Indice (Arbol) then
        Nodo:=ObtenerInfo_Indice (Arbol,N.hd)
      Else
        Nodo.clave:='Null';
      Cells[2, RowCount-1] := Nodo.clave;

      Cells[3, RowCount-1] := Inttostr(N.nivel);
      FixedRows:=1;
  End;
End;

Procedure TFormBalanceoJugadores.ListarNivelID(Arbol:MeArbol; Raiz:tPosArbol;
                                                                  Nivel:integer);
var
  Rd: tRegDatos;
  N:tNodoIndice;
  Ti,Td,Result:Integer;
begin
  If (raiz =PosNula_Indice (Arbol)) then exit;
  ListarNivelID (Arbol,ProximoIzq_Indice(Arbol,Raiz),Nivel);
  N:=ObtenerInfo_Indice (Arbol,Raiz);

  If N.nivel = Nivel then
  begin
    AgregarReglonID(Arbol,N);
  end;

  ListarNivelID (Arbol,ProximoDer_Indice(Arbol,Raiz),Nivel);
end;

procedure TFormBalanceoJugadores.Encabezado;
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

Procedure TFormBalanceoJugadores.AgregarReglonID (Arbol:MeArbol;N:tNodoIndice);
var
  Nodo:tNodoIndice;
begin
  with grilla do
  Begin
      RowCount:=RowCount+1;
      Cells[0, RowCount-1] := N.clave;

      If N.hi <> PosNula_Indice (Arbol) then
        Nodo:=ObtenerInfo_Indice (Arbol,N.hi)
      Else
        Nodo.clave:='Null';
      Cells[1, RowCount-1] := Nodo.clave;

      If N.hd <> PosNula_Indice (Arbol) then
        Nodo:=ObtenerInfo_Indice (Arbol,N.hd)
      Else
        Nodo.clave:='Null';
      Cells[2, RowCount-1] := Nodo.clave;

      Cells[3, RowCount-1] := Inttostr(N.nivel);
      FixedRows:=1;

  End;
End;

end.
