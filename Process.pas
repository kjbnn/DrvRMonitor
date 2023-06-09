unit Process;

interface

uses
  System.Classes, SharedBuffer;

type
  TSigmaOperation = (OP_NONE, OP_INIT, OP_SYNC_CONFIG, OP_START_EVENT,
    OP_NEXT_EVENT);
  TSrc = (SRC_NONE, SRC_GENERATOR, SRC_TABLE, SRC_TECHBASE, SRC_PASSBASE);

  TProcess = class(TThread)
  private
  protected
    logStr: String;
    mes: KSBMES;
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
    procedure GetUsr;
    function GetId(Db: TSrc; Expression, Field: String): Longword;
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

var
  testSigmaDb: Int64 = 0;
  sigmaOperation: TSigmaOperation = OP_NONE; // need check
  err: word;

implementation

uses
  sigma, main, Sysutils, rostek, TypInfo,
  constants, connection;

{ TProcess }
procedure TProcess.Execute;
var
  SyncConfig: Integer;
  i: word;

begin
  NameThreadForDebugging('Process');

  while not Terminated do
    try

      case sigmaOperation of

        OP_NONE:
          begin
            TryStrToInt(fmain.vle1.Values[pWORK_MODE], SyncConfig);
            case SyncConfig of
              0:
                sigmaOperation := OP_NONE;
              1:
                sigmaOperation := OP_INIT;
              2:
                sigmaOperation := OP_SYNC_CONFIG;
            else
              sigmaOperation := OP_START_EVENT;
            end;
            CleanConfig;
          end;

        OP_INIT:
          for i := 1 to 2 do
          begin
            err := 1;
            with dmSigma do
            begin
              if not DB_Work.Connected then
                DB_Work.Open;
              err := 2;
              if not TR_Work.Active then
                TR_Work.StartTransaction;
            end;
            err := 3;
            with dmRostek do
            begin
              if not dTB.Connected then
                dTB.Open;
              err := 4;
              if not trTB.Active then
                trTB.StartTransaction;
            end;
            err := 5;
            sigmaOperation := OP_SYNC_CONFIG;
          end;

        OP_SYNC_CONFIG:
          begin
            err := 6;
            GetBCPElements;
            err := 7;
            GetPodraz;
            err := 8;
            GetUsr;
            err := 9;
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
            sigmaOperation := OP_START_EVENT;
          end;

        OP_START_EVENT:
          begin
            StartEvent;
            sigmaOperation := OP_NEXT_EVENT;
          end;

        OP_NEXT_EVENT:
          begin
            NextEvent;
            inc(testSigmaDb);
            sleep(1000);
          end;
      end;

      sleep(100);
    except
      on E: Exception do
      begin
        logStr := 'Exception: ' + GetEnumName(TypeInfo(TSigmaOperation),
          ord(sigmaOperation)) + ' -(' + err.ToString + ')-> ' + E.Message;
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
        Close;
        // SQL.Text := 'select max(cod) from TABLE1';
        SQL.Text := 'select max(COD) as MAXCOD from TABLE1';
        Open;
        if not eof then
          curEvent := FieldByName('MAXCOD').AsInteger;
        Close;
      end;
    end;
  end;
end;

procedure TProcess.NextEvent;
var
  tc: word;

begin
  with dmSigma.qEvent do
  begin
    Close;
    SQL.Text := 'select COD, DT, IDBCP, IDEVT' +
      ', IDOBJ, IDSOURCE, IDZON, NAMEEVT, NAMEOBJ, NAMESOURCE' +
      ', NAMEZON, OBJTYPE, TSTYPE, TYPESOURCE from TABLE1' + ' where COD > ' +
      IntToStr(curEvent) + ' and IDBCP in (0, 11829) order by COD';
    Open;

    while not eof do
    begin
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
  end; // case

  case typeSource of
    0: // Само
      ;
    1: // Пользователь
      mes.User := abs(idSource);
    2: // Система
      ;
    4: // Скрипт
      mes.User := idSource;
    6: // ПЭВМ
      ;
    9: // Код неисправности (Потеря связи с оборудованием)
      ;
    11: // АРМ
      mes.User := idSource;
    61: // БЦП
      mes.User := idSource;
  end;

  case idIvent of
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
        mes.Code := { R8_AP_IN } SUD_ACCESS_GRANTED;
        GetCard(mes.BigDevice, mes.User, mes.Facility, mes.NumCard);
      end;
    $602:
      begin
        mes.Code := { R8_AP_OUT } SUD_ACCESS_GRANTED;
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
      mes.Code := R8_AP_DOORCLOSE;
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
      ;
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
      mes.Code := R8_AP_ACCESSTIMEOUT;
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
  QueryExec(SRC_TECHBASE, s);

  s := Format
    ('delete from element where (NET_DEVICE=%d) and ((SYSTEM_DEVICE=0) ' +
    'and(TYPE_DEVICE in (4,5,6,7,8,9,10,11)) or (SYSTEM_DEVICE=1)and(TYPE_DEVICE in (2)))',
    [fmain.ModuleNetDevice]);
  QueryExec(SRC_TECHBASE, s);

  s := Format('delete from %s', [UsrTable]);
  QueryExec(SRC_TECHBASE, s);

  s := Format('delete from %s', [PodrazTable]);
  QueryExec(SRC_PASSBASE, s);

  s := Format('delete from %s', [UsrTable]);
  QueryExec(SRC_PASSBASE, s);

end;

procedure TProcess.GetBCPElements;
var
  ConfigArray: TArray<Byte>; // TBytes;

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
    TelementParse = (EP_NONE, EP_ZONE, EP_TC, EP_SEARCH);

  VAR
    DrvParentID, BCPParentID, ZoneParentID: LongInt;
    curLen, txtLen: LongInt; // word;
    zoneCount: word;
    ep: TelementParse;
    curBCP: word;

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

    procedure CreateBCP(a: TArray<Byte>);
    var
      id: LongInt;
      s: String;
    begin
      curBCP := a[0] + a[1] shl 8;
      logStr := 'БЦП ' + IntToStr(curBCP);
      Synchronize(Log); //
      id := GetId(SRC_TECHBASE,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=4 and SYSTEM_DEVICE=0 and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=0',
        [fmain.ModuleNetDevice, a[0] + a[1] shl 8]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, DrvParentID, 110, 4, 0, fmain.ModuleNetDevice, a[0] + a[1] shl 8,
        0, logStr]);
      QueryExec(SRC_TECHBASE, s);
      BCPParentID := id;
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
        id := GetId(SRC_TECHBASE,
          Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=6 and SYSTEM_DEVICE=0 and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=%d',
          [fmain.ModuleNetDevice, curBCP, zn]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, BCPParentID, 112, 6, 0, fmain.ModuleNetDevice, curBCP, zn,
        logStr]);
      QueryExec(SRC_TECHBASE, s);
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

      id := GetId(SRC_TECHBASE,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=%d and SYSTEM_DEVICE=%d and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=%d',
        [typeDevice, SysDevice, fmain.ModuleNetDevice, curBCP, tc]),
        'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');

      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, ZoneParentID, categoryId, typeDevice, SysDevice,
        fmain.ModuleNetDevice, curBCP, tc, logStr]);
      QueryExec(SRC_TECHBASE, s);
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
    zoneCount := (a[0] + a[1] shl 8);
    Delete(a, 0, 4);

    ep := EP_ZONE;
    while (zoneCount > 0) or (ep <> EP_NONE) do
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
            dec(zoneCount);
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
            else if zoneCount > 0 then
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
  end;

begin
  with dmSigma.qConfig do
  begin
    DisableControls;
    Close;
    SQL.Text := 'select * from CONFIG';
    err := 11;
    Open;
    err := 12;
    try
      while not eof do
      begin
        ConfigArray := FieldByName('BCPCONF').AsBytes;
        // PrintConfig(FieldByName('IDBCP').AsInteger, ConfigArray);
        ParseConfig(ConfigArray);
        Next;
      end;
    finally
      EnableControls;
    end;
    err := 13;
  end;

end;

procedure TProcess.GetCard(idBcp, IdUsr: word; out Facility: Byte;
  out Card: word);
begin
  Facility := 0;
  Card := 0;
  with dmSigma.qUsr do
  begin
    First;
    while not eof do
      if (idBcp = FieldByName('IDBCP').AsInteger) and
        (IdUsr = FieldByName('IDUSR').AsInteger) and
        (not FieldByName('FACILITY').IsNull) and
        (not FieldByName('CARD').IsNull)
      then
      begin
        Facility := FieldByName('FACILITY').AsInteger;
        Card := FieldByName('CARD').AsInteger;
        Break;
      end
      else
        Next;
  end;
end;

procedure TProcess.GetPodraz;
var
  exist: Boolean;
  s: String;
  id: word;
begin
  exist := False;
  try
    with dmRostek.qPBAny do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select count(*) from ' + PodrazTable + ';');
      Open;
      exist := True;
      logStr := 'Table ' + PodrazTable + ' exist';
    end;
    dmRostek.trPB.Commit;
  except
    logStr := 'Table ' + PodrazTable + ' not exist';
  end;
  // Synchronize(Log);

  if not(exist) then
    try
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + PodrazTable + ' (');
        SQL.Add('FNETDEVICE Integer NOT NULL, ');
        SQL.Add('FBIGDEVICE Integer NOT NULL, ');
        SQL.Add('FPODRAZ Integer NOT NULL, ');
        SQL.Add('FROSTEK_ELEMENT Integer NOT NULL);');
        ExecSQL;
        dmRostek.trPB.Commit;
        logStr := 'Table ' + PodrazTable + ' was created';
        Synchronize(Log);
      end;
    except
    end;

  with dmSigma.qPodraz do
  begin
    Close;
    SQL.Text := 'select IDPODR, IDPAR, NAMEPODR from PODRAZ order by IDPAR';
    Open;
    while not eof do
    begin

      id := GetId(SRC_PASSBASE,
        Format('select FROSTEK_ELEMENT from %s where FNETDEVICE=%d and FBIGDEVICE=%d and FPODRAZ=%d',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDPODR').AsInteger]), 'FROSTEK_ELEMENT');
      if id = 0 then
        id := GetId(SRC_PASSBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');

      logStr := Trim(FieldByName('NAMEPODR').AsString);
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, CHILD_COUNT, ELEMENT_TYPE_ID, ELEMENT_NAME, PASS_LIMIT, PASS_REAL) '
        + 'values (%d, %d, %d, ''%s'', %d, %d) matching (ELEMENT_ID)',
        [id, 0, 0, logStr, 0, 0]);
      QueryExec(SRC_PASSBASE, s);

      s := Format
        ('update or insert into %s (FNETDEVICE, FBIGDEVICE, FPODRAZ, FROSTEK_ELEMENT) '
        + 'values (%d, %d, %d, %d) matching (FROSTEK_ELEMENT)',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDPODR').AsInteger, id]);
      QueryExec(SRC_PASSBASE, s);
      Next;
    end;
  end;

end;

procedure TProcess.GetUsr;
var
  exist: Boolean;
  s: String;
  ido, ide { , idp } : word;

begin
  exist := False;
  try
    with dmRostek.qPBAny do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select count(*) from ' + UsrTable + ';');
      Open;
      exist := True;
      logStr := 'Table ' + UsrTable + ' exist';
    end;
    dmRostek.trPB.Commit;
  except
    logStr := 'Table ' + UsrTable + ' not exist';
  end;
  // Synchronize(Log);

  if not(exist) then
    try
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + UsrTable + ' (');
        SQL.Add('FNETDEVICE Integer NOT NULL, ');
        SQL.Add('FBIGDEVICE Integer NOT NULL, ');
        SQL.Add('FBCP Integer NOT NULL, ');
        SQL.Add('FUSR Integer NOT NULL, ');
        SQL.Add('FCARD Integer NOT NULL, ');
        SQL.Add('FFACILITY SMALLINT NOT NULL, ');
        SQL.Add('FROSTEK_OBJECT Integer NOT NULL, ');
        SQL.Add('FROSTEK_PASS Integer NOT NULL);');
        ExecSQL;
        dmRostek.trPB.Commit;
        logStr := 'Table ' + UsrTable + ' was created';
        Synchronize(Log);
      end;
    except
    end;

  exist := False;
  try
    with dmRostek.qTBAny do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select count(*) from ' + UsrTable + ';');
      Open;
      exist := True;
      logStr := 'Table ' + UsrTable + ' exist';
    end;
    dmRostek.trTB.Commit;
  except
    logStr := 'Table ' + UsrTable + ' not exist';
  end;
  // Synchronize(Log);

  if not(exist) then
    try
      with dmRostek.qTBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + UsrTable + ' (');
        SQL.Add('FNETDEVICE Integer NOT NULL, ');
        SQL.Add('FBIGDEVICE Integer NOT NULL, ');
        SQL.Add('FBCP Integer NOT NULL, ');
        SQL.Add('FUSR Integer NOT NULL, ');
        SQL.Add('FROSTEK_EMPLOYEE Integer NOT NULL);');
        ExecSQL;
        dmRostek.trTB.Commit;
        logStr := 'Table ' + UsrTable + ' was created';
        Synchronize(Log);
      end;
    except
    end;

  with dmSigma.qUsr do
  begin
    Close;
    SQL.Text :=
      'select sernum as IDBCP, u.IDZONE as IDUSR, FAMIL, IME, OTC, PODR, ' +
      'fcard as FACILITY, codcard as CARD from USR as u ' + 'join BCP as b ' +
      'on  u.idbcp = b.idbcp left join usercart as uc ' +
      'on (b.sernum = uc.snbcp) and (u.idzone = uc.iduser) ' +
      'order by sernum, u.IDZONE';
    Open;
    while not eof do
    begin
      // id object in rostek
      ido := GetId(SRC_PASSBASE,
        Format('select FROSTEK_OBJECT from %s where FNETDEVICE=%d and FBIGDEVICE=%d and FBCP=%d and FUSR=%d',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger]),
        'FROSTEK_OBJECT');
      if ido = 0 then
        ido := GetId(SRC_PASSBASE,
          'select GEN_ID(GEN_OBJECT_ID, 1) from RDB$DATABASE', 'GEN_ID');

      logStr := FieldByName('IDBCP').AsInteger.ToString + ' ' +
        FieldByName('IDUSR').AsInteger.ToString + ' ' +
        Trim(FieldByName('FAMIL').AsString) + ' ' +
        Trim(FieldByName('IME').AsString) + ' ' +
        Trim(FieldByName('OTC').AsString) + ' ' + FieldByName('PODR')
        .AsInteger.ToString;
      // Synchronize(Log);

      // id podraz in rostek
      ide := GetId(SRC_PASSBASE,
        Format('select FROSTEK_ELEMENT from %s where FNETDEVICE=%d and FBIGDEVICE=%d and FPODRAZ=%d',
        [PodrazTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('PODR').AsInteger]), 'FROSTEK_ELEMENT');

      // add object
      s := Format
        ('update or insert into OBJECT (OBJECT_ID, CLASS_ID, ELEMENT_ID) ' +
        'values (%d, %d, %d) matching (OBJECT_ID)', [ido, 0, ide]);
      QueryExec(SRC_PASSBASE, s);

      // add object property
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [1, ido, Trim(FieldByName('FAMIL').AsString)]);
      QueryExec(SRC_PASSBASE, s);
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [2, ido, Trim(FieldByName('IME').AsString)]);
      QueryExec(SRC_PASSBASE, s);
      s := Format
        ('update or insert into OBJECT_PROPERTY (CLASS_PROPERTY_ID, OBJECT_ID, PROPERTY_VALUE) '
        + 'values (%d, %d, ''%s'') matching (CLASS_PROPERTY_ID, OBJECT_ID)',
        [3, ido, Trim(FieldByName('OTC').AsString)]);
      QueryExec(SRC_PASSBASE, s);

      // add card
      if not(FieldByName('FACILITY').IsNull) and not(FieldByName('CARD').IsNull)
        and (FieldByName('FACILITY').AsInteger > 0) and
        (FieldByName('CARD').AsInteger > 0) then
      begin
        s := Format
          ('update or insert into card (CARD_ID, CARD_STATE_ID, FACILITY) ' +
          'values (%d, %d, %d) matching (CARD_ID, FACILITY)',
          [FieldByName('CARD').AsInteger, 1, FieldByName('FACILITY')
          .AsInteger]);
        QueryExec(SRC_PASSBASE, s);
      end;

      // add Pass
      // ??? need code
      {
        if not(FieldByName('FACILITY').IsNull) and not(FieldByName('CARD').IsNull)
        and (FieldByName('FACILITY').AsInteger > 0) and
        (FieldByName('CARD').AsInteger > 0) then
        begin
        s := Format
        ('update or insert into pass (CARD_ID, CARD_STATE_ID, FACILITY) ' +
        'values (%d, %d, %d) matching (CARD_ID, FACILITY)',
        [FieldByName('CARD').AsInteger, 1, FieldByName('FACILITY')
        .AsInteger]);
        QueryExec(SRC_PASSBASE, s);
        end; }

      // add usrTable
      s := Format
        ('update or insert into %s (FNETDEVICE, FBIGDEVICE, FBCP, FUSR, FCARD, FFACILITY, FROSTEK_OBJECT, FROSTEK_PASS) '
        + 'values (%d, %d, %d, %d, %d, %d, %d, %d) matching (FNETDEVICE, FBIGDEVICE, FBCP, FUSR, FCARD, FFACILITY)',
        [UsrTable, fmain.ModuleNetDevice, fmain.ModuleBigDevice,
        FieldByName('IDBCP').AsInteger, FieldByName('IDUSR').AsInteger,
        FieldByName('CARD').AsInteger, FieldByName('FACILITY')
        .AsInteger, ido, 0]);
      QueryExec(SRC_PASSBASE, s);

      Next;

    end;
  end;

end;

function TProcess.GetId(Db: TSrc; Expression, Field: String): Longword;
begin
  result := 0;
  case Db of

    SRC_TECHBASE:
      with dmRostek.qTBAny do
      begin
        Close;
        SQL.Text := Expression;
        Open;
        if not eof then
          result := FieldByName(Field).AsInteger;
      end;

    SRC_PASSBASE:
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Text := Expression;
        Open;
        if not eof then
          result := FieldByName(Field).AsInteger;
      end;

  end;
end;

procedure TProcess.QueryExec(Db: TSrc; Expression: String);
begin
  case Db of

    SRC_TECHBASE:
      with dmRostek.qTBAny do
      begin
        Close;
        SQL.Text := Expression;
        ExecSQL;
        dmRostek.trTB.CommitRetaining;
      end;

    SRC_PASSBASE:
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Text := Expression;
        ExecSQL;
        dmRostek.trPB.CommitRetaining;
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
