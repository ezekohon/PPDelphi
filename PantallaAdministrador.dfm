object FormAdministrador: TFormAdministrador
  Left = 0
  Top = 0
  Caption = 'FormAdministrador'
  ClientHeight = 300
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 150
    Height = 19
    Caption = 'Ejecuci'#243'n de partidas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object grilla: TStringGrid
    Left = 8
    Top = 72
    Width = 588
    Height = 220
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 0
    OnDblClick = grillaDblClick
  end
  object MainMenu1: TMainMenu
    Left = 464
    Top = 8
    object Acciones1: TMenuItem
      Caption = 'Acciones'
      object RegistrarJugador1: TMenuItem
        Caption = 'Registrar Jugador'
        OnClick = RegistrarJugador1Click
      end
      object ABMJuegos1: TMenuItem
        Caption = 'ABM Juegos'
        OnClick = ABMJuegos1Click
      end
      object ABMJuegadores: TMenuItem
        Caption = 'ABM Jugadores'
        OnClick = ABMJuegadoresClick
      end
    end
  end
end
