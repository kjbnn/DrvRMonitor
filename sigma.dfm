object dmSigma: TdmSigma
  OldCreateOrder = False
  Height = 465
  Width = 236
  object DB_Protocol: TIBDatabase
    DatabaseName = 'localhost:C:\'#1056#1091#1073#1077#1078'\DB\Protocol\PROTOCOL.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = TR_ProtocolR
    ServerType = 'IBServer'
    SQLDialect = 1
    AllowStreamedConnected = False
    Left = 140
    Top = 20
  end
  object TR_ProtocolR: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = DB_Protocol
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 140
    Top = 70
  end
  object qEvent: TIBQuery
    Database = DB_Protocol
    Transaction = TR_ProtocolR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 140
    Top = 130
  end
  object DB_Work: TIBDatabase
    Connected = True
    DatabaseName = 'localhost:C:\'#1056#1091#1073#1077#1078'\DB\R08WORK.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251'
      '')
    LoginPrompt = False
    DefaultTransaction = TR_WorkR
    ServerType = 'IBServer'
    AllowStreamedConnected = False
    Left = 30
    Top = 20
  end
  object TR_WorkR: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = DB_Work
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 30
    Top = 70
  end
  object qPodraz: TIBQuery
    Database = DB_Work
    Transaction = TR_WorkR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 30
    Top = 170
  end
  object qConfig: TIBQuery
    Database = DB_Work
    Transaction = TR_WorkR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 30
    Top = 120
  end
  object qUsr: TIBQuery
    Database = DB_Work
    Transaction = TR_WorkR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 30
    Top = 220
  end
  object qDolg: TIBQuery
    Database = DB_Work
    Transaction = TR_WorkR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 30
    Top = 270
  end
  object qWAnyR: TIBQuery
    Database = DB_Work
    Transaction = TR_WorkR
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 30
    Top = 326
  end
end
