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
    Top = 8
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
    Top = 33
    Width = 588
    Height = 220
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 0
    OnDblClick = grillaDblClick
  end
  object VirtualizarButton: TButton
    Left = 192
    Top = 259
    Width = 137
    Height = 25
    Caption = 'Virtualizar Partida Manual'
    TabOrder = 1
    OnClick = VirtualizarButtonClick
  end
  object ComenzarButton: TButton
    Left = 48
    Top = 259
    Width = 110
    Height = 25
    Caption = 'Comenzar Partida'
    TabOrder = 2
    OnClick = ComenzarButtonClick
  end
  object VirtualizarAutomaticoButton: TButton
    Left = 376
    Top = 259
    Width = 161
    Height = 25
    Caption = 'Virtualizar Partida Autom'#225'tico'
    TabOrder = 3
    OnClick = VirtualizarAutomaticoButtonClick
  end
  object MainMenu1: TMainMenu
    Left = 552
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
    object PRUEBAS1: TMenuItem
      Caption = 'PRUEBAS'
      object CARTONES1: TMenuItem
        Caption = 'CARTONES'
        OnClick = CARTONES1Click
      end
    end
    object Balanceo1: TMenuItem
      Caption = 'Balanceo'
      object MEJugadores1: TMenuItem
        Caption = 'ME Jugadores'
        OnClick = MEJugadores1Click
      end
      object MEGanadores1: TMenuItem
        Caption = 'ME Ganadores'
        OnClick = MEGanadores1Click
      end
      object MEJuegos1: TMenuItem
        Caption = 'ME Juegos'
        OnClick = MEJuegos1Click
      end
    end
  end
end
