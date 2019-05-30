object FormJugador: TFormJugador
  Left = 0
  Top = 0
  Caption = 'FormJugador'
  ClientHeight = 264
  ClientWidth = 506
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
    Left = 393
    Top = 8
    Width = 105
    Height = 105
  end
  object Label1: TLabel
    Left = 176
    Top = 100
    Width = 96
    Height = 13
    Caption = 'PARTIDA EN JUEGO'
  end
  object StringGrid1: TStringGrid
    Left = 152
    Top = 128
    Width = 320
    Height = 120
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 24
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
end
