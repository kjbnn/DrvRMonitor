unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery, Vcl.Grids, Vcl.DBGrids, IBX.IBDatabase, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ValEdit, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.StdActns,
  System.Actions, Vcl.ActnList, System.Types,
  cMainKsb, sigmaEvent;

type
  Tfmain = class(TaMainKsb)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    TabSheet3: TTabSheet;
    DBGrid3: TDBGrid;
    TabSheet4: TTabSheet;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    TabSheet0: TTabSheet;
    DBGrid0: TDBGrid;
    Button7: TButton;
    TabSheet5: TTabSheet;

    vle1: TValueListEditor;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    DBTimer: TTimer;
    Table1Timer: TTimer;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBTimerTimer(Sender: TObject);
    procedure Table1TimerTimer(Sender: TObject);

  private
    function NetProtocolDatabaseName(): String;
    function NetWorkDatabaseName(): String;
    procedure GetBCPElements;
  public
    { Public declarations }
  end;

  TZn = packed record
    zero3: array [0 .. 3] of byte;
    flags: byte; // begin
    number: array [0 .. 3] of byte;
    stringNamePointer: byte;
    status: byte;
    kc: word; // end
    zero4: array [0 .. 3] of byte;
    pcNameLen: byte;
    zero2: array [0 .. 1] of byte;
  end;

  TTc = packed record
    zero3: array [0 .. 3] of byte;
    bcp: word; // begin
    id: word;
    kind: byte; // 0-7
    number: array [0 .. 3] of byte;
    stringNamePointer: byte;
    flags: byte;
    parentZone: array [0 .. 3] of byte;
    group: byte;
    hwType: byte;
    hwSerial: word;
    hwElement: byte;
    tcoConfig: array [0 .. 15] of byte;
    kc: word; // end
    pcNameLen: byte;
    zero2: array [0 .. 1] of byte;
  end;

  TKindNode = (N_ZN, N_TC, N_CU, N_GR, N_TZ, N_AL, N_US);

  TCommonNode = record
    kindNode: TKindNode;
    parent: pointer;
  end;

  TZnNode = record
    node: TCommonNode;
    zn: TZn;
  end;

  TTcNode = record
    node: TCommonNode;
    pcName: array of byte;
  end;

  TCuNode = record
    node: TCommonNode;
  end;

  TGrNode = record
    node: TCommonNode;
  end;

  TTzNode = record
    node: TCommonNode;
  end;

  TAlNode = record
    node: TCommonNode;
  end;

  TUsNode = record
    node: TCommonNode;
  end;

  TPCommonNode = ^TCommonNode;
  TPZnNode = ^TZnNode;
  TPTcNode = ^TTcNode;
  TPCuNode = ^TCuNode;
  TPGrNode = ^TGrNode;
  TPTzNode = ^TTzNode;
  TPAlNode = ^TAlNode;
  TPUsNode = ^TUsNode;

const
  pRM_ADDRESS = 'Адрес Рубеж-Монитор';
  pTB = 'База Techbase';
  pPB = 'База Passbase';
  pPARENT_ELEMENT = 'Родительский элемент';
  pPARENT_USER = 'Родительский пользователь';
  pPARENT_DEPARTMENT = 'Родительское подразделение';
  pEVENT = 'Событие';

var
  fmain: Tfmain;
  curEvent: Int64 = 0;
  BCPElements: Tlist;
  sigmaEvent: TSigmaEvent;

implementation

{$R *.dfm}

uses
  sigma, rostek, IBX.IBServices,
  constants, connection, SharedBuffer;

const
  ProtocolDatabaseName = 'c:\Рубеж\DB\Protocol\PROTOCOL.gdb';
{$IF defined (DEVMODE)} // need_define
  WorkDatabaseName = 'c:\bank\test\R08Work.gdb';
{$ELSE}
  WorkDatabaseName = 'c:\Рубеж\DB\R08Work.gdb';
{$ENDIF}


procedure Tfmain.FormCreate(Sender: TObject);
begin
  inherited;
  NumberApplication := 40;
  NumberApplication := GetKey('NUMBER', 40);
  with vle1.Strings do
  begin
    Clear;
    Add(pRM_ADDRESS + '=' + 'localhost');
    Add(pTB + '=' + 'localhost/3051:d:\Database\Techbase.gdb');
    Add(pPB + '=' + 'localhost/3051:d:\Database\Passbase.gdb');
    Add('NetDevice' + '=' + '1');
    Add('BigDevice' + '=' + '1');
    Add(pPARENT_ELEMENT + '=' + '0');
    Add(pPARENT_USER + '=' + '0');
    Add(pPARENT_DEPARTMENT + '=' + '0');
    Add(pEVENT + '=' + '0');
  end;

  with vle1 do
  begin
    Values[pRM_ADDRESS] := GetKey(pRM_ADDRESS, Values[pRM_ADDRESS]);
    Values[pTB] := GetKey(pTB, Values[pTB]);
    Values[pPB] := GetKey(pPB, Values[pPB]);
    Values['NetDevice'] := GetKey('NetDevice', Values['NetDevice']);
    Values['BigDevice'] := GetKey('BigDevice', Values['BigDevice']);
    Values[pPARENT_ELEMENT] := GetKey(pPARENT_ELEMENT, Values[pPARENT_USER]);
    Values[pPARENT_USER] := GetKey(pPARENT_USER, Values[pPARENT_USER]);
    Values[pPARENT_DEPARTMENT] := GetKey(pPARENT_DEPARTMENT,
      Values[pPARENT_DEPARTMENT]);
    Values[pEVENT] := GetKey(pEVENT, Values[pEVENT]);
    //
    dmSigma.DB_Protocol.DatabaseName := NetProtocolDatabaseName;
    dmSigma.DB_Work.DatabaseName := NetWorkDatabaseName;
    dmRostek.DB_Techbase.DatabaseName := vle1.Values[pTB];
    dmRostek.DB_Passbase.DatabaseName := vle1.Values[pPB];
  end;

  sigmaEvent:= TSigmaEvent.Create;
end;

procedure Tfmain.DBTimerTimer(Sender: TObject);
begin
  exit;
  try
    if not dmSigma.DB_Protocol.Connected then
      dmSigma.DB_Protocol.Close;
    if not dmSigma.DB_Work.Connected then
      dmSigma.DB_Work.Close;
    if not dmRostek.DB_Techbase.Connected then
      dmRostek.DB_Techbase.Close;
    if not dmRostek.DB_Passbase.Connected then
      dmRostek.DB_Passbase.Close;
  finally
  end;
end;

function Tfmain.NetProtocolDatabaseName: String;
begin
  result := vle1.Values[pRM_ADDRESS] + ':' + ProtocolDatabaseName;
end;

function Tfmain.NetWorkDatabaseName: String;
begin
  result := vle1.Values[pRM_ADDRESS] + ':' + WorkDatabaseName;
end;

procedure Tfmain.Table1TimerTimer(Sender: TObject);
begin
  vle1.Values[pEVENT] := curEvent.ToString + ' (' + myindex.ToString + ')';
end;

procedure Tfmain.Button7Click(Sender: TObject);
begin
  try
    dmSigma.IBQuery4.Open;
  except
    MessageBox(0, 'Error q4', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button4Click(Sender: TObject);
begin
  try
    dmSigma.IBQuery2.Open;
  except
    MessageBox(0, 'Error q2', 'MyCaption', 0);
  end;

end;

procedure Tfmain.Button5Click(Sender: TObject);
begin
  try
    dmSigma.IBQuery3.Open;
  except
    MessageBox(0, 'Error q3', 'MyCaption', 0);
  end;
end;

{ -------------- }
{ GetBCPElements }
{ -------------- }
procedure Tfmain.GetBCPElements;
var
  ConfigArray: TArray<byte>; // TBytes;

{$REGION 'Clear'}
  procedure Clear;
  var
    p: pointer;
    pcn: TPCommonNode;
    pzn: TPZnNode;
    ptc: TPTcNode;
    pcu: TPCuNode;
    pgr: TPGrNode;
    ptz: TPTzNode;
    pal: TPAlNode;
    pus: TPUsNode;

  begin
    for p in BCPElements do
      if p <> nil then
      begin
        pcn := p;

        case pcn^.kindNode of

          N_ZN:
            begin
              pzn := p;
              Dispose(pzn);
              BCPElements.Remove(pzn);
            end;

          N_TC:
            begin
              ptc := p;
              Dispose(ptc);
              BCPElements.Remove(ptc);
            end;

          N_CU:
            begin
              pcu := p;
              Dispose(pcu);
              BCPElements.Remove(pcu);
            end;

          N_GR:
            begin
              pgr := p;
              Dispose(pgr);
              BCPElements.Remove(pgr);
            end;

          N_TZ:
            begin
              ptz := p;
              Dispose(ptz);
              BCPElements.Remove(ptz);
            end;

          N_AL:
            begin
              pal := p;
              Dispose(pal);
              BCPElements.Remove(pal);
            end;

          N_US:
            begin
              pus := p;
              Dispose(pus);
              BCPElements.Remove(pus);
            end;
        end;

      end;
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
      WriteLn(tf, 'БЦП: ' + bcpNumber.ToString + '  data: ' + Length(a)
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
  const
    LEN_START = 6;
    LEN_ZONE = 2;
    LEN_TC = 2;

  type
    TElememntType = (ET_ZONE, ET_TC);

  var
    cur, len: longword;
    zi, tci, ci, znCount, tcCount, cuCount: word;
    et: TElememntType;

    function TestZone(et: TElememntType): boolean;
    begin
    end;

    function CreateBCP(a: TArray<byte>): boolean;
    begin
      result := False;
    end;

    function CreateZone(a: TArray<byte>): boolean;
    begin
      result := False;
    end;

  // -------------------------
  begin
    len := Length(a);
    result := False;

    // start
    if (a[0] <> $75) or (a[1] <> $01) or (LEN_START >= len) then
      exit;
    CreateBCP(a);
    znCount := (a[4] shl 8) + a[5];
    cur := LEN_START;
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
{$IFDEF DEVMODE1}
        PrintConfig(FieldByName('IDBCP').AsInteger, ConfigArray);
{$ENDIF}
        ParseConfig(ConfigArray);
        Next;
      end;

    finally
      EnableControls;
    end;
  end;

end;

Initialization

BCPElements := Tlist.Create;

Finalization

end.
