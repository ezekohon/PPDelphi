object FormCalendarioJuegos: TFormCalendarioJuegos
  Left = 0
  Top = 0
  Caption = 'FormCalendarioJuegos'
  ClientHeight = 239
  ClientWidth = 553
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
  object grilla: TStringGrid
    Left = 8
    Top = 8
    Width = 537
    Height = 223
    FixedCols = 0
    TabOrder = 0
    OnDblClick = grillaDblClick
    OnDrawCell = grillaDrawCell
  end
end
