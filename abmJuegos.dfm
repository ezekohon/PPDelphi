object FormAbmJuegos: TFormAbmJuegos
  Left = 0
  Top = 0
  Caption = 'FormAbmJuegos'
  ClientHeight = 531
  ClientWidth = 640
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
  object Grilla: TStringGrid
    Left = 8
    Top = 275
    Width = 617
    Height = 248
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goRowSelect]
    TabOrder = 0
    OnDblClick = GrillaDblClick
  end
  object PanelABM: TPanel
    Left = 8
    Top = 16
    Width = 137
    Height = 253
    Color = 8454016
    TabOrder = 1
    object ButtonAlta: TButton
      Left = 8
      Top = 8
      Width = 121
      Height = 49
      Caption = 'Alta'
      TabOrder = 0
      OnClick = ButtonAltaClick
    end
    object ButtonModificar: TButton
      Left = 8
      Top = 87
      Width = 121
      Height = 49
      Caption = 'Modificar'
      TabOrder = 1
      OnClick = ButtonModificarClick
    end
    object ButtonEliminar: TButton
      Left = 8
      Top = 166
      Width = 121
      Height = 49
      Caption = 'Eliminar'
      TabOrder = 2
      OnClick = ButtonEliminarClick
    end
  end
  object PanelCampos: TPanel
    Left = 160
    Top = 16
    Width = 465
    Height = 185
    Enabled = False
    TabOrder = 2
    object Label2: TLabel
      Left = 40
      Top = 59
      Width = 77
      Height = 13
      Caption = 'Valor del Cart'#243'n'
    end
    object Label1: TLabel
      Left = 40
      Top = 19
      Width = 74
      Height = 13
      Caption = 'Nombre Evento'
    end
    object Label3: TLabel
      Left = 41
      Top = 104
      Width = 76
      Height = 13
      Caption = 'Fecha de Juego'
    end
    object EditValor: TEdit
      Left = 144
      Top = 56
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object EditNombreEvento: TEdit
      Left = 144
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object DateTimePicker1: TDateTimePicker
      Left = 144
      Top = 104
      Width = 121
      Height = 21
      Date = 43569.735605625000000000
      Time = 43569.735605625000000000
      TabOrder = 2
    end
  end
  object PanelGuardar: TPanel
    Left = 160
    Top = 216
    Width = 465
    Height = 49
    Enabled = False
    TabOrder = 3
    object ButtonCancelar: TButton
      Left = 56
      Top = 8
      Width = 91
      Height = 33
      Caption = 'Cancelar'
      TabOrder = 0
      OnClick = ButtonCancelarClick
    end
    object ButtonGuardar: TButton
      Left = 312
      Top = 8
      Width = 91
      Height = 33
      Caption = 'Guardar'
      TabOrder = 1
      OnClick = ButtonGuardarClick
    end
  end
end
