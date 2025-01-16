object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Login Form'
  ClientHeight = 610
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object pnlLogin: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 145
    TabOrder = 0
    object Label1: TLabel
      Left = 128
      Top = 3
      Width = 62
      Height = 30
      Caption = 'Log in'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 43
      Width = 56
      Height = 15
      Caption = 'Username:'
    end
    object Label3: TLabel
      Left = 24
      Top = 72
      Width = 53
      Height = 15
      Caption = 'Password:'
    end
    object edtLoginUsername: TEdit
      Left = 86
      Top = 40
      Width = 203
      Height = 23
      TabOrder = 0
      Text = 'John'
      TextHint = 'Username...'
    end
    object edtLoginPassword: TEdit
      Left = 86
      Top = 69
      Width = 203
      Height = 23
      TabOrder = 1
      Text = '12345'
      TextHint = 'Password...'
    end
    object btnLogin: TButton
      Left = 24
      Top = 98
      Width = 265
      Height = 36
      Caption = 'LOGIN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnLoginClick
    end
  end
  object pnlRegister: TPanel
    Left = 8
    Top = 159
    Width = 321
    Height = 394
    TabOrder = 1
    object Label4: TLabel
      Left = 120
      Top = 0
      Width = 79
      Height = 30
      Caption = 'Register'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 24
      Top = 43
      Width = 56
      Height = 15
      Caption = 'Username:'
    end
    object Label6: TLabel
      Left = 24
      Top = 72
      Width = 53
      Height = 15
      Caption = 'Password:'
    end
    object Label7: TLabel
      Left = 24
      Top = 166
      Width = 35
      Height = 15
      Caption = 'Name:'
    end
    object Label8: TLabel
      Left = 24
      Top = 195
      Width = 50
      Height = 15
      Caption = 'Surname:'
    end
    object Label9: TLabel
      Left = 24
      Top = 282
      Width = 24
      Height = 15
      Caption = 'Age:'
    end
    object Label10: TLabel
      Left = 24
      Top = 312
      Width = 23
      Height = 15
      Caption = 'Cell:'
    end
    object edtRegUsername: TEdit
      Left = 86
      Top = 40
      Width = 203
      Height = 23
      TabOrder = 0
      TextHint = 'Username...'
    end
    object edtRegPassword: TEdit
      Left = 86
      Top = 69
      Width = 203
      Height = 23
      TabOrder = 1
      TextHint = 'Password...'
    end
    object edtRegName: TEdit
      Left = 86
      Top = 163
      Width = 203
      Height = 23
      TabOrder = 2
      TextHint = 'Name...'
    end
    object edtRegSurname: TEdit
      Left = 86
      Top = 192
      Width = 203
      Height = 23
      TabOrder = 3
      TextHint = 'Surname...'
    end
    object spnRegAge: TSpinEdit
      Left = 86
      Top = 279
      Width = 203
      Height = 24
      MaxValue = 100
      MinValue = 18
      TabOrder = 4
      Value = 18
    end
    object edtRegCell: TEdit
      Left = 86
      Top = 309
      Width = 203
      Height = 23
      TabOrder = 5
      TextHint = 'Cell No...'
    end
    object btnRegister: TButton
      Left = 24
      Top = 338
      Width = 265
      Height = 39
      Caption = 'REGISTER'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = btnRegisterClick
    end
    object rgpRegGender: TRadioGroup
      Left = 86
      Top = 221
      Width = 203
      Height = 52
      Caption = 'Gender'
      ItemIndex = 0
      Items.Strings = (
        'Male'
        'Female')
      TabOrder = 7
    end
    object rgpRegUser: TRadioGroup
      Left = 86
      Top = 98
      Width = 203
      Height = 55
      Caption = 'User Type'
      ItemIndex = 0
      Items.Strings = (
        'Client'
        'Agent')
      TabOrder = 8
    end
  end
  object btnHelp: TBitBtn
    Left = 8
    Top = 568
    Width = 161
    Height = 33
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 2
  end
  object btnClose: TBitBtn
    Left = 175
    Top = 568
    Width = 157
    Height = 33
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 3
  end
end
