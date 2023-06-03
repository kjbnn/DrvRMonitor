object dmSigma: TdmSigma
  OldCreateOrder = False
  Height = 360
  Width = 489
  object DB_Protocol: TIBDatabase
    DatabaseName = 'localhost:C:\'#1056#1091#1073#1077#1078'\DB\Protocol\PROTOCOL.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = TR_Protocol
    ServerType = 'IBServer'
    SQLDialect = 1
    Left = 410
    Top = 30
  end
  object TR_Protocol: TIBTransaction
    DefaultDatabase = DB_Protocol
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 410
    Top = 80
  end
  object qEvent: TIBQuery
    Database = DB_Protocol
    Transaction = TR_Protocol
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 410
    Top = 140
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
    DefaultTransaction = TR_Work
    ServerType = 'IBServer'
    Left = 30
    Top = 20
  end
  object TR_Work: TIBTransaction
    DefaultDatabase = DB_Work
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 30
    Top = 70
  end
  object qUsr: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select  IDBCP, IDZONE AS USR, FAMIL, IME, OTC, PODR from USR')
    Left = 100
    Top = 210
  end
  object qPodraz: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 30
    Top = 170
  end
  object qConfig: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 30
    Top = 120
  end
  object IBQuery1: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select IDPODR, IDPAR, NAMEPODR from PODRAZ order by IDPAR')
    Left = 270
    Top = 270
  end
  object IBDatabaseINI1: TIBDatabaseINI
    UseAppPath = ipoPathToServer
    Section = 'Database Settings'
    Left = 400
    Top = 260
  end
end
