unit Process;

interface

uses
  System.Classes, SharedBuffer;

type
  TSigmaOperation = (OP_NONE, OP_SYNC_CONFIG, OP_START_EVENT, OP_NEXT_EVENT,
    OP_NEXT_ONE_EVENT, OP_STOP_EVENT);

  TSrc = (SRC_NONE, SRC_DB_TB, SRC_DB_PB, SRC_DB_WORK, SRC_DB_PROTOCOL,
    SRC_TR_TB_R, SRC_TR_TB_W, SRC_TR_PB_R, SRC_TR_PB_W, SRC_TR_WORK_R,
    SRC_TR_PROTOCOLR);

  TFieldType = (FT_LONGINT, FT_STRING);

  TTransactionType = (TR_NONE, TR_C, TR_CR, TR_RB);

  TProcess = class(TThread)
  private
  protected
    logStr: String;
    mes: KSBMES;
    Users: TList;

    procedure Execute; override;
    procedure StartEvent;
    procedure NextEvent;
    procedure EventHandler(netDevice, idBcp: word; dt: TDateTime; objType: word;
      idObj: LongInt; idZone, typeSource, idSource, idIvent, tsType: Integer;
      var mes: KSBMES);
    procedure GetCard(idBcp, IdUsr: word; out Facility: Byte; out Card: word);
    procedure CleanConfig;
    procedure GetBCPElements;
    procedure GetPodraz;
    procedure GetDemand;
    procedure ClearLUsers;
    function GetLUser(number: word): Pointer;
    procedure GetUsr;
    procedure UpdateElementGroup;
    procedure StartTransaction(Db: TSrc; Tr: TSrc);
    procedure EndTransaction(Tr: TSrc; How: TTransactionType);
    function GetId(Db: TSrc; Expression, Field: String;
      FieldType: TFieldType = FT_LONGINT): Variant;
    procedure QueryExec(Db: TSrc; Expression: String);
    procedure Log;
    procedure Send;
  end;

function ValToStr(var m: array of Byte): String;

const
  CU_MAX = 1024;
  ZN_MAX = 1024;
  PodrazTable = 'RM$PODRAZ';
  UsrTable = 'RM$USR';
  UsrGrTable = 'RM$USR_GR';

var
  TestSigmaDb: Int64 = 0;
  SigmaOperation: TSigmaOperation = OP_NONE; // need check
  DemandElement: Int64 = 0;
  CurDemand: Int64 = 0;
  Err: word;

implementation

uses
  sigma, main, Sysutils, rostek, TypInfo, Variants,
  constants, connection, System.Types;

{ TProcess }
procedure TProcess.Execute;
var
  mode: Integer;

begin
  NameThreadForDebugging('Process');
  Users := TList.Create;

  while not Terminated do
    try

      case SigmaOperation of

        OP_NONE:
          begin
            TryStrToInt(fmain.vle1.Values[pWORK_MODE], mode);
            case mode of
              0:
                begin
                  SigmaOperation := OP_NONE;
                  CleanConfig;
                end;
              1:
                SigmaOperation := OP_SYNC_CONFIG;
            else
              SigmaOperation := OP_START_EVENT;
            end;
          end;

        OP_SYNC_CONFIG:
          begin

            Err := 6;
            GetBCPElements;
            Err := 7;
            GetPodraz;
            Err := 8;
            GetDemand;
            Err := 9;
            GetUsr;

            UpdateElementGroup;
            {
              s:TMemoryStream;
              a:array [0..31] of Byte;
              begin
              S:= TMemoryStream.Create;
              IBTable1.Edit;
              a[0]:=127; a[1]:=0; a[2]:=0; a[3]:=1;
              s.Write(a, 4);
              (IBTable1.FieldByName('FBLOB') as TBlobField).LoadFromStream(s);
              IBTable1.Post;
              S.Destroy;
              IBTransaction1.CommitRetaining;
              end;
            }
            SigmaOperation := OP_START_EVENT;
          end;

        OP_START_EVENT:
          begin
            StartEvent;
            SigmaOperation := OP_NEXT_EVENT;
          end;

        OP_NEXT_EVENT:
          begin
            NextEvent;
            inc(TestSigmaDb);
            sleep(1000);
          end;
      end;

      sleep(100);
    except
      on E: Exception do
      begin
        logStr := 'Exception: ' + GetEnumName(TypeInfo(TSigmaOperation),
          ord(SigmaOperation)) + ' -(' + Err.ToString + ')-> ' + E.Message;
        Synchronize(Log);
        dmSigma.DB_Protocol.Close;
        dmSigma.DB_Work.Close;
        dmRostek.dPB.Close;
        dmRostek.dTB.Close;
        sleep(10000);
      end;
    end;

end;

{$REGION 'hi'}

procedure TProcess.StartEvent;
var
  i: word;
begin
  if curEvent = 0 then
  begin
    for i := 1 to 2 do
    begin
      with dmSigma.qEvent do
      begin
        StartTransaction(SRC_DB_PROTOCOL, SRC_TR_PROTOCOLR);
        Close;
        // SQL.Text := 'select max(cod) from TABLE1';
        SQL.Text := 'select max(COD) as MAXCOD from TABLE1';
        Open;
        if not eof then
          curEvent := FieldByName('MAXCOD').AsInteger;
        Close;
        EndTransaction(SRC_TR_PROTOCOLR, TR_C);
      end;
    end;
  end;

end;

procedure TProcess.NextEvent;
begin
  with dmSigma.qEvent do
  begin
    StartTransaction(SRC_DB_PROTOCOL, SRC_TR_PROTOCOLR);
    Close;
    SQL.Text := 'select COD, DT, IDBCP, IDEVT' +
      ', IDOBJ, IDSOURCE, IDZON, NAMEEVT, NAMEOBJ, NAMESOURCE' +
      ', NAMEZON, OBJTYPE, TSTYPE, TYPESOURCE from TABLE1' + ' where COD > ' +
      IntToStr(curEvent) + ' and IDBCP in (0, 11829) order by COD';
    Open;

    while not eof do
    begin

      case SigmaOperation of
        OP_SYNC_CONFIG:
          break;

        OP_NEXT_ONE_EVENT:
          begin
            SigmaOperation := OP_STOP_EVENT;
          end;

        OP_STOP_EVENT:
          begin
            sleep(100);
            Continue;
          end;

      end;

      EventHandler(fmain.ModuleNetDevice, FieldByName('IDBCP').AsInteger, // bcp
        FieldByName('DT').AsDateTime, // DATE
        FieldByName('OBJTYPE').AsInteger, // TC, US, PC
        FieldByName('IDOBJ').AsInteger, // значение TC, US, PC
        FieldByName('IDZON').AsInteger, // номер зоны в Ростэк
        FieldByName('TYPESOURCE').AsInteger,
        // Тип (инициатора события) soure (0-никто, 1-пользователь, 2-система, 4-скрипт, 6-ПЭВМ, 9-неисправность, 11-АРМ, 61-БЦП s/n
        FieldByName('IDSOURCE').AsInteger, // ID source
        FieldByName('IDEVT').AsInteger, // Номер эвента
        FieldByName('TSTYPE').AsInteger, // тип TC (1-9), 0-не ТС
        mes);

      if mes.Code > 0 then
        Synchronize(Send);

      curEvent := FieldByName('COD').AsLargeInt;

      case FieldByName('TSTYPE').AsInteger of
        0:
          case FieldByName('OBJTYPE').AsInteger of
            1:
              logStr := 'Зона';
            3:
              logStr := 'Сетевое устройство';
            4:
              logStr := 'Пользователь ';
            63:
              logStr := 'Рубеж Сервер ';
          end;
        1 .. 4:
          logStr := 'Шлейф';
        5:
          logStr := 'Реле';
        6:
          logStr := 'Точка доступа';
        7:
          logStr := 'Терминал';
      end;
      logStr := Format('%s %s: %s -> %s',
        [DateTimeToStr(FieldByName('DT').AsDateTime), logStr,
        FieldByName('NAMEOBJ').AsString, FieldByName('NAMEEVT').AsString]);
      if length(FieldByName('NAMESOURCE').AsString) > 2 then
        logStr := logStr + '  (' + FieldByName('NAMESOURCE').AsString + ')';
      Synchronize(Log);

      Next;
      sleep(1);
    end;

    EndTransaction(SRC_TR_PROTOCOLR, TR_C);
  end;
end;

procedure TProcess.EventHandler(netDevice, idBcp: word; dt: TDateTime;
  objType: word; idObj: LongInt; idZone, typeSource, idSource, idIvent,
  tsType: Integer; var mes: KSBMES);

begin
  Init(mes);
  mes.Proga := $FFFF;
  mes.SendTime := dt;
  mes.SysDevice := 0;

  mes.netDevice := netDevice;
  mes.BigDevice := idBcp;
  mes.NumDevice := 0;
  {
    _______ _______ _______ _______ _______
    |       |       |       |       |       |
    | Type	|  Net	|  Big  | Small | Part  |
    |_______|_______|_______|_______|_______|
    |       |       |       |       |       |
    |   +   |   +   |   +   |       |       |   Драйвер
    |   +   |   +   |       |       |       |   Рубеж-монитор
    |   +   |   +   |   +   |       |   +   |   БЦП
    |   +   |   +   |   +   |   +   |       |   Zn/СУ/ТС/Gr/UD/TZ/User/Script
    |_______|_______|_______|_______|_______|
  }

  {
    Блокирование

  }

  case tsType of
    0:
      begin
        case objType of
          1:
            mes.typeDevice := 6; // Зона
          3:
            mes.typeDevice := 9; // СУ
          4:
            mes.typeDevice := 4; // Пользователь БЦП
          63:
            mes.typeDevice := 4; // Рубеж Сервер
        end;

      end;
    1 .. 4:
      begin
        mes.typeDevice := 5; // ШС
        mes.SmallDevice := (idObj shr 16) - $7FFF;
        mes.NumDevice := mes.SmallDevice;
      end;
    5:
      begin
        mes.typeDevice := 7; // Реле
        mes.SmallDevice := (idObj shr 16) - $7FFF;
        mes.NumDevice := mes.SmallDevice;
      end;
    6:
      begin
        mes.SysDevice := 1;
        mes.typeDevice := { 10 } 2; // ТД
        mes.SmallDevice := (idObj shr 16) - $7FFF;
        mes.NumDevice := mes.SmallDevice;
      end;
    7:
      begin
        mes.typeDevice := 8; // Терминал
        mes.SmallDevice := (idObj shr 16) - $7FFF;
        mes.NumDevice := mes.SmallDevice;
      end;
    9:
      begin
        mes.typeDevice := 12; // АСПТ
        mes.SmallDevice := (idObj shr 16) - $7FFF;
        mes.NumDevice := mes.SmallDevice;
      end;

  end; // case

  case typeSource of
    0: // Само
      ;
    1: // Пользователь
      mes.User := abs(idSource);
    2: // Система
      ;
    4: // Скрипт
      mes.User := abs(idSource);
    6: // ПЭВМ
      ;
    9: // Код неисправности (Потеря связи с оборудованием)
      ;
    11: // АРМ
      mes.User := abs(idSource);
    61: // БЦП
      mes.User := abs(idSource);
  end;

  case (idIvent and $FFFF) of
    $101:
      mes.Code := R8_SH_ARMED;
    $102:
      mes.Code := R8_SH_DISARMED;
    $103:
      mes.Code := R8_SH_ALARM;
    $104:
      mes.Code := R8_SH_CHECK;
    $105:
      mes.Code := R8_SH_READY;
    $106:
      mes.Code := R8_SH_NOTREADY;
    $107:
      mes.Code := R8_SH_RESET;
    $108:
      mes.Code := R8_SH_BYPASS;
    $109:
      mes.Code := R8_SH_INDELAY;
    $10A:
      mes.Code := R8_SH_OUTDELAY;
    $10B:
      mes.Code := R8_SH_WAITFORREADY;
    $10C:
      mes.Code := R8_SH_WAITFORREADYCANCEL;
    $10D:
      ;
    $10E:
      ;
    $10F:
      ;
    $201:
      mes.Code := R8_SH_ALARM;
    $202:
      mes.Code := R8_SH_CHECK;
    $203:
      mes.Code := R8_SH_RESET;
    $204:
      mes.Code := R8_SH_READY;
    $205:
      mes.Code := R8_SH_NOTREADY;
    $206:
      mes.Code := R8_SH_TEST;
    $207:
      mes.Code := R8_SH_TESTPASSEDOK;
    $208:
      mes.Code := R8_SH_TESTTIMEOUT;
    $301:
      mes.Code := R8_SH_FIRE_ALARM;
    $302:
      mes.Code := R8_SH_CHECK;
    $303:
      mes.Code := R8_SH_FIRE_ATTENTION;
    $304:
      mes.Code := R8_SH_RESET;
    $305:
      mes.Code := R8_SH_READY;
    $306:
      mes.Code := R8_SH_NOTREADY;
    $401:
      mes.Code := R8_TECHNO_AREA0;
    $402:
      mes.Code := R8_TECHNO_AREA1;
    $403:
      mes.Code := R8_SH_CHECK;
    $404:
      begin
        mes.Code := R8_TECHNO_AREA0;
        Synchronize(Send);
        mes.Code := R8_TECHNO_ALARM;
      end;
    $405:
      begin
        mes.Code := R8_TECHNO_AREA1;
        Synchronize(Send);
        mes.Code := R8_TECHNO_ALARM;
      end;
    $406:
      mes.Code := R8_TECHNO_AREA2;
    $407:
      mes.Code := R8_TECHNO_AREA3;
    $408:
      begin
        mes.Code := R8_TECHNO_AREA2;
        Synchronize(Send);
        mes.Code := R8_TECHNO_ALARM;
      end;
    $409:
      begin
        mes.Code := R8_TECHNO_AREA3;
        Synchronize(Send);
        mes.Code := R8_TECHNO_ALARM;
      end;
    $501:
      mes.Code := R8_RELAY_1;
    $502:
      mes.Code := R8_RELAY_0;
    $503:
      mes.Code := R8_RELAY_WAITON;
    $504:
      mes.Code := R8_RELAY_CHECK;
    $601:
      begin
        mes.Code := { R8_AP_IN } { SUD_ACCESS_GRANTED } SUD_OK_ENTER;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $602:
      begin
        mes.Code := { R8_AP_OUT }  { SUD_ACCESS_GRANTED } SUD_OK_ENTER;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $603:
      begin
        mes.Code := { R8_AP_PASSENABLE } SUD_ACCESS_GRANTED;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $604:
      mes.Code := { R8_AP_DOOROPEN } SUD_DOOR_OPEN;
    $605:
      mes.Code := { R8_AP_DOORNOCLOSED } SUD_HELD;
    $606:
      mes.Code := { R8_AP_DOORALARM } SUD_FORCED;
    $607:
      mes.Code := { R8_AP_DOORCLOSE; } SUD_DOOR_CLOSE;
    $608:
      begin
        mes.Code := { R8_AP_BLOCKING } RIC_MODE;
        mes.Level := 0;
        mes.Partion := 6;
      end;
    $609:
      begin
        mes.Code := { R8_AP_DEBLOCKING } RIC_MODE;
        mes.Level := 4;
        mes.Partion := 5;
      end;
    $60A:
      mes.Code := { R8_AP_EXITBUTTON } SUD_GRANTED_BUTTON;
    $60B:
      begin
        mes.Code := RIC_MODE;
        mes.Level := 0;
        mes.Partion := 1;
      end;
    $60C:
      begin
        mes.Code := R8_AP_AUTHORIZATIONERROR;
        if True then // need resolve
          mes.Code := SUD_NO_CARD
        else
          mes.Code := SUD_BAD_PIN;
      end;
    $60D:
      mes.Code := { R8_AP_CODEFORGERY } SUD_ACCESS_CHOOSE;
    $60E:
      begin
        mes.Code := R8_AP_REQUESTPASS;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $60F:
      mes.Code := R8_AP_FORCING;
    $610:
      begin
        mes.Code := { R8_AP_APBERROR } SUD_BAD_APB;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $611:
      begin
        mes.Code := { R8_AP_ACCESSGRATED } SUD_ACCESS_GRANTED;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $612:
      mes.Code := R8_AP_ACCESSTIMEOUT; // 9518
    $701:
      mes.Code := R8_TERM_REQUEST;
    $702:
      mes.Code := R8_TERM_BLOCKING;
    $703:
      mes.Code := R8_TERM_AUTHORIZATIONERROR;
    $704:
      mes.Code := R8_TERM_CODEFORGERY;
    $705:
      mes.Code := R8_TERM_RESET;
    $706:
      mes.Code := R8_TERM_USERCOMMAND;
    $801:
      ;
    $802:
      ;
    $803:
      ;
    $805:
      ;
    $806:
      ;
    $807:
      ;
    $808:
      ;
    $809:
      ;
    $80A:
      ;
    $80B:
      ;
    $80C:
      ;
    $80D:
      ;
    $80E:
      ;
    $80F:
      ;
    $810:
      ;
    $811:
      ;
    $812:
      ;
    $813:
      ;
    $814:
      ;
    $901:
      mes.Code := R8_ASPT_AUTOMATICON;
    $902:
      mes.Code := R8_ASPT_AUTOMATICOFF;
    $903:
      mes.Code := R8_ASPT_DOOROPEN;
    $904:
      mes.Code := R8_ASPT_DOORCLOSE;
    $905:
      mes.Code := R8_ASPT_AUTOMATICSTART;
    $906:
      mes.Code := R8_ASPT_REMOTESTART;
    $907:
      mes.Code := R8_ASPT_MANUALSTART;
    $908:
      mes.Code := R8_ASPT_CANCELSTART;
    $909:
      mes.Code := R8_ASPT_EVACUATIONDELAY;
    $90A:
      mes.Code := R8_ASPT_FIREEXTINGUISHING;
    $90B:
      mes.Code := R8_ASPT_FIREEXTINGUISHINGCOMPLETE;
    $90C:
      mes.Code := R8_ASPT_AUTHORIZATIONERROR;
    $90D:
      mes.Code := R8_ASPT_TIMEOUT;
    $90E:
      mes.Code := R8_ASPT_OUTLAUNCHSUCCESS;
    $90F:
      mes.Code := R8_ASPT_OUTLAUNCHERROR;
    $910:
      mes.Code := R8_ASPT_TROUBLE;
    $911:
      mes.Code := R8_ASPT_SDU;
    $912:
      mes.Code := R8_ASPT_WEIGHTSENSOR;
    $913:
      mes.Code := R8_ASPT_RESET;
    $914:
      mes.Code := R8_ASPT_FIRE;
    $A01:
      mes.Code := R8_VIDEO_ARM;
    $A02:
      mes.Code := R8_VIDEO_DISARM;
    $A03:
      mes.Code := R8_VIDEO_ALARM;
    $A04:
      mes.Code := R8_VIDEO_TROUBLE;
    $A05:
      mes.Code := R8_VIDEO_STARTRECORD;
    $A06:
      mes.Code := R8_VIDEO_STOPRECORD;
    $2001:
      mes.Code := R8_CU_CONNECT_OFF;
    $2002:
      mes.Code := R8_CU_CONNECT_ON;
    $3F01:
      mes.Code := R8_CONNECT_FALSE;
    $3F02:
      mes.Code := R8_CONNECT_TRUE;
    $8304:
      case tsType of
        1 .. 4:
          mes.Code := R8_SH_NORIGTH;
        5:
          mes.Code := R8_RELAY_NORIGTH;
        6:
          begin
            mes.Code := SUD_BAD_LEVEL { R8_AP_NORIGTH };
            GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
          end;
        7:
          mes.Code := R8_TERM_NORIGTH;
        9:
          mes.Code := R8_ASPT_NORIGTH;
      end;
    $8280 .. $8282, // СРУ Зоны
    $8380 .. $8382, // СРУ ТС
    $8480 .. $8482, // СРУ СУ
    $8580 .. $8582: // СРУ User
      begin
        fmain.UpdateConfigTimer.Enabled := False;
        fmain.UpdateConfigTimer.Enabled := True;
        logStr := 'Запрос новой конфигурации... ';
        Synchronize(Log);
      end;

  end;

end;

procedure TProcess.Send;
begin
  fmain.Send(mes);
end;

procedure TProcess.CleanConfig;
var
  s: String;
begin
  s := Format
    ('update element set PARENT_ID=null where (NET_DEVICE=%d) and ((SYSTEM_DEVICE=0) '
    + 'and(TYPE_DEVICE in (4,5,6,7,8,9,10,11)) or (SYSTEM_DEVICE=1)and(TYPE_DEVICE in (2)))',
    [fmain.ModuleNetDevice]);
  QueryExec(SRC_DB_TB, s);

  s := Format
    ('delete from element where (NET_DEVICE=%d) and ((SYSTEM_DEVICE=0) ' +
    'and(TYPE_DEVICE in (4,5,6,7,8,9,10,11)) or (SYSTEM_DEVICE=1)and(TYPE_DEVICE in (2)))',
    [fmain.ModuleNetDevice]);
  QueryExec(SRC_DB_TB, s);

  s := Format('delete from %s', [PodrazTable]);
  QueryExec(SRC_DB_PB, s);

  s := Format('delete from %s', [UsrTable]);
  QueryExec(SRC_DB_PB, s);

  s := Format('delete from %s', [UsrGrTable]);
  QueryExec(SRC_DB_TB, s);
end;

procedure TProcess.GetBCPElements;
var
  ConfigArray: TArray<Byte>; // TBytes;
  TotalGr, TotalNu, TotalUser: word;
  s: String;

  procedure PrintConfig(bcpNumber: word; a: TArray<Byte>);
  var
    tf: Textfile;
    i: Longword;
    b: Byte;
  begin
    AssignFile(tf, Format('.\blob%d.txt', [bcpNumber])); // need resolve
    try
      ReWrite(tf);
      WriteLn(tf,
        #13'----------------------------------------------------------');
      WriteLn(tf, 'БЦП: ' + bcpNumber.ToString + '  data: ' + length(a)
        .ToString);
      WriteLn(tf, '----------------------------------------------------------');
      i := 1;
      for b in ConfigArray do
      begin
        case (i mod 16) of
          0:
            if i > 0 then
              WriteLn(tf, b.ToHexString);
        else
          Write(tf, b.ToHexString + '-');
        end;
        inc(i);
      end;

    finally
      CloseFile(tf);
    end;
  end;

  function ParseConfig(a: TArray<Byte>): Boolean;
  type
    TelementParse = (EP_NONE, EP_ZONE, EP_TC, EP_GR, EP_NU, EP_USER, EP_SEARCH);

  VAR
    DrvParentID, BCPParentID, ZoneParentID: LongInt;
    curLen, txtLen: LongInt; // word;
    TotalZone: word;
    ep: TelementParse;
    curBCP: word;
    User: ^TUser;

    function StringToBytes(const Value: WideString): TBytes;
    begin
      SetLength(result, length(Value) * SizeOf(WideChar));
      if length(result) > 0 then
        Move(Value[1], result[0], length(result));
    end;

    function BytesToString(const Value: TBytes): WideString;
    begin
      SetLength(result, length(Value) div SizeOf(WideChar));
      if length(result) > 0 then
        Move(Value[0], result[1], length(Value));
    end;

    procedure CreateUsrGroup(idBcp: word);
    var
      s: String;
      exist: Boolean;
      UserGroup: Integer;
    begin
      exist := False;
      try
        s := 'select count(*) from ' + UsrGrTable;
        GetId(SRC_DB_TB, s, 'COUNT');
        exist := True;
        logStr := 'Table ' + UsrGrTable + ' exist';
      except
        logStr := 'Table ' + UsrGrTable + ' not exist';
      end;
      Synchronize(Log);

      if not(exist) then
        try
          s := 'create table ' + UsrGrTable + ' (BCP Integer NOT NULL,' +
            ' USER_GROUP Integer NOT NULL);';
          QueryExec(SRC_DB_TB, s);
          logStr := 'Table ' + UsrGrTable + ' was created';
          Synchronize(Log);
        except
        end;

      UserGroup := GetId(SRC_DB_TB,
        Format('select USER_GROUP from %s where BCP=%d', [UsrGrTable, idBcp]),
        'USER_GROUP');
      if UserGroup = 0 then
        UserGroup := GetId(SRC_DB_TB,
          'select GEN_ID(GEN_USER_GROUP_ID, 1) from RDB$DATABASE', 'GEN_ID');

      s := Format('update or insert into %s (BCP, USER_GROUP) ' +
        'values (%d, %d) matching (BCP);', [UsrGrTable, idBcp, UserGroup]);
      QueryExec(SRC_DB_TB, s);

      s := Format('update or insert into USER_GROUP (GROUP_ID, GROUP_TITLE) ' +
        'values (%d, ''%s %d'') matching (GROUP_ID);',
        [UserGroup, 'Пользователи БЦП', idBcp]);
      QueryExec(SRC_DB_TB, s);
    end;

    procedure CreateBCP(a: TArray<Byte>);
    var
      id: LongInt;
      s: String;
    begin
      curBCP := a[0] + a[1] shl 8;
      logStr := 'БЦП ' + IntToStr(curBCP);
      Synchronize(Log); //
      id := GetId(SRC_DB_TB,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=4 and SYSTEM_DEVICE=0 and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=0',
        [fmain.ModuleNetDevice, a[0] + a[1] shl 8]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_DB_TB,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, DrvParentID, 110, 4, 0, fmain.ModuleNetDevice, a[0] + a[1] shl 8,
        0, logStr]);
      QueryExec(SRC_DB_TB, s);
      BCPParentID := id;
      //
      CreateUsrGroup(curBCP);
    end;

    procedure CreateZone(a: TArray<Byte>);
    var
      ar: TBytes;
      len1, len2: word;
      id: LongInt;
      zn: Integer;
      s: String;
    begin
      len1 := SizeOf(TZone);
      len2 := a[len1] + (a[len1 + 1] shl 8);
      ar := Copy(a, len1 + 2 + 2, len2 - 2);
      logStr := Format('Зона %s: %s', [ValToStr(a[1]), BytesToString(ar)]);
      // Synchronize(Log);
      id := 0;
      if TryStrToInt(ValToStr(a[1]), zn) then
        id := GetId(SRC_DB_TB,
          Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=6 and SYSTEM_DEVICE=0 and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=%d',
          [fmain.ModuleNetDevice, curBCP, zn]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_DB_TB,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, BCPParentID, 112, 6, 0, fmain.ModuleNetDevice, curBCP, zn,
        logStr]);
      QueryExec(SRC_DB_TB, s);
      ZoneParentID := id;
    end;

    procedure CreateTC(a: TArray<Byte>);
    var
      ar: TBytes;
      len1, len2: word;
      id, categoryId, typeDevice, SysDevice, tc: word;
      s: String;
    begin
      len1 := SizeOf(TTc);
      len2 := a[len1] + (a[len1 + 1] shl 8);
      ar := Copy(a, len1 + 2 + 2, len2 - 2);
      tc := a[0] + a[1] shl 8;
      tc := tc - $7FFF;

      case a[2] of
        1 .. 4:
          begin
            SysDevice := 0;
            categoryId := 111;
            typeDevice := 5;
            logStr := Format('Шлейф %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        5:
          begin
            SysDevice := 0;
            categoryId := 115;
            typeDevice := 7;
            logStr := Format('Реле %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        6:
          begin
            SysDevice := 1;
            categoryId := 13;
            typeDevice := 2;
            logStr := Format('Сч %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        7:
          begin
            SysDevice := 0;
            categoryId := 117;
            typeDevice := 8;
            logStr := Format('Терминал %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
      else
        begin
          SysDevice := 0;
          categoryId := 0;
          typeDevice := 0;
          logStr := 'Неизвестныйй ТС'
        end;

      end;
      // Synchronize(Log);

      id := GetId(SRC_DB_TB,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=%d and SYSTEM_DEVICE=%d and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=%d',
        [typeDevice, SysDevice, fmain.ModuleNetDevice, curBCP, tc]),
        'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_DB_TB,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');

      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, ZoneParentID, categoryId, typeDevice, SysDevice,
        fmain.ModuleNetDevice, curBCP, tc, logStr]);
      QueryExec(SRC_DB_TB, s);
    end;

    procedure CreateGr(a: TArray<Byte>);
    begin
      //
    end;

    procedure CreateNu(a: TArray<Byte>);
    begin
      //
    end;

    procedure CreateUser(a: TArray<Byte>);
    begin
      //
    end;

  // -------------------------
  begin
    result := False;
    if not TryStrToInt(fmain.vle1.Values[pPARENT_ELEMENT], DrvParentID) then
      exit;

    // start
    if (length(a) < 9) then
      exit;
    if (a[0] <> $75) or (a[1] <> $01) then
      exit;
    Delete(a, 0, 2);
    CreateBCP(a);
    Delete(a, 0, 3);
    TotalZone := (a[0] + a[1] shl 8);
    Delete(a, 0, 4);
    //
    logStr := Format('Probably Gr:%d, Nu:%d, User:%d',
      [TotalGr, TotalNu, TotalUser]);
    Synchronize(Log);
    //
    ep := EP_ZONE;
    while (TotalZone > 0) or (ep <> EP_NONE) do
      case ep of

        EP_ZONE:
          begin
            curLen := SizeOf(TZone);
            txtLen := a[curLen] + (a[curLen + 1] shl 8);
            curLen := curLen + 2 + txtLen;
            if (curLen > length(a)) then
              exit;
            CreateZone(a);
            Delete(a, 0, curLen);
            dec(TotalZone);
            ep := EP_SEARCH;
          end;

        EP_SEARCH:
          begin
            while (length(a) > 0) and (a[0] = 0) do
              Delete(a, 0, 1);
            if (a[0] = $FF) and (a[1] = $FF) then
            begin
              Delete(a, 0, 2);
              ep := EP_TC;
            end
            else if (a[1] = 0) and (a[2] = 0) and (a[3] = $FF) and (a[4] = $FF)
            then
            begin
              Delete(a, 0, 5);
              ep := EP_TC;
            end
            else if (a[1] = 0) and (a[2] = 0) and (a[3] = 0) and (a[4] = $FF)
              and (a[5] = $FF) then
            begin
              Delete(a, 0, 6);
              ep := EP_TC;
            end
            else if TotalZone > 0 then
              ep := EP_ZONE
            else
              ep := EP_NONE;
          end;

        EP_TC:
          begin
            curLen := SizeOf(TTc);
            txtLen := a[curLen] + (a[curLen + 1] shl 8);
            curLen := curLen + 2 + txtLen;
            if (curLen > length(a)) then
              exit;
            CreateTC(a);
            Delete(a, 0, curLen);
            ep := EP_SEARCH;
          end;
      end;

    // start
    if (length(a) < 9) then
      exit;

    if (TotalGr > 0) then
    begin
      TotalGr := a[0];
      Delete(a, 0, TotalGr * SizeOf(TGr) + 1);
    end;

    while (TotalNu > 0) do
    begin
      curLen := a[0] + (a[1] shl 8) + (a[2] shl 16) + (a[3] shl 24);
      Delete(a, 0, curLen * SizeOf(TNu) + 4);
      TotalNu := TotalNu - curLen;
      while (length(a) > 0) and (a[0] = 0) do
        Delete(a, 0, 1);
    end;

    TotalUser := a[0] + (a[1] shl 8) + (a[2] shl 16) + (a[3] shl 24);
    Delete(a, 0, 4);
    ClearLUsers;
    while (TotalUser > 0) do
    begin
      New(User);
      Move(a[0], User^, SizeOf(TUser));
      Users.Add(User);
      Delete(a, 0, SizeOf(TUser));
      dec(TotalUser);
    end;

  end;

begin
  try
    s := 'select count(*) from GRUP';
    TotalGr := GetId(SRC_DB_WORK, s, 'COUNT');
    s := 'select count(*) from SUS';
    TotalNu := GetId(SRC_DB_WORK, s, 'COUNT');
    s := 'select count(*) from USR';
    TotalUser := GetId(SRC_DB_WORK, s, 'COUNT');
  except
  end;

  with dmSigma.qConfig do
  begin
    StartTransaction(SRC_DB_WORK, SRC_TR_WORK_R);
    DisableControls;
    Close;
    SQL.Text := 'select * from CONFIG';
    Open;
    try
      while not eof do
      begin
        ConfigArray := FieldByName('BCPCONF').AsBytes;
        PrintConfig(FieldByName('IDBCP').AsInteger, ConfigArray);
        ParseConfig(ConfigArray);
        Next;
      end;
      EndTransaction(SRC_TR_WORK_R, TR_C);
    finally
      EnableControls;
    end;
    Err := 13;
  end;
end;

procedure TProcess.GetCard(idBcp, IdUsr: word; out Facility: Byte;
  out Card: word);
begin
  Facility := 0;
  Card := 0;

  with dmRostek.qPBUsr do
  begin
    StartTransaction(SRC_DB_PB, SRC_TR_PB_R);
    SQL.Text := 'select NETDEVICE, BIGDEVICE, BCP, USR, ' +
      'CARD, FACILITY, ROSTEK_OBJECT, ROSTEK_PASS from ' + UsrTable;
    Open;
    while not eof do
      if (idBcp = FieldByName('BCP').AsInteger) and
        (IdUsr = FieldByName('USR').AsInteger) and
        (not FieldByName('FACILITY').IsNull) and (not FieldByName('CARD').IsNull)
      then
      begin
        Facility := FieldByName('FACILITY').AsInteger;
        Card := FieldByName('CARD').AsInteger;
        break;
      end
      else
        Next;
    EndTransaction(SRC_TR_PB_R, TR_C);
  end;

end;

procedure TProcess.GetPodraz;
var
  exist: Boolean;
  s: String;
  id: Longword;
begin
  id := 0;

  exist := False;
  try
    StartTransaction(SRC_DB_PB, SRC_TR_PB_R);
    with dmRostek.qPBAnyR do
    begin
      Close;
      SQL.Text := Format('select * from ELEMENT where ELEMENT_ID=0', []);
      Open;
      if not eof then
        exist := True;
    end;
  finally
    EndTransaction(SRC_TR_PB_R, TR_C);
  end;
  if not exist then
  begin
    s := Format
      ('update or insert into ELEMENT (ELEMENT_ID, ELEMENT_TYPE_ID, ELEMENT_NAME, PASS_LIMIT, PASS_REAL) '
      + 'values (%d, %d, ''%s'', %d, %d) matching (ELEMENT_ID)',
      [id, 0, 'Организации', 0, 0]);
    QueryExec(SRC_DB_PB, s);
  end;

  exist := False;
  try
    s := 'select count(*) from ' + PodrazTable;
    GetId(SRC_DB_PB, s, 'COUNT');
    exist := True;
    logStr := 'Table ' + PodrazTable + ' exist';
  except
    logStr := 'Table ' + PodrazTable + ' not exist';
  end;
  Synchronize(Log);

  if not(exist) then
    try
      s := 'create table ' + PodrazTable + ' (NETDEVICE Integer NOT NULL,' +
        ' BIGDEVICE Integer NOT NULL,' + ' PODRAZ Integer NOT NULL,' +
        ' ROSTEK_ELEMENT Integer NOT NULL);';
      QueryExec(SRC_DB_PB, s);
      logStr := 'Table ' + PodrazTable + ' was created';
      Synchronize(Log);
    except
    end;

  StartTransaction(SRC_DB_WORK, SRC_TR_WORK_R);
  with dmSigma.qPodraz do
  begin
    Close;
    SQL.Text := 'select IDPODR, IDPAR, NAMEPODR from PODRAZ order by IDPAR';
    Open;
    while not eof do
    begin

      id := GetId(SRC_DB_PB,
        Format('select ROSTEK_ELEMENT from %s where NETDEVICE=%d and BIGDEVICE=%d and PODRAZ=%d',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDPODR').AsInteger]), 'ROSTEK_ELEMENT');
      if id = 0 then
        id := GetId(SRC_DB_PB,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      if DemandElement = 0 then
        DemandElement := id;

      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, ELEMENT_TYPE_ID, ELEMENT_NAME, PASS_LIMIT, PASS_REAL) '
        + 'values (%d, %d, %d, ''%s'', %d, %d) matching (ELEMENT_ID)',
        [id, 0, 0, Trim(FieldByName('NAMEPODR').AsString), 0, 0]);
      QueryExec(SRC_DB_PB, s);

      s := Format
        ('update or insert into %s (NETDEVICE, BIGDEVICE, PODRAZ, ROSTEK_ELEMENT) '
        + 'values (%d, %d, %d, %d) matching (ROSTEK_ELEMENT)',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDPODR').AsInteger, id]);
      QueryExec(SRC_DB_PB, s);
      Next;

    end;
  end;
  EndTransaction(SRC_TR_WORK_R, TR_C);

end;

procedure TProcess.GetDemand;
var
  s: String;
begin
  CurDemand := GetId(SRC_DB_PB,
    Format('select DEMAND_ID from DEMAND where ELEMENT_ID=%d and APPLICANT_ID=%d',
    [DemandElement, DemandElement]), 'DEMAND_ID');
  if CurDemand = 0 then
    CurDemand := GetId(SRC_DB_PB,
      'select GEN_ID(GEN_DEMAND_ID, 1) from RDB$DATABASE', 'GEN_ID');

  s := Format
    ('update or insert into DEMAND (DEMAND_ID, ELEMENT_ID, APPLICANT_ID) ' +
    'values (%d, %d, %d)', [CurDemand, DemandElement, DemandElement]);
  QueryExec(SRC_DB_PB, s);
  logStr := 'Use PB.Demand ' + CurDemand.ToString;
  Synchronize(Log);
end;

procedure TProcess.ClearLUsers;
begin
  while Users.Count > 0 do
  begin
    Dispose(Users.Last);
    Users.Remove(Users.Last);
  end;
end;

function TProcess.GetLUser(number: word): Pointer;
var
  i: word;
begin
  result := nil;
  for i := 1 to Users.Count do
    if TPUser(Users.Items[i - 1])^.id = number then
    begin
      result := Users.Items[i - 1];
      break;
    end;
end;

procedure TProcess.GetUsr;
var
  exist: Boolean;
  s: String;
  ido, ide, idp: Int64;
  idd: String;
  idemployee: Integer;
  UserGroup: Integer;
  CardStateId, PassStatusId: Byte;
  LUser: TPUser;

begin
  exist := False;
  try
    s := 'select count(*) from ' + UsrTable;
    GetId(SRC_DB_PB, s, 'COUNT');
    exist := True;
    logStr := 'Table ' + UsrTable + ' exist';
  except
    logStr := 'Table ' + UsrTable + ' not exist';
  end;
  Synchronize(Log);

  if not(exist) then
    try
      s := 'create table ' + UsrTable + ' (NETDEVICE Integer NOT NULL, ' +
        'BIGDEVICE Integer NOT NULL, ' + 'BCP Integer NOT NULL, ' +
        'USR Integer NOT NULL, ' + 'CARD Integer NOT NULL, ' +
        'FACILITY SMALLINT NOT NULL, ' + 'ROSTEK_OBJECT Integer NOT NULL, ' +
        'ROSTEK_PASS Integer NOT NULL);';
      QueryExec(SRC_DB_PB, s);
      logStr := 'Table ' + UsrTable + ' was created';
      Synchronize(Log);
    except
    end;

  StartTransaction(SRC_DB_WORK, SRC_TR_WORK_R);
  with dmSigma.qUsr do
  begin
    Close;
    SQL.Text :=
      'select sernum as IDBCP, u.IDZONE as IDUSR, FAMIL, IME, OTC, PODR, ' +
      'fcard as FACILITY, codcard as CARD, DOLG from USR as u join BCP as b ' +
      'on u.idbcp = b.idbcp left join usercart as uc ' +
      'on (b.sernum = uc.snbcp) and (u.idzone = uc.iduser) ' +
      'order by sernum, u.IDZONE';
    Open;
    while not eof do
    begin
      // id object in rostek
      ido := GetId(SRC_DB_PB,
        Format('select ROSTEK_OBJECT from %s where NETDEVICE=%d and BIGDEVICE=%d and BCP=%d and USR=%d',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger]),
        'ROSTEK_OBJECT');
      if ido = 0 then
        ido := GetId(SRC_DB_PB,
          'select GEN_ID(GEN_OBJECT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      {
        logStr := FieldByName('IDBCP').AsInteger.ToString + ' ' +
        FieldByName('IDUSR').AsInteger.ToString + ' ' +
        Trim(FieldByName('FAMIL').AsString) + ' ' +
        Trim(FieldByName('IME').AsString) + ' ' +
        Trim(FieldByName('OTC').AsString) + ' ' + FieldByName('PODR')
        .AsInteger.ToString;
        Synchronize(Log);
      }

      // id PB.podraz
      ide := GetId(SRC_DB_PB,
        Format('select ROSTEK_ELEMENT from %s where NETDEVICE=%d and BIGDEVICE=%d and PODRAZ=%d',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('PODR').AsInteger]), 'ROSTEK_ELEMENT');

      // add PB.object
      s := Format
        ('update or insert into OBJECT (OBJECT_ID, CLASS_ID, ELEMENT_ID) ' +
        'values (%d, %d, %d) matching (OBJECT_ID)', [ido, 0, ide]);
      QueryExec(SRC_DB_PB, s);

      // add PB.object property
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [1, ido, Trim(FieldByName('FAMIL').AsString)]);
      QueryExec(SRC_DB_PB, s);
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [2, ido, Trim(FieldByName('IME').AsString)]);
      QueryExec(SRC_DB_PB, s);
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [3, ido, Trim(FieldByName('OTC').AsString)]);
      QueryExec(SRC_DB_PB, s);
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [4, ido, '01.01.2000']);
      QueryExec(SRC_DB_PB, s);
      idd := '';
      with dmSigma.qDolg do
      begin
        Close;
        SQL.Text := Format('select NAMEODOLG from LISTDOLG where IDDOLG=%s',
          [dmSigma.qUsr.FieldByName('DOLG').AsString]);
        Open;
        if not eof then
          idd := FieldByName('NAMEODOLG').AsString;
      end;
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [5, ido, idd]);
      QueryExec(SRC_DB_PB, s);

      // add TB.employee
      idemployee := GetId(SRC_DB_TB,
        Format('select EMPLOYEE_ID from EMPLOYEE where EXTERNAL_OBJECT_ID=%d',
        [ido]), 'EMPLOYEE_ID');
      if idemployee = 0 then
        idemployee := GetId(SRC_DB_TB,
          'select GEN_ID(GEN_EMPLOYEE_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into EMPLOYEE (EMPLOYEE_ID, EMPLOYEE_NAME, EXTERNAL_OBJECT_ID) '
        + 'values (%d, ''%s'', %d) matching (EMPLOYEE_ID)',
        [idemployee, FieldByName('FAMIL').AsString + ' ' + FieldByName('IME')
        .AsString + ' ' + FieldByName('OTC').AsString, ido]);
      QueryExec(SRC_DB_TB, s);

      // add TB.employee_group
      UserGroup := GetId(SRC_DB_TB,
        Format('select USER_GROUP from %s where BCP=%d',
        [UsrGrTable, FieldByName('IDBCP').AsInteger]), 'USER_GROUP');

      s := Format
        ('update or insert into EMPLOYEE_GROUP (GROUP_ID, EMPLOYEE_ID, USER_ID, IS_ACTIVE) '
        + 'values (%d, %d, %d, %d) matching (GROUP_ID, EMPLOYEE_ID)',
        [UserGroup, idemployee, FieldByName('IDUSR').AsInteger, 1]);
      QueryExec(SRC_DB_TB, s);

      {
        // add PB.card
        if not(FieldByName('FACILITY').IsNull) and not(FieldByName('CARD').IsNull)
        and (FieldByName('FACILITY').AsInteger > 0) and
        (FieldByName('CARD').AsInteger > 0) then
        begin
        s := Format
        ('update or insert into card (CARD_ID, CARD_STATE_ID, FACILITY) ' +
        'values (%d, %d, %d) matching (CARD_ID, FACILITY)',
        [FieldByName('CARD').AsInteger, 1, FieldByName('FACILITY')
        .AsInteger]);
        QueryExec(SRC_DB_PB, s);
        end;

        // add PB.pass
        if not(FieldByName('FACILITY').IsNull) and not(FieldByName('CARD').IsNull)
        and (FieldByName('FACILITY').AsInteger > 0) and
        (FieldByName('CARD').AsInteger > 0) then
        begin
        idp := GetId(SRC_DB_PB,
        Format('select ROSTEK_PASS from %s where NETDEVICE=%d and BIGDEVICE=%d and BCP=%d and USR=%d',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger]),
        'ROSTEK_PASS');
        if idp = 0 then
        idp := GetId(SRC_DB_PB,
        'select GEN_ID(GEN_PASS_ID, 1) from RDB$DATABASE', 'GEN_ID');

        s := Format
        ('update or insert into pass (PASS_ID, ELEMENT_ID, OBJECT_ID, DEMAND_ID, CURRENT_CARD_ID) '
        + 'values (%d, %d, %d, %d, %d) matching (PASS_ID)',
        [idp, ide, ido, curDemand, FieldByName('CARD').AsInteger]);
        QueryExec(SRC_DB_PB, s);
        end;

        // add PB.usrTable
        s := Format
        ('update or insert into %s (NETDEVICE, BIGDEVICE, BCP, USR, CARD, FACILITY, ROSTEK_OBJECT, ROSTEK_PASS) '
        + 'values (%d, %d, %d, %d, %d, %d, %d, %d) matching (NETDEVICE, BIGDEVICE, BCP, USR, CARD, FACILITY)',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger,
        FieldByName('CARD').AsInteger, FieldByName('FACILITY')
        .AsInteger, ido, 0]);
        QueryExec(SRC_DB_PB, s);
      }

      { TEMP DISITION vvv }

      // add PB.card   FULLCARD_VVV
      CardStateId := 3;
      LUser := GetLUser(FieldByName('IDUSR').AsInteger);
      if LUser <> nil then
        if (LUser^.UserFlagsWord and $10) = 0 then
          CardStateId := 1;
      if (CardStateId = 1) then
        PassStatusId := 2
      else
        PassStatusId := 3;

      s := Format
        ('update or insert into card (CARD_ID, CARD_STATE_ID, FACILITY) ' +
        'values (%d, %d, %d) matching (CARD_ID, FACILITY)',
        [FieldByName('IDUSR').AsInteger, CardStateId,
        dmSigma.qUsr.FieldByName('FACILITY').AsInteger]);
      // <<IDUSR instead CARD
      QueryExec(SRC_DB_PB, s);

      // add PB.pass
      idp := GetId(SRC_DB_PB,
        Format('select ROSTEK_PASS from %s where NETDEVICE=%d and BIGDEVICE=%d and BCP=%d and USR=%d',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger]),
        'ROSTEK_PASS');
      if idp = 0 then
        idp := GetId(SRC_DB_PB,
          'select GEN_ID(GEN_PASS_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into pass (PASS_ID, ELEMENT_ID, OBJECT_ID, DEMAND_ID, CURRENT_CARD_ID, START_DATE_TIME, STOP_DATE_TIME, PASS_STATUS_ID) '
        + 'values (%d, %d, %d, %d, %d, ''%s'', ''%s'', %d) matching (PASS_ID)',
        [idp, ide, ido, CurDemand, FieldByName('IDUSR').AsInteger, '01.01.2020',
        '01.01.2100', PassStatusId]);
      // <<IDUSR instead CARD
      QueryExec(SRC_DB_PB, s);

      // add PB.usrTable
      s := Format
        ('update or insert into %s (NETDEVICE, BIGDEVICE, BCP, USR, CARD, FACILITY, ROSTEK_OBJECT, ROSTEK_PASS) '
        + 'values (%d, %d, %d, %d, %d, %d, %d, %d) matching (NETDEVICE, BIGDEVICE, BCP, USR)',
        // <<delete CARD, FACILITY
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger,
        FieldByName('IDUSR').AsInteger, FieldByName('FACILITY')
        // <<IDUSR instead CARD
        .AsInteger, ido, idp]);
      QueryExec(SRC_DB_PB, s);

      { TEMP DISITION ^^^ }

      Next;
    end;
  end;
  EndTransaction(SRC_TR_WORK_R, TR_C);

end;

procedure TProcess.UpdateElementGroup;
var
  s: String;

begin
  with dmRostek.qRmUsrGr do
  begin
    StartTransaction(SRC_DB_TB, SRC_TR_TB_R);
    Close;
    SQL.Text := 'select BCP, USER_GROUP from ' + UsrGrTable;
    Open;
    while not eof do
    begin
      s := Format
        ('update element set USER_GROUP_EVENT=%d, USER_GROUP_DRIVE=%d where (NET_DEVICE=%d) and (BIG_DEVICE=%d) and '
        + '((SYSTEM_DEVICE=0) and (TYPE_DEVICE in (4,5,6,7,8,9,10,11)) or (SYSTEM_DEVICE=1)and(TYPE_DEVICE in (2)));',
        [FieldByName('USER_GROUP').AsInteger, FieldByName('USER_GROUP')
        .AsInteger, fmain.ModuleNetDevice, FieldByName('BCP').AsInteger]);
      QueryExec(SRC_DB_TB, s);
      Next;
    end;
    EndTransaction(SRC_TR_TB_R, TR_C);
  end;

end;

procedure TProcess.StartTransaction(Db, Tr: TSrc);
begin
  case Db of
    SRC_DB_TB:
      begin
        if not dmRostek.dTB.Connected then
          dmRostek.dTB.Open;
        case Tr of
          SRC_TR_TB_R:
            dmRostek.trTBr.StartTransaction;
          SRC_TR_TB_W:
            dmRostek.trTBw.StartTransaction;
        end;
      end;

    SRC_DB_PB:
      begin
        if not dmRostek.dPB.Connected then
          dmRostek.dPB.Open;
        case Tr of
          SRC_TR_PB_R:
            dmRostek.trPBr.StartTransaction;
          SRC_TR_PB_W:
            dmRostek.trPBw.StartTransaction;
        end;
      end;

    SRC_DB_WORK:
      begin
        if not dmSigma.DB_Work.Connected then
          dmSigma.DB_Work.Open;
        case Tr of
          SRC_TR_WORK_R:
            dmSigma.TR_WorkR.StartTransaction;
        end;
      end;

    SRC_DB_PROTOCOL:
      begin
        if not dmSigma.DB_Protocol.Connected then
          dmSigma.DB_Protocol.Open;
        case Tr of
          SRC_TR_PROTOCOLR:
            dmSigma.TR_ProtocolR.StartTransaction;
        end;
      end;
  end;
end;

procedure TProcess.EndTransaction(Tr: TSrc; How: TTransactionType);
begin
  case Tr of
    SRC_TR_TB_R:
      case How of
        TR_C:
          dmRostek.trTBr.Commit;
        TR_CR:
          dmRostek.trTBr.CommitRetaining;
        TR_RB:
          dmRostek.trTBr.Rollback;
      end;

    SRC_TR_TB_W:
      case How of
        TR_C:
          dmRostek.trTBw.Commit;
        TR_CR:
          dmRostek.trTBw.CommitRetaining;
        TR_RB:
          dmRostek.trTBw.Rollback;
      end;

    SRC_TR_PB_R:
      case How of
        TR_C:
          dmRostek.trPBr.Commit;
        TR_CR:
          dmRostek.trPBr.CommitRetaining;
        TR_RB:
          dmRostek.trPBr.Rollback;
      end;

    SRC_TR_PB_W:
      case How of
        TR_C:
          dmRostek.trPBw.Commit;
        TR_CR:
          dmRostek.trPBw.CommitRetaining;
        TR_RB:
          dmRostek.trPBw.Rollback;
      end;

    SRC_TR_WORK_R:
      case How of
        TR_C:
          dmSigma.TR_WorkR.Commit;
        TR_CR:
          dmSigma.TR_WorkR.CommitRetaining;
        TR_RB:
          dmSigma.TR_WorkR.Rollback;
      end;

    SRC_TR_PROTOCOLR:
      case How of
        TR_C:
          dmSigma.TR_ProtocolR.Commit;
        TR_CR:
          dmSigma.TR_ProtocolR.CommitRetaining;
        TR_RB:
          dmSigma.TR_ProtocolR.Rollback;
      end;
  end;
end;

function TProcess.GetId(Db: TSrc; Expression, Field: String;
  FieldType: TFieldType = FT_LONGINT): Variant;
begin
  if FieldType = FT_LONGINT then
    result := 0
  else
    result := '';

  case Db of

    SRC_DB_TB:
      try
        StartTransaction(SRC_DB_TB, SRC_TR_TB_R);
        with dmRostek.qTBAnyR do
        begin
          Close;
          SQL.Text := Expression;
          Open;
          if not eof then
            if FieldType = FT_LONGINT then
              result := FieldByName(Field).AsInteger
            else
              result := FieldByName(Field).AsString;
        end;
      finally
        EndTransaction(SRC_TR_TB_R, TR_C);
      end;

    SRC_DB_PB:
      try
        StartTransaction(SRC_DB_PB, SRC_TR_PB_R);
        with dmRostek.qPBAnyR do
        begin
          Close;
          SQL.Text := Expression;
          Open;
          if not eof then
            if FieldType = FT_LONGINT then
              result := FieldByName(Field).AsInteger
            else
              result := FieldByName(Field).AsString;
        end;
      finally
        EndTransaction(SRC_TR_PB_R, TR_C);
      end;

    SRC_DB_WORK:
      try
        StartTransaction(SRC_DB_WORK, SRC_TR_WORK_R);
        with dmSigma.qWAnyR do
        begin
          Close;
          SQL.Text := Expression;
          Open;
          if not eof then
            if FieldType = FT_LONGINT then
              result := FieldByName(Field).AsInteger
            else
              result := FieldByName(Field).AsString;
        end;
      finally
        EndTransaction(SRC_TR_WORK_R, TR_C);
      end;

  end;
end;

procedure TProcess.QueryExec(Db: TSrc; Expression: String);
begin
  case Db of

    SRC_DB_TB:
      try
        StartTransaction(SRC_DB_TB, SRC_TR_TB_W);
        with dmRostek.qTBAnyW do
        begin
          Close;
          SQL.Text := Expression;
          ExecSQL;
        end;
      finally
        EndTransaction(SRC_TR_TB_W, TR_C);
      end;

    SRC_DB_PB:
      try
        StartTransaction(SRC_DB_PB, SRC_TR_PB_W);
        with dmRostek.qPBAnyW do
        begin
          Close;
          SQL.Text := Expression;
          ExecSQL;
        end;
      finally
        EndTransaction(SRC_TR_PB_W, TR_C);
      end;

  end;
end;

procedure TProcess.Log;
var
  tf: Textfile;
  fname: String;
begin
  fname := ExtractFileName(ParamStr(0));
  Delete(fname, length(fname) - 2, 3);
  fname := fname + 'log';
  try
    AssignFile(tf, fname);
    if FileExists(fname) then
      Append(tf)
    else
      ReWrite(tf);
    WriteLn(tf, logStr);
    Flush(tf);
  finally
    CloseFile(tf);
  end;

  if fmain.Memo1.Lines.Count > 10000 then
    fmain.Memo1.Clear;
  fmain.Memo1.Lines.Add(logStr);
end;

function ValToStr(var m: array of Byte): String;
var
  st: String;
  i: Byte;

begin
  st := '';
  for i := 0 to 2 do
  begin
    st := st + IntToHex(m[i], 2);
    if st[length(st)] = 'A' then
      SetLength(st, length(st) - 1);
    if st[length(st)] = 'A' then
      SetLength(st, length(st) - 1);
  end;

  for i := 5 downto 0 do
    if ((m[3] shr i) and 1) > 0 then
      Insert('.', st, i + 2);

  result := st;
end;
{$ENDREGION}

end.
