object FormComprarCartones: TFormComprarCartones
  Left = 0
  Top = 0
  Caption = 'FormComprarCartones'
  ClientHeight = 198
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 37
    Height = 13
    Caption = 'JUEGO:'
  end
  object LabelJuego: TLabel
    Left = 160
    Top = 24
    Width = 54
    Height = 13
    Caption = 'LabelJuego'
  end
  object Label2: TLabel
    Left = 32
    Top = 64
    Width = 99
    Height = 13
    Caption = 'Cartones a comprar:'
  end
  object EditCartones: TEdit
    Left = 160
    Top = 61
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
  end
  object ButtonComprar: TButton
    Left = 112
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Comprar'
    TabOrder = 1
    OnClick = ButtonComprarClick
  end
end
