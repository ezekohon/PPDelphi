object FormEditarPerfilJugador: TFormEditarPerfilJugador
  Left = 0
  Top = 0
  Caption = 'FormEditarPerfilJugador'
  ClientHeight = 291
  ClientWidth = 355
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
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 19
    Height = 13
    Caption = 'Nick'
  end
  object Label2: TLabel
    Left = 24
    Top = 72
    Width = 18
    Height = 13
    Caption = 'Mail'
  end
  object Label3: TLabel
    Left = 8
    Top = 112
    Width = 90
    Height = 13
    Caption = 'Nueva Contrase'#241'a'
  end
  object Label4: TLabel
    Left = 24
    Top = 152
    Width = 86
    Height = 13
    Caption = 'Nombre y Apellido'
  end
  object Label5: TLabel
    Left = 24
    Top = 192
    Width = 36
    Height = 13
    Caption = 'Imagen'
  end
  object EditNick: TEdit
    Left = 104
    Top = 29
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object EditMail: TEdit
    Left = 104
    Top = 69
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditContra: TEdit
    Left = 104
    Top = 109
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object EditNombre: TEdit
    Left = 116
    Top = 149
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object EditImagen: TEdit
    Left = 92
    Top = 189
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object ButtonBuscarImagen: TButton
    Left = 248
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 5
  end
  object ButtonInsertar: TButton
    Left = 64
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Guardar'
    TabOrder = 6
    OnClick = ButtonInsertarClick
  end
  object BajaButton: TButton
    Left = 192
    Top = 240
    Width = 115
    Height = 25
    Caption = 'Darse de baja'
    TabOrder = 7
    OnClick = BajaButtonClick
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 264
    Top = 96
  end
end
