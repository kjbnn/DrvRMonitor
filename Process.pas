unit Process;

interface

uses
  System.Classes;

type
  TSigmaOperation = (OP_NONE, OP_START, OP_UPDATE_CFG, OP_CFG, OP_EVENT);

  TProcess = class(TThread)
  private
  protected
    NetDevice: word;
    logStr: String;
    procedure Execute; override;
    procedure GetBCPElements;
    procedure Log;
    procedure GetNetDevice;
  end;

var
  testSigmaDb: Int64 = 0;
  sigmaOperation: TSigmaOperation = OP_START; // need check

implementation

uses
  sigma, main, Sysutils, rostek, Event;

{ TProcess }

procedure TProcess.Execute;
var
  id: Int64;
  i: Integer;
  s: String;

begin
  NameThreadForDebugging('Process');
  Synchronize(GetNetDevice);

  while not Terminated do
  begin
    case sigmaOperation of

      OP_START:
        begin

          if curEvent = 0 then
          begin
            with dmSigma.Query1 do
              try
                Close;
                SQL.Clear;
                SQL.Text := 'select max(COD) as MAXCOD from TABLE1';
                Open;
                curEvent := FieldByName('MAXCOD').AsInteger;
                Close;
              except
                Close;
                logStr := 'Exception: OP_START';
                Synchronize(Log);
              end;
          end;

          sigmaOperation := OP_EVENT;
        end;

      OP_UPDATE_CFG:
{$REGION 'OP_UPDATE_CFG'}
        begin
          GetBCPElements;
          sigmaOperation := OP_EVENT;
        end;
{$ENDREGION}
      OP_CFG:
{$REGION 'OP_CFG'}
        begin
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

          id := 0;
          with dmRostek do
          begin
            if not DB_Techbase.Connected then
              DB_Techbase.Open;
            if not TR_Techbase.Active then
              TR_Techbase.StartTransaction;
          end;

          with dmRostek.Query1 do
          begin
            Close;
            SQL.Text := 'select max(e.element_id) as MAXID from element e';
            ExecQuery;
            if not Eof then
              id := FieldByName('MAXID').AsInteger;
          end;

          { ------- }
          { qPodraz }
          { ------- }
          {
            try
            with dmSigma.qPodraz do
            begin
            Close;
            Open;

            while not Eof do
            begin
            // обработка
            dmRostek.tElement.Close;
            dmRostek.tElement.Open;
            dmRostek.tElement.Append;
            dmRostek.tElement.FieldByName('ELEMENT_ID').AsInteger :=
            FieldByName('IDPODR').AsInteger;
            dmRostek.tElement.FieldByName('ELEMENT_NAME').AsString :=
            FieldByName('NAMEPODR').AsString;
            dmRostek.tElement.FieldByName('CHILD_COUNT').AsInteger := 0;
            dmRostek.tElement.FieldByName('ELEMENT_TYPE_ID').AsInteger := 0;
            dmRostek.tElement.FieldByName('PASS_LIMIT').AsInteger := 0;
            dmRostek.tElement.FieldByName('PASS_REAL').AsInteger := 0;
            dmRostek.tElement.FieldByName('ELEMENT_TYPE_ID').AsInteger := 0;
            dmRostek.tElement.Post;
            dmRostek.TR_Passbase.CommitRetaining;
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
            try
            with dmSigma.qPodraz do
            begin
            Close;
            Open;
            dmRostek.DB_Passbase.Open;
            if not dmRostek.TR_Passbase.Active then
            dmRostek.TR_Passbase.StartTransaction;
            while not Eof do
            begin
            // обработка
            dmRostek.tElement.Close;
            s := 'update ELEMENT e set e.PARENT_ID = ' +
            FieldByName('IDPAR').AsString + ' where e.ELEMENT_ID = ' +
            FieldByName('IDPODR').AsString;
            s := 'update ELEMENT set PARENT_ID = ' + FieldByName('IDPAR')
            .AsString + ' where ELEMENT_ID = ' +
            FieldByName('IDPODR').AsString;
            dmRostek.tElement.SQL.Text := s;
            dmRostek.tElement.ExecQuery;
            dmRostek.TR_Passbase.CommitRetaining;
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

          sigmaOperation := OP_EVENT;
        end;
{$ENDREGION}
      OP_EVENT:
        begin

          try
            with dmSigma.Query1 do
            begin
              Close;
              SQL.Clear;
              SQL.Text := 'select COD, DT, IDBCP, IDEVT' +
                ', IDOBJ, IDSOURCE, IDZON, NAMEEVT, NAMEOBJ, NAMESOURCE' +
                ', NAMEZON, OBJTYPE, TSTYPE, TYPESOURCE from TABLE1' +
                ' where COD > ' + IntToStr(curEvent) +
                ' and IDBCP in (0, 11829) order by COD';
              Open;
              while not Eof do
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
                sleep(0);

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
                  FieldByName('NAMEOBJ').AsString, FieldByName('NAMEEVT')
                  .AsString]);
                if length(FieldByName('NAMESOURCE').AsString) > 2 then
                  logStr := logStr + '  (' + FieldByName('NAMESOURCE')
                    .AsString + ')';
                Synchronize(Log);
                { ^^^ DEMO --------------------------------------------------- }

              end;
            end;
          except
            logStr := 'Exception: OP_EVENT';
            Synchronize(Log);
            dmSigma.DB_Protocol.Close;
          end;

          inc(testSigmaDb);
          sleep(1000);
        end;

    end;
    sleep(1);
  end;
end;

{ GetBCPElements }

procedure TProcess.GetBCPElements;
var
  ConfigArray: TArray<byte>; // TBytes;

{$REGION 'Clear'}
  procedure Clear;
  var
    pNode: TPNode;

  begin
    {
      for pNode in BCPElements do
      if pNode <> nil then
      begin
      pNode^.pcName := '';
      Dispose(pNode);
      BCPElements.Remove(pNode);
      end;
    }
  end;
{$ENDREGION}
{$REGION 'PrintConfig'}
  procedure PrintConfig(bcpNumber: word; a: TArray<byte>);
  var
    tf: Textfile;
    i: longword;
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
{$ENDREGION}
{$REGION 'ParseConfig'}
  function ParseConfig(a: TArray<byte>): boolean;

  type
    TelementParse = (EP_NONE, EP_ZONE, EP_TC, EP_SEARCH);

  VAR
    parElement: Longint;
    curLen, txtLen: longword;
    zoneCount: word;
    ep: TelementParse;

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

    function CreateBCP(a: TArray<byte>): boolean;
    begin
      logStr := 'BCP: ' + IntToStr(a[0] + a[1] shl 8);
      // Synchronize(Log);
      result := False;
    end;

    function CreateZone(a: TArray<byte>): boolean;
    var
      ar: TBytes;
      len1, len2: word;
    begin
      // ar := StringToBytes('ПриветWorld');
      len1 := SizeOf(TZone);
      len2 := a[len1] + (a[len1 + 1] shl 8);
      ar := Copy(a, len1 + 2 + 2, len2 - 2);
      logStr := Format('Зона %x%x%x > %s',
        [a[1], a[2], a[3], BytesToString(ar)]);
      // Synchronize(Log);
      result := False;
    end;

    function CreateTC(a: TArray<byte>): boolean;
    var
      ar: TBytes;
      len1, len2: word;
    begin
      len1 := SizeOf(TTc);
      len2 := a[len1] + (a[len1 + 1] shl 8);
      ar := Copy(a, len1 + 2 + 2, len2 - 2);
      logStr := Format('TC %d:%d > %s', [a[2], a[0] + a[1] shl 8,
        BytesToString(ar)]);
      // Synchronize(Log);
      result := False;
    end;

  // -------------------------
  begin
    result := False;
    if not TryStrToInt(fmain.vle1.Values[pPARENT_ELEMENT], parElement) then
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
{$ENDREGION}

begin
  Clear;
  with dmSigma.qConfig do
  begin
    DisableControls;
    Close;
    Open;
    try
      while not Eof do
      begin
        ConfigArray := FieldByName('BCPCONF').AsBytes;
{$IFDEF DEVMODE}
        // PrintConfig(FieldByName('IDBCP').AsInteger, ConfigArray);
{$ENDIF}
        ParseConfig(ConfigArray);
        Next;
      end;

    finally
      EnableControls;
    end;
  end;

end;

procedure TProcess.GetNetDevice;
var
  i: Integer;
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

  fmain.Memo1.Lines.Add(logStr);
end;

end.
