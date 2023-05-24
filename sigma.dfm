object dmSigma: TdmSigma
  OldCreateOrder = False
  Height = 536
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
    Left = 30
    Top = 20
  end
  object TR_Protocol: TIBTransaction
    DefaultDatabase = DB_Protocol
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 70
    Top = 20
  end
  object qTable1: TIBQuery
    Database = DB_Protocol
    Transaction = TR_Protocol
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select COD AS ID, DT AS EVENTTIME, IDBCP AS BCP, IDEVT AS EVENT,' +
        ' IDOBJ AS OBJ, IDSOURCE, IDZON AS ZONE, NAMEEVT, NAMEOBJ, NAMESO' +
        'URCE, NAMEZON, OBJTYPE, TSTYPE AS TCOTYPE, TYPESOURCE AS TSOURCE' +
        ' from TABLE1 where COD >0')
    Left = 20
    Top = 140
  end
  object dsTable1: TDataSource
    DataSet = qTable1
    Left = 20
    Top = 190
  end
  object DB_Work: TIBDatabase
    DatabaseName = 'C:\'#1056#1091#1073#1077#1078'\DB\R08WORK.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251'
      '')
    LoginPrompt = False
    DefaultTransaction = TR_Work
    ServerType = 'IBServer'
    Left = 140
    Top = 20
  end
  object TR_Work: TIBTransaction
    DefaultDatabase = DB_Work
    Params.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    Left = 180
    Top = 20
  end
  object IBQuery2: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select  IDBCP, IDZONE AS USR, FAMIL, IME, OTC, PODR from USR')
    Left = 100
    Top = 140
  end
  object DataSource2: TDataSource
    DataSet = IBQuery2
    Left = 100
    Top = 190
  end
  object IBQuery3: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select IDPODR, NAMEPODR from PODRAZ')
    Left = 140
    Top = 140
  end
  object DataSource3: TDataSource
    DataSet = IBQuery3
    Left = 140
    Top = 190
  end
  object IBQuery4: TIBQuery
    Database = DB_Protocol
    Transaction = TR_Protocol
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select COD AS ID, DT AS EVENTTIME, IDBCP AS BCP, IDEVT AS EVENT,' +
        ' IDOBJ AS OBJ, IDSOURCE, IDZON AS ZONE, NAMEEVT, NAMEOBJ, NAMESO' +
        'URCE, NAMEZON, OBJTYPE, TSTYPE AS TCOTYPE, TYPESOURCE AS TSOURCE' +
        ' from TABLE1 ROWS 10')
    Left = 190
    Top = 140
  end
  object DataSource4: TDataSource
    DataSet = IBQuery4
    Left = 190
    Top = 190
  end
  object qConfig: TIBQuery
    Database = DB_Work
    Transaction = TR_Work
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select * from CONFIG')
    Left = 240
    Top = 140
  end
  object sConfig: TDataSource
    DataSet = qConfig
    Left = 240
    Top = 190
  end
  object IBEvents1: TIBEvents
    AutoRegister = True
    Database = DB_Work
    Events.Strings = (
      'POST_YYYY')
    Registered = False
    OnEventAlert = IBEvents1EventAlert
    Left = 290
    Top = 190
  end
  object IBScript1: TIBScript
    Database = DB_Work
    Transaction = TR_Work
    Terminator = ';'
    Script.Strings = (
      
        '/***************************************************************' +
        '***************/'
      
        '/***               Generated by IBExpert 10.05.2023 18:32:30    ' +
        '            ***/'
      
        '/***************************************************************' +
        '***************/'
      ''
      
        '/***************************************************************' +
        '***************/'
      
        '/***      Following SET SQL DIALECT is just for the Database Com' +
        'parer       ***/'
      
        '/***************************************************************' +
        '***************/'
      'SET SQL DIALECT 3;'
      ''
      ''
      ''
      
        '/***************************************************************' +
        '***************/'
      
        '/***                                 Tables                     ' +
        '            ***/'
      
        '/***************************************************************' +
        '***************/'
      ''
      ''
      ''
      'CREATE TABLE YYYYY ('
      '    IDOBJ  INTEGER,'
      '    IDPR   INTEGER'
      ');'
      ''
      ''
      ''
      ''
      
        '/***************************************************************' +
        '***************/'
      
        '/***                                Triggers                    ' +
        '            ***/'
      
        '/***************************************************************' +
        '***************/'
      ''
      ''
      ''
      'SET TERM ^ ;'
      ''
      ''
      ''
      
        '/***************************************************************' +
        '***************/'
      
        '/***                          Triggers for tables               ' +
        '            ***/'
      
        '/***************************************************************' +
        '***************/'
      ''
      ''
      ''
      '/* Trigger: YYYYY_BI0 */'
      'CREATE OR ALTER TRIGGER YYYYY_BI0 FOR YYYYY'
      'ACTIVE AFTER INSERT POSITION 14'
      'AS'
      'begin'
      '  /* Trigger text */'
      'end'
      '^'
      ''
      'SET TERM ; ^'
      ''
      ''
      ''
      
        '/***************************************************************' +
        '***************/'
      
        '/***                               Privileges                   ' +
        '            ***/'
      
        '/***************************************************************' +
        '***************/')
    Left = 290
    Top = 140
  end
  object IBQuery5: TIBQuery
    Database = DB_Protocol
    Transaction = TR_Protocol
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select COD AS ID, DT AS EVENTTIME, IDBCP AS BCP, IDEVT AS EVENT,' +
        ' IDOBJ AS OBJ, IDSOURCE, IDZON AS ZONE, NAMEEVT, NAMEOBJ, NAMESO' +
        'URCE, NAMEZON, OBJTYPE, TSTYPE AS TCOTYPE, TYPESOURCE AS TSOURCE' +
        ' from TABLE1')
    Left = 20
    Top = 260
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\'#1056#1091#1073#1077#1078'\DB\Protocol\PROTOCOL.GDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 230
    Top = 320
  end
end
