object FormBalanceoJugadores: TFormBalanceoJugadores
  Left = 0
  Top = 0
  Caption = 'FormBalanceoJugadores'
  ClientHeight = 348
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object nom_listado: TLabel
    Left = 440
    Top = 16
    Width = 3
    Height = 13
  end
  object grilla: TStringGrid
    Left = 8
    Top = 68
    Width = 625
    Height = 241
    TabOrder = 0
    Visible = False
  end
  object VerificarButton: TButton
    Left = 200
    Top = 315
    Width = 97
    Height = 25
    Caption = 'Verificar'
    TabOrder = 1
    Visible = False
    OnClick = VerificarButtonClick
  end
  object ListarIDButton: TButton
    Left = 48
    Top = 16
    Width = 97
    Height = 25
    Caption = 'Listar por ID'
    TabOrder = 2
    OnClick = ListarIDButtonClick
  end
  object ListarNICKButton: TButton
    Left = 200
    Top = 16
    Width = 97
    Height = 25
    Caption = 'Listar por NICK'
    TabOrder = 3
    OnClick = ListarNICKButtonClick
  end
end
