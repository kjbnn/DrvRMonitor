unit sigma;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TdmSigma = class(TDataModule)
    DB_Protocol: TIBDatabase;
    TR_Protocol: TIBTransaction;
    qTable1: TIBQuery;
    dsTable1: TDataSource;
    DB_Work: TIBDatabase;
    TR_Work: TIBTransaction;
    IBQuery2: TIBQuery;
    DataSource2: TDataSource;
    IBQuery3: TIBQuery;
    DataSource3: TDataSource;
    IBQuery4: TIBQuery;
    DataSource4: TDataSource;
    qConfig: TIBQuery;
    sConfig: TDataSource;
    IBEvents1: TIBEvents;
    IBScript1: TIBScript;
    IBQuery5: TIBQuery;
    FDConnection1: TFDConnection;
    procedure IBEvents1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSigma: TdmSigma;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Vcl.Dialogs, main;

{$R *.dfm}

procedure TdmSigma.IBEvents1EventAlert(Sender: TObject; EventName: string;
  EventCount: Integer; var CancelAlerts: Boolean);
begin
  // ShowMessage('���� �������.');
  fmain.Memo1.Lines.Add(Format('%s %d %s', [EventName, EventCount,
    CancelAlerts.ToString]));
end;

end.
