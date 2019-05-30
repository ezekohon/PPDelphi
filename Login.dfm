object FormLogin: TFormLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 205
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 19
    Height = 13
    Caption = 'Nick'
  end
  object Label2: TLabel
    Left = 8
    Top = 72
    Width = 56
    Height = 13
    Caption = 'Contrase'#241'a'
  end
  object EditNick: TEdit
    Left = 88
    Top = 21
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'administrador'
  end
  object EditPassword: TEdit
    Left = 88
    Top = 69
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    Text = 'mandrake'
  end
  object Button1: TButton
    Left = 64
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ingresar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    Left = 304
    object re1: TMenuItem
      Caption = 'Registro'
      OnClick = re1Click
    end
  end
end
