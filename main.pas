unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery, Vcl.Grids, Vcl.DBGrids, IBX.IBDatabase, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ValEdit, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.StdActns,
  System.Actions, Vcl.ActnList, System.Types,
  cMainKsb;

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
    RemoteHost: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    TabSheet0: TTabSheet;
    DBGrid0: TDBGrid;
    Button7: TButton;
    TabSheet5: TTabSheet;
    ValueListEditor1: TValueListEditor;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Button9: TButton;
    Memo2: TMemo;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);

  private
    function NetProtocolDatabaseName(): String;
    function NetWorkDatabaseName(): String;
    procedure GetBCPElements;
  public
    { Public declarations }
  end;

  TKindNode = (N_ZN, N_TC, N_CU, N_GR, N_TZ, N_AL, N_US);

  TCommonNode = record
    kindNode: TKindNode;
    parent: pointer;
  end;

  TZnNode = record
    node: TCommonNode;
    flag: byte;
    number: array [0 .. 3] of byte;
    textIndex: byte;
    status: byte;
    kc: word;
    zero4: array [0 .. 3] of byte;
    pcNameLen: byte;
    pcName: array of byte; // need_ask
    zero36: array [0 .. 35] of byte; // need_ask
  end;

  TTcNode = record
    node: TCommonNode;
    number: array [0 .. 3] of byte;
    parentZone: array [0 .. 3] of byte;
    HW: byte;
    pcNameLen: byte;
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

var
  fmain: Tfmain;
  BCPElements: Tlist;

implementation

{$R *.dfm}

uses
  dm, IBX.IBServices,
  constants, connection, SharedBuffer;

const
  ProtocolDatabaseName = 'c:\Рубеж\DB\Protocol\PROTOCOL.gdb';
{$IF defined (DEVMODE)} // need_define
  WorkDatabaseName = 'c:\bank\test\R08Work.gdb';
{$ELSE}
  WorkDatabaseName = 'c:\Рубеж\DB\R08Work.gdb';
{$ENDIF}

function Tfmain.NetProtocolDatabaseName: String;
begin
  result := RemoteHost.Text + ':' + ProtocolDatabaseName;
end;

function Tfmain.NetWorkDatabaseName: String;
begin
  result := RemoteHost.Text + ':' + WorkDatabaseName;
end;

procedure Tfmain.Button1Click(Sender: TObject);
begin
  try
    fdm.IBBackupService1_Protocol.Active := False;
    fdm.IBBackupService1_Protocol.ServerName := RemoteHost.Text;
    fdm.IBBackupService1_Protocol.Protocol := TCP;
    fdm.IBBackupService1_Protocol.DatabaseName := ProtocolDatabaseName;
    fdm.IBBackupService1_Protocol.BackupFile.Clear;
    fdm.IBBackupService1_Protocol.BackupFile.Add(GetCurrentDir + '\mybp_p.gbk');
    fdm.IBBackupService1_Protocol.Active := True;
    fdm.IBBackupService1_Protocol.ServiceStart;
  except
    MessageBox(0, 'Error pack_p', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button2Click(Sender: TObject);
begin
  try
    fdm.IBBackupService1_Work.Active := False;
    fdm.IBBackupService1_Work.ServerName := RemoteHost.Text;
    fdm.IBBackupService1_Work.Protocol := TCP;
    fdm.IBBackupService1_Work.DatabaseName := WorkDatabaseName;
    fdm.IBBackupService1_Work.BackupFile.Clear;
    fdm.IBBackupService1_Work.BackupFile.Add
      (ExtractFilePath(Application.ExeName) + '\mybp_w.gbk');
    fdm.IBBackupService1_Work.Active := True;
    fdm.IBBackupService1_Work.ServiceStart;
  except
    MessageBox(0, 'Error pack_w', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button7Click(Sender: TObject);
begin
  try
    fdm.IBQuery4.Open;
  except
    MessageBox(0, 'Error q4', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button3Click(Sender: TObject);
begin
  try
    fdm.IBQuery1.Open;
  except
    MessageBox(0, 'Error q1', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button4Click(Sender: TObject);
begin
  try
    fdm.IBQuery2.Open;
  except
    MessageBox(0, 'Error q2', 'MyCaption', 0);
  end;

end;

procedure Tfmain.Button5Click(Sender: TObject);
begin
  try
    fdm.IBQuery3.Open;
  except
    MessageBox(0, 'Error q3', 'MyCaption', 0);
  end;
end;

procedure Tfmain.Button6Click(Sender: TObject);
begin
  fdm.DB_Protocol.Close;
  fdm.DB_Protocol.DatabaseName := NetProtocolDatabaseName;
  fdm.DB_Work.Close;
  fdm.DB_Work.DatabaseName := NetWorkDatabaseName;
end;

procedure Tfmain.Button8Click(Sender: TObject);
begin
  fdm.IBScript1.ExecuteScript;
end;

procedure Tfmain.Button9Click(Sender: TObject);
begin
  GetBCPElements;
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


  type
    TOperation = (OP_VERIFY, OP_BCP, OP_ZN_UMBER, OP_TC_NUMBER, OP_ZN, OP_TC);
    TKindCfgNode = (CN_BCP, CN_NZN, CN_CU, CN_TC);

    function CreateCfgNode: boolean;
    begin
      result := False;
    end;

    function CreateBCP(a: TArray<byte>): boolean;
    begin
      result := False;
      // need_code
    end;

  var
    i, j: longword;
    len: longword;
    op: TOperation;
    znCount: word;

  begin
    len := Length(a);
    result := False;

    // start
    i := 2;
    if (a[0] <> $75) or (a[1] <> $01) or (i >= len) then
      exit;

    // BCP
    i := 4;
    if (i >= len) then
      exit
    else
      CreateBCP(a);

    // znCount
    i := 6;
    if (i >= len) then
      exit
    else
      znCount := (a[i - 2] shl 8) + a[i - 1] shl 8;

    // zn
    i := 10;
    for j := 1 to znCount do
    begin
      //ve(a[i-1], )
    end;



    while i < len do
    begin
      case op of
        OP_BCP:
          ;
        OP_ZN_UMBER:
          ;
        OP_TC_NUMBER:
          ;
        OP_ZN:
          ;
        OP_TC:
          ;
      end;
      inc(i);
    end;

  end;
{$ENDREGION}

begin
  Clear;
  with fdm.qConfig do
  begin
    DisableControls;
    Close;
    Open;
    try
      while not Eof do
      begin
        ConfigArray := FieldByName('BCPCONF').AsBytes;
{$IFDEF DEVMODE}
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

{ ----------- }
{ ParseConfig }
{ ----------- }

Initialization

BCPElements := Tlist.Create;

Finalization

end.
