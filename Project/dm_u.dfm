object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object conn: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\IT12\PAT\Phase 2' +
      '\personal\database.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 88
  end
  object tblAgents: TADOTable
    Active = True
    Connection = conn
    CursorType = ctStatic
    TableName = 'tblAgents'
    Left = 104
    Top = 88
  end
  object dsAgents: TDataSource
    DataSet = tblAgents
    Left = 184
    Top = 88
  end
  object tblClients: TADOTable
    Active = True
    Connection = conn
    CursorType = ctStatic
    TableName = 'tblClients'
    Left = 104
    Top = 144
  end
  object dsClients: TDataSource
    DataSet = tblClients
    Left = 184
    Top = 144
  end
  object tblProperties: TADOTable
    Active = True
    Connection = conn
    CursorType = ctStatic
    TableName = 'tblProperties'
    Left = 104
    Top = 200
  end
  object dsProperties: TDataSource
    DataSet = tblProperties
    Left = 184
    Top = 200
  end
  object qryAgents: TADOQuery
    Connection = conn
    Parameters = <>
    Left = 344
    Top = 88
  end
  object qryClients: TADOQuery
    Connection = conn
    Parameters = <>
    Left = 344
    Top = 144
  end
  object qryProperties: TADOQuery
    Connection = conn
    Parameters = <>
    Left = 344
    Top = 200
  end
  object dsAgentsQuery: TDataSource
    DataSet = qryAgents
    Left = 440
    Top = 88
  end
  object dsClientsQuery: TDataSource
    DataSet = qryClients
    Left = 440
    Top = 144
  end
  object dsPropertiesQuery: TDataSource
    DataSet = qryProperties
    Left = 440
    Top = 200
  end
end
