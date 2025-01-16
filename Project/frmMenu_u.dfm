object frmMenu: TfrmMenu
  Left = 0
  Top = 0
  Caption = 'Menu Form'
  ClientHeight = 368
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 21
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 276
    Height = 32
    Caption = 'Select which page to visit:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object btnAgents: TButton
    Left = 8
    Top = 46
    Width = 276
    Height = 58
    Caption = 'Agents'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnAgentsClick
  end
  object btnClients: TButton
    Left = 8
    Top = 110
    Width = 276
    Height = 58
    Caption = 'Clients'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnClientsClick
  end
  object btnProperties: TButton
    Left = 8
    Top = 174
    Width = 276
    Height = 58
    Caption = 'Properties'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnPropertiesClick
  end
  object btnHelp: TBitBtn
    Left = 8
    Top = 319
    Width = 137
    Height = 41
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 3
  end
  object btnClose: TBitBtn
    Left = 151
    Top = 319
    Width = 133
    Height = 41
    Caption = '&Log out'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Kind = bkClose
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnStats: TButton
    Left = 8
    Top = 238
    Width = 276
    Height = 58
    Caption = 'Stats'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnStatsClick
  end
end
