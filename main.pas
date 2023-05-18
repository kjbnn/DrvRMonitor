{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery, Vcl.Grids, Vcl.DBGrids, IBX.IBDatabase, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ValEdit, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.StdActns,
  System.Actions, Vcl.ActnList;

type
  Tfmain = class(TForm)
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
    Button8: TButton;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Button9: TButton;
    Memo2: TMemo;
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
    function ParseConfig(a: TArray<byte>): boolean;
  public
    { Public declarations }
  end;

var
  fmain: Tfmain;

implementation

{$R *.dfm}

uses dm, IBX.IBServices;

const
  ProtocolDatabaseName = 'c:\Рубеж\DB\Protocol\PROTOCOL.gdb';
{$IF defined (DEVMODE)}
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
var
  i: longword;
  // abb: TBytes;
  ab: TArray<byte>;
  b: byte;
  tf: Textfile;
begin
  AssignFile(tf, '.\blob.txt');
  ReWrite(tf);
  with fdm.qConfig do
  begin
    DisableControls;
    Close;
    Open;
    try
      while not Eof do
      begin
        ab := FieldByName('BCPCONF').AsBytes;
        WriteLn(tf,
          #13'----------------------------------------------------------');
        WriteLn(tf, '--------------------- БЦП ' + IntToStr(FieldByName('IDBCP')
          .AsInteger) + ' config length - ' + Length(ab).ToString +
          ' ------------------------');
        WriteLn(tf,
          '----------------------------------------------------------');
        Memo2.Lines.Add(Length(ab).ToString);
        i := 1;
        for b in ab do
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
        Next;
      end;

    finally
      EnableControls;
      CloseFile(tf);
    end;
  end;

end;



function Tfmain.ParseConfig(a: TArray<byte>): boolean;
type
  TOperation = (OP_VERIFY, OP_BCP, OP_ZN_UMBER, OP_TC_NUMBER, OP_ZN, OP_TC);
  TKindCfgNode = (CN_BCP, CN_NZN, CN_CU, CN_TC);

  TCfgNode = record
    Kind: TKindCfgNode;
    Number: array [0 .. 3] of byte;
    parentZone: array [0 .. 3] of byte;
    HW: byte;

  end;

  function CreateCfgNode: boolean;
  begin
    result:= False;
  end;

var
  i: longword;
  len: longword;
  op: TOperation;

begin
  len := Length(a);
  op := OP_VERIFY;
  result := False;

  // Find start
  i := 2;
  if (a[0] <> $75) or (a[1] <> $01) or (i >= len) then
    exit;

  // Find BCP
  i := 4;
  if (i >= len) then
    exit;

  while i < len do
  begin
    case op of
      OP_BCP:
        ;
      OP_ZN_UMBER:
        ;
      OP_TC_NUMBER:
        ;
      OP_ZN:;
      OP_TC:
        ;
    end;
    inc(i);
  end;

end;

















end.
