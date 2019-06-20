object FormDetalleJuego: TFormDetalleJuego
  Left = 0
  Top = 0
  Caption = 'FormDetalleJuego'
  ClientHeight = 411
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelJuego: TLabel
    Left = 48
    Top = 16
    Width = 54
    Height = 13
    Caption = 'LabelJuego'
  end
  object grillaJugadores: TStringGrid
    Left = 8
    Top = 47
    Width = 378
    Height = 178
    ColCount = 3
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
  end
  object grillaGanadores: TStringGrid
    Left = 400
    Top = 47
    Width = 369
    Height = 178
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 1
    OnClick = grillaGanadoresClick
  end
  object grillaCarton: TStringGrid
    Left = 302
    Top = 240
    Width = 187
    Height = 163
    DefaultColWidth = 35
    DefaultRowHeight = 30
    FixedCols = 0
    FixedRows = 0
    TabOrder = 2
  end
end
