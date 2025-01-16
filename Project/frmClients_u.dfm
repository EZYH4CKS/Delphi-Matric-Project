object frmClients: TfrmClients
  Left = 0
  Top = 0
  Caption = 'Clients Form'
  ClientHeight = 530
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object dbGrid: TDBGrid
    Left = 8
    Top = 8
    Width = 612
    Height = 185
    DataSource = dm.dsClients
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object pnlAdjustments: TPanel
    Left = 8
    Top = 199
    Width = 803
    Height = 50
    TabOrder = 1
    object dbNav: TDBNavigator
      Left = 8
      Top = 8
      Width = 375
      Height = 35
      Hint = 'Navigate through the table.'
      DataSource = dm.dsClients
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = dbNavClick
    end
    object btnShowAll: TButton
      Left = 390
      Top = 8
      Width = 124
      Height = 35
      Hint = 
        'Clears the search query in turn showing all records in the table' +
        '.'
      Caption = 'Show All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnShowAllClick
    end
    object edtSearch: TEdit
      Left = 519
      Top = 10
      Width = 274
      Height = 29
      Hint = 'Search for a specific record in the table.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TextHint = 'Search Surname...'
      OnChange = edtSearchChange
    end
  end
  object pnlMaintenance: TPanel
    Left = 8
    Top = 255
    Width = 803
    Height = 266
    TabOrder = 2
    object Label1: TLabel
      Left = 304
      Top = 0
      Width = 183
      Height = 25
      Caption = 'Record Maintenance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object pnlAgentInfo: TPanel
      Left = 8
      Top = 31
      Width = 375
      Height = 224
      TabOrder = 0
      object Label2: TLabel
        Left = 104
        Top = 8
        Width = 164
        Height = 25
        Caption = 'Client Information'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 51
        Width = 85
        Height = 20
        Caption = 'Client Name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 16
        Top = 80
        Width = 103
        Height = 20
        Caption = 'Client Surname:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 109
        Width = 93
        Height = 20
        Caption = 'Client Gender:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 16
        Top = 138
        Width = 72
        Height = 20
        Caption = 'Client Age:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 16
        Top = 167
        Width = 70
        Height = 20
        Caption = 'Client Cell:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtClientName: TEdit
        Left = 160
        Top = 50
        Width = 185
        Height = 25
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtClientSurname: TEdit
        Left = 160
        Top = 79
        Width = 185
        Height = 25
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edtClientGender: TEdit
        Left = 160
        Top = 108
        Width = 185
        Height = 25
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edtClientAge: TEdit
        Left = 160
        Top = 137
        Width = 185
        Height = 25
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object edtClientCell: TEdit
        Left = 160
        Top = 166
        Width = 185
        Height = 25
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object Panel1: TPanel
      Left = 400
      Top = 31
      Width = 393
      Height = 224
      TabOrder = 1
      object btnClose: TBitBtn
        Left = 248
        Top = 180
        Width = 137
        Height = 33
        Hint = 'Closes the current form.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        Kind = bkClose
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object btnCreate: TButton
        Left = 16
        Top = 14
        Width = 137
        Height = 33
        Hint = 'Create a new record in the table.'
        Caption = 'Create a record'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnCreateClick
      end
      object btnDelete: TButton
        Left = 16
        Top = 180
        Width = 137
        Height = 33
        Hint = 'Delete a specific record from the table.'
        Caption = 'Delete a record'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object btnHelp: TBitBtn
        Left = 248
        Top = 141
        Width = 137
        Height = 33
        Hint = 'Displays useful help messages.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        Kind = bkHelp
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object btnUpdate: TButton
        Left = 16
        Top = 93
        Width = 137
        Height = 33
        Hint = 'Updates the current record in the table.'
        Caption = 'Update a record'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = btnUpdateClick
      end
    end
  end
  object rSort: TRadioGroup
    Left = 626
    Top = 8
    Width = 185
    Height = 65
    Hint = 'Sort the table either ascending or descending'
    Caption = 'Sorting Direction'
    Items.Strings = (
      'Ascending'
      'Descending')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = rSortClick
  end
  object rSortFields: TRadioGroup
    Left = 626
    Top = 79
    Width = 185
    Height = 114
    Hint = 'Sort the table according to a specific field'
    Caption = 'Sorting Fields'
    Items.Strings = (
      'ClientID'
      'ClientName'
      'ClientSurname'
      'ClientGender'
      'ClientAge')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = rSortFieldsClick
  end
end
