unit dm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL;

type
  TDataModule1 = class(TDataModule)
    DB_Protocol: TIBDatabase;
    TR_Protocol: TIBTransaction;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    DB_Work: TIBDatabase;
    TR_Work: TIBTransaction;
    IBQuery2: TIBQuery;
    DataSource2: TDataSource;
    IBQuery3: TIBQuery;
    DataSource3: TDataSource;
    IBBackupService1_Protocol: TIBBackupService;
    IBBackupService1_Work: TIBBackupService;
    IBQuery4: TIBQuery;
    DataSource4: TDataSource;
    IBEvents1: TIBEvents;
    IBScript1: TIBScript;
    procedure DataModuleCreate(Sender: TObject);
    procedure IBEvents1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses main, Vcl.Dialogs;

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
 fmain.Button6Click(self);
end;

procedure TDataModule1.IBEvents1EventAlert(Sender: TObject; EventName: string;
  EventCount: Integer; var CancelAlerts: Boolean);
begin
  //ShowMessage('Есть событие.');
  fmain.Memo1.Lines.Add( Format('%s %d %s',[EventName, EventCount, CancelAlerts.ToString] ) );
end;

end.
