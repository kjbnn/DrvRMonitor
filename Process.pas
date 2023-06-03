unit Process;

interface

uses
  System.Classes;

type
  TSigmaOperation = (OP_NONE, OP_INIT, OP_SYNC_CONFIG, OP_START_EVENT,
    OP_NEXT_EVENT);
  TSrc = (SRC_NONE, SRC_GENERATOR, SRC_TABLE, SRC_TECHBASE, SRC_PASSBASE);

  TProcess = class(TThread)
  private
  protected
    NetDevice: word;
    logStr: String;
    procedure Execute; override;
    procedure StartEvent;
    procedure NextEvent;
    procedure GetBCPElements;
    procedure GetPodraz;
    procedure GetUsr;
    function GetId(Db: TSrc; Expression, Field: String): Longword;
    procedure QueryExec(Db: TSrc; Expression: String);
    procedure GetNetDevice;
    procedure Log;
  end;

function ValToStr(var m: array of byte): string;

const
  CU_MAX = 1024;
  ZN_MAX = 1024;

var
  testSigmaDb: Int64 = 0;
  sigmaOperation: TSigmaOperation = OP_NONE; // need check
  err: word;

implementation

uses
  sigma, main, Sysutils, rostek, Event, TypInfo;

{ TProcess }
procedure TProcess.Execute;
var
  SyncConfig: integer;
  i: word;

begin
  NameThreadForDebugging('Process');
  Synchronize(GetNetDevice);

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
              if not DB_Techbase.Connected then
                DB_Techbase.Open;
              err := 4;
              if not TR_Techbase.Active then
                TR_Techbase.StartTransaction;
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
              a:array [0..31] of byte;
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

            {
              try
              with dmSigma.qUsr do
              begin
              Close;
              Open;
              while not Eof do
              begin
              // обработка
              // curEvent := FieldByName('COD').AsLargeInt;
              sleep(0);
              Next;
              end;

              end;
              except
              dmSigma.DB_Protocol.Close;
              dmRostek.DB_Passbase.Close;
              end;
            }
            {
              dmRostek.tElement.Open;
              dmRostek.tElement.Append;
              dmRostek.tElement.FieldByName('ELEMENT_ID').AsInteger := 100;
              dmRostek.tElement.FieldByName('CHILD_COUNT').AsInteger := 0;
              dmRostek.tElement.FieldByName('ELEMENT_TYPE_ID').AsInteger := 100;
              dmRostek.tElement.FieldByName('ELEMENT_NAME').AsInteger := 100;
              dmRostek.tElement.FieldByName('PASS_LIMIT').AsInteger := 100;
              dmRostek.tElement.FieldByName('PASS_REAL').AsInteger := 100;
              dmRostek.tElement.FieldByName('ELEMENT_TYPE_ID').AsInteger := 0;
              dmRostek.tElement.Post;
              dmRostek.TR_Passbase.CommitRetaining;
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
        dmRostek.DB_Passbase.Close;
        dmRostek.DB_Techbase.Close;
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
      EventHandler(NetDevice, FieldByName('IDBCP').AsInteger, // bcp
        FieldByName('DT').AsDateTime, // DATE
        FieldByName('OBJTYPE').AsInteger, // TC, US, PC
        FieldByName('IDOBJ').AsInteger, // значение TC, US, PC
        FieldByName('IDZON').AsInteger, // номер зоны в Ростэк
        FieldByName('TYPESOURCE').AsInteger,
        // Тип (инициатора события) soure (0-никто, 1-пользователь, 2-система, 4-скрипт, 6-ПЭВМ, 9-неисправность, 11-АРМ, 61-БЦП s/n
        FieldByName('IDSOURCE').AsInteger, // ID source
        FieldByName('IDEVT').AsInteger, // Номер эвента
        FieldByName('TSTYPE').AsInteger // тип TC (1-9), 0-не ТС
        );
      curEvent := FieldByName('COD').AsLargeInt;
      Next;
      sleep(1);

      { vvv DEMO --------------------------------------------------- }
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
      { ^^^ DEMO --------------------------------------------------- }

    end;
  end;
end;

procedure TProcess.GetBCPElements;
var
  ConfigArray: TArray<byte>; // TBytes;

  procedure PrintConfig(bcpNumber: word; a: TArray<byte>);
  var
    tf: Textfile;
    i: Longword;
    b: byte;
  begin
    AssignFile(tf, Format('.\blob%d.txt', [bcpNumber])); // need_del
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

  function ParseConfig(a: TArray<byte>): boolean;
  type
    TelementParse = (EP_NONE, EP_ZONE, EP_TC, EP_SEARCH);

  VAR
    DrvParentID, BCPParentID, ZoneParentID: Longint;
    curLen, txtLen: Longword;
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

    procedure CreateBCP(a: TArray<byte>);
    var
      id: Longint;
      s: String;
    begin
      curBCP := a[0] + a[1] shl 8;
      logStr := 'БЦП ' + IntToStr(curBCP);
      Synchronize(Log); //
      id := GetId(SRC_TECHBASE,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=4 and SYSTEM_DEVICE=0 and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=0',
        [NetDevice, a[0] + a[1] shl 8]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, DrvParentID, 110, 4, 0, NetDevice, a[0] + a[1] shl 8, 0, logStr]);
      QueryExec(SRC_TECHBASE, s);
      BCPParentID := id;
    end;

    procedure CreateZone(a: TArray<byte>);
    var
      ar: TBytes;
      len1, len2: word;
      id: Longint;
      zn: integer;
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
          [NetDevice, curBCP, zn]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, BCPParentID, 112, 6, 0, NetDevice, curBCP, zn, logStr]);
      QueryExec(SRC_TECHBASE, s);
      ZoneParentID := id;
    end;

    procedure CreateTC(a: TArray<byte>);
    var
      ar: TBytes;
      len1, len2: word;
      id, categoryId, TypeDevice, SysDevice, tc: word;
      s: String;
    begin
      len1 := SizeOf(TTc);
      len2 := a[len1] + (a[len1 + 1] shl 8);
      ar := Copy(a, len1 + 2 + 2, len2 - 2);
      tc := a[0] + a[1] shl 8;

      case a[2] of
        1 .. 4:
          begin
            SysDevice := 0;
            categoryId := 111;
            TypeDevice := 5;
            logStr := Format('Шлейф %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        5:
          begin
            SysDevice := 0;
            categoryId := 115;
            TypeDevice := 7;
            logStr := Format('Реле %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        6:
          begin
            SysDevice := 1;
            categoryId := 13;
            TypeDevice := 2;
            logStr := Format('Сч %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
        7:
          begin
            SysDevice := 0;
            categoryId := 117;
            TypeDevice := 8;
            logStr := Format('Терминал %d: %s %s',
              [tc, ValToStr(a[3]), BytesToString(ar)]);
          end;
      else
        begin
          SysDevice := 0;
          categoryId := 0;
          TypeDevice := 0;
          logStr := 'Неизвестныйй ТС'
        end;

      end;
      // Synchronize(Log);

      id := GetId(SRC_TECHBASE,
        Format('select ELEMENT_ID from ELEMENT where TYPE_DEVICE=%d and SYSTEM_DEVICE=%d and NET_DEVICE=%d and BIG_DEVICE=%d and SMALL_DEVICE=%d',
        [TypeDevice, SysDevice, NetDevice, curBCP, tc]), 'ELEMENT_ID');
      if id = 0 then
        id := GetId(SRC_TECHBASE,
          'select GEN_ID(GEN_ELEMENT_ID, 1) from RDB$DATABASE', 'GEN_ID');
      s := Format
        ('update or insert into ELEMENT (ELEMENT_ID, PARENT_ID, CATEGORY_ID, TYPE_DEVICE, PARTION, DESCRIPTION, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE, ELEMENT_NAME) '
        + 'values (%d, %d, %d, %d, NULL, NULL, %d, %d, %d, %d, ''%s'') ' +
        'matching (TYPE_DEVICE, SYSTEM_DEVICE, NET_DEVICE, BIG_DEVICE, SMALL_DEVICE)',
        [id, ZoneParentID, categoryId, TypeDevice, SysDevice, NetDevice, curBCP,
        tc, logStr]);

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

procedure TProcess.GetPodraz;
const
  PodrazTable = 'RM$PODRAZ';
var
  exist: boolean;

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
    dmRostek.TR_Passbase.Commit;
  except
    logStr := 'Table ' + PodrazTable + ' not exist';
  end;
  Log;

  if not(exist) then
    try
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + PodrazTable + ' (');
        SQL.Add('FNETDEVICE INTEGER NOT NULL, ');
        SQL.Add('FBIGDEVICE INTEGER NOT NULL, ');
        SQL.Add('FPODRAZ INTEGER NOT NULL, ');
        SQL.Add('FROSTEK_ELEMENT INTEGER NOT NULL);');
        ExecSQL;
        dmRostek.TR_Passbase.Commit;
        logStr := 'Table ' + PodrazTable + ' was created';
        Log;
      end;
    except
    end;

  {
    with dmSigma.qPodraz do
    begin
    Close;
    SQL.Text := 'select IDPODR, IDPAR, NAMEPODR from PODRAZ order by IDPAR';
    Open;
    while not eof do
    with dmRostek do
    begin
    qTBElement.Close;
    qTBElement.Open;
    qTBElement.Append;
    qTBElement.FieldByName('ELEMENT_ID').AsInteger := FieldByName('IDPODR')
    .AsInteger;
    qTBElement.FieldByName('CHILD_COUNT').AsInteger := 0;
    qTBElement.FieldByName('ELEMENT_TYPE_ID').AsInteger := 0;
    qTBElement.FieldByName('ELEMENT_NAME').AsString :=
    FieldByName('NAMEPODR').AsString;
    qTBElement.FieldByName('PASS_LIMIT').AsInteger := 0;
    qTBElement.FieldByName('PASS_REAL').AsInteger := 0;
    qTBElement.Post;
    dmRostek.TR_Passbase.CommitRetaining;
    sleep(0);
    Next;
    end;

    end;

    with dmSigma.qPodraz do
    begin
    Close;
    Open;
    dmRostek.DB_Passbase.Open;
    if not dmRostek.TR_Passbase.Active then
    dmRostek.TR_Passbase.StartTransaction;
    while not eof do
    begin
    // обработка
    dmRostek.tElement.Close;
    s := 'update ELEMENT e set e.PARENT_ID = ' + FieldByName('IDPAR').AsString
    + ' where e.ELEMENT_ID = ' + FieldByName('IDPODR').AsString;
    s := 'update ELEMENT set PARENT_ID = ' + FieldByName('IDPAR').AsString +
    ' where ELEMENT_ID = ' + FieldByName('IDPODR').AsString;
    dmRostek.qElement.SQL.Text := s;
    dmRostek.qElement.ExecSQL;
    dmRostek.TR_Passbase.CommitRetaining;
    sleep(0);
    Next;
    end;
    end;
  }
end;

procedure TProcess.GetUsr;
const
  UsrTable = 'RM$USR';
var
  exist: boolean;

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
    dmRostek.TR_Passbase.Commit;
  except
    logStr := 'Table ' + UsrTable + ' not exist';
  end;
  Log;

  if not(exist) then
    try
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + UsrTable + ' (');
        SQL.Add('FNETDEVICE INTEGER NOT NULL, ');
        SQL.Add('FBIGDEVICE INTEGER NOT NULL, ');
        SQL.Add('FBCP INTEGER NOT NULL, ');
        SQL.Add('FUSR INTEGER NOT NULL, ');
        SQL.Add('FCARD INTEGER NOT NULL, ');
        SQL.Add('FFACILITY SMALLINT NOT NULL, ');
        SQL.Add('FROSTEK_OBJECT INTEGER NOT NULL, ');
        SQL.Add('FROSTEK_PASS INTEGER NOT NULL);');
        ExecSQL;
        dmRostek.TR_Passbase.Commit;
        logStr := 'Table ' + UsrTable + ' was created';
        Log;
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
    dmRostek.TR_Techbase.Commit;
  except
    logStr := 'Table ' + UsrTable + ' not exist';
  end;
  Log;

  if not(exist) then
    try
      with dmRostek.qTBAny do
      begin
        Close;
        SQL.Clear;
        SQL.Add('create table ' + UsrTable + ' (');
        SQL.Add('FNETDEVICE INTEGER NOT NULL, ');
        SQL.Add('FBIGDEVICE INTEGER NOT NULL, ');
        SQL.Add('FBCP INTEGER NOT NULL, ');
        SQL.Add('FUSR INTEGER NOT NULL, ');
        SQL.Add('FROSTEK_EMPLOYEE INTEGER NOT NULL);');
        ExecSQL;
        dmRostek.TR_Techbase.Commit;
        logStr := 'Table ' + UsrTable + ' was created';
        Log;
      end;
    except
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
        dmRostek.TR_Techbase.CommitRetaining;
      end;

    SRC_PASSBASE:
      with dmRostek.qPBAny do
      begin
        Close;
        SQL.Text := Expression;
        ExecSQL;
        dmRostek.TR_Techbase.CommitRetaining;
      end;

  end;
end;

procedure TProcess.GetNetDevice;
var
  i: integer;
begin
  NetDevice := 0;
  TryStrToInt(fmain.vle1.Values['NetDevice'], i);
  NetDevice := word(i);
end;

procedure TProcess.Log;
const
  fname = '.\Log.log';
var
  tf: Textfile;
begin
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

function ValToStr(var m: array of byte): string;
var
  st: string;
  i: byte;

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
