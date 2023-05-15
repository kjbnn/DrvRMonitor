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
  //WorkDatabaseName = 'c:\Рубеж\DB\R08Work.gdb';
  WorkDatabaseName = 'c:\bank\test\R08Work.gdb';

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
  //abb: TBytes;
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
        WriteLn(tf, #13'----------------------------------------------------------');
        WriteLn(tf, '------------------------ БЦП ' +
                IntToStr(FieldByName('IDBCP').AsInteger) +
                ' ---------------------------');
        WriteLn(tf, '----------------------------------------------------------');
        ab := FieldByName('BCPCONF').AsBytes;
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

end.
