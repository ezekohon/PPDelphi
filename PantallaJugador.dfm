object FormJugador: TFormJugador
  Left = 0
  Top = 0
  Caption = 'FormJugador'
  ClientHeight = 389
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 619
    Top = 0
    Width = 105
    Height = 105
  end
  object LabelPartidaEnJuego: TLabel
    Left = 16
    Top = 8
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelHora: TLabel
    Left = 360
    Top = 8
    Width = 36
    Height = 13
    Caption = 'HORA: '
  end
  object LabelPremio: TLabel
    Left = 113
    Top = 56
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grillaBolillas: TStringGrid
    Left = 8
    Top = 111
    Width = 710
    Height = 135
    ColCount = 15
    DefaultColWidth = 45
    FixedCols = 0
    FixedRows = 0
    TabOrder = 0
  end
  object grillaPremios: TStringGrid
    Left = 96
    Top = 252
    Width = 456
    Height = 120
    FixedCols = 0
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 552
    Top = 64
    object EditarPerfil1: TMenuItem
      Caption = 'Herramientas'
      object EditarPerfil2: TMenuItem
        Caption = 'Editar Perfil'
        OnClick = EditarPerfil1Click
      end
      object Verjugadoresconectados1: TMenuItem
        Caption = 'Ver jugadores conectados'
        OnClick = Verjugadoresconectados1Click
      end
      object CalendariodeJuegos1: TMenuItem
        Caption = 'Calendario de Juegos'
        OnClick = CalendariodeJuegos1Click
      end
    end
    object SalirMenuItem: TMenuItem
      Caption = 'Salir'
      OnClick = SalirMenuItemClick
    end
    object Pruebas1: TMenuItem
      Caption = 'Pruebas'
      object CARTONES1: TMenuItem
        Caption = 'CARTONES'
        OnClick = CARTONES1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 552
    Top = 16
  end
end
