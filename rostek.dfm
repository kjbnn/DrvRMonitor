object dmRostek: TdmRostek
  OldCreateOrder = False
  Height = 386
  Width = 469
  object DB_Techbase: TIBDatabase
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251'
      'sql_role_name=PASSBUROEMPLOYEE')
    LoginPrompt = False
    DefaultTransaction = TR_Techbase
    ServerType = 'IBServer'
    SQLDialect = 1
    Left = 48
    Top = 24
  end
  object TR_Techbase: TIBTransaction
    DefaultDatabase = DB_Techbase
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 48
    Top = 70
  end
  object IBQuery1: TIBQuery
    Database = DB_Techbase
    Transaction = TR_Techbase
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select COD AS ID, DT AS EVENTTIME, IDBCP AS BCP, IDEVT AS EVENT,' +
        ' IDOBJ AS OBJ, IDSOURCE, IDZON AS ZONE, NAMEEVT, NAMEOBJ, NAMESO' +
        'URCE, NAMEZON, OBJTYPE, TSTYPE AS TCOTYPE, TYPESOURCE AS TSOURCE' +
        ' from TABLE1')
    Left = 92
    Top = 224
  end
  object DataSource1: TDataSource
    DataSet = IBQuery1
    Left = 92
    Top = 288
  end
  object DB_Passbase: TIBDatabase
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251'
      '')
    LoginPrompt = False
    DefaultTransaction = TR_Passbase
    ServerType = 'IBServer'
    SQLDialect = 1
    Left = 124
    Top = 24
  end
  object TR_Passbase: TIBTransaction
    DefaultDatabase = DB_Passbase
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 124
    Top = 70
  end
end
