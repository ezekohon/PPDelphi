object FormABMJugadores: TFormABMJugadores
  Left = 0
  Top = 0
  Caption = 'ABM Juegadores'
  ClientHeight = 381
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grilla: TStringGrid
    Left = 8
    Top = 224
    Width = 648
    Height = 160
    FixedCols = 0
    TabOrder = 0
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 161
    Width = 648
    Height = 57
    Caption = 'RadioGroup1'
    TabOrder = 1
  end
  object RadioListadoGeneral: TRadioButton
    Left = 24
    Top = 184
    Width = 113
    Height = 17
    Caption = 'Listado General'
    TabOrder = 2
  end
  object RadioPorCartones: TRadioButton
    Left = 143
    Top = 184
    Width = 113
    Height = 17
    Caption = 'Listado Por Cartones'
    TabOrder = 3
  end
  object RadioButton3: TRadioButton
    Left = 280
    Top = 184
    Width = 113
    Height = 17
    Caption = 'RadioButton3'
    TabOrder = 4
  end
  object RadioButton4: TRadioButton
    Left = 408
    Top = 184
    Width = 113
    Height = 17
    Caption = 'RadioButton4'
    TabOrder = 5
  end
end