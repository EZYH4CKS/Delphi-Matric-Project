object frmStats: TfrmStats
  Left = 0
  Top = 0
  Caption = 'Stats Form'
  ClientHeight = 330
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object Label4: TLabel
    Left = 8
    Top = 174
    Width = 187
    Height = 33
    Caption = 'Value sum of all properties owned by a specific client.'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 8
    Top = 261
    Width = 186
    Height = 30
    Caption = 'Check if property is above or below market value:'
    WordWrap = True
  end
  object rEdit: TRichEdit
    Left = 8
    Top = 8
    Width = 536
    Height = 160
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 422
    Top = 244
    Width = 121
    Height = 35
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 422
    Top = 285
    Width = 121
    Height = 35
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = bkClose
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
  end
  object cmbClientID: TComboBox
    Left = 8
    Top = 213
    Width = 187
    Height = 23
    TabOrder = 3
    Text = 'Client ID'
    OnChange = cmbClientIDChange
  end
  object cmbPropertyID: TComboBox
    Left = 8
    Top = 297
    Width = 187
    Height = 23
    TabOrder = 4
    Text = 'Property ID'
    OnChange = cmbPropertyIDChange
  end
end
