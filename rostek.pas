unit rostek;


interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL;

type
  TdmRostek = class(TDataModule)
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
    IBQuery4: TIBQuery;
    DataSource4: TDataSource;
    IBEvents1: TIBEvents;
    IBScript1: TIBScript;
    qConfig: TIBQuery;
    sConfig: TDataSource;
    procedure IBEvents1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRostek: TdmRostek;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Vcl.Dialogs, main;

{$R *.dfm}

procedure TdmRostek.IBEvents1EventAlert(Sender: TObject; EventName: string;
  EventCount: Integer; var CancelAlerts: Boolean);
begin
  //ShowMessage('Есть событие.');
  fmain.Memo1.Lines.Add( Format('%s %d %s',[EventName, EventCount, CancelAlerts.ToString] ) );
end;

end.
