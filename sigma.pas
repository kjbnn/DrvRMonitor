unit Sigma;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, IBX.IBDatabaseINI;

type
  TdmSigma = class(TDataModule)
    DB_Protocol: TIBDatabase;
    TR_Protocol: TIBTransaction;
    DB_Work: TIBDatabase;
    TR_Work: TIBTransaction;
    qEvent: TIBQuery;
    qUsr: TIBQuery;
    qPodraz: TIBQuery;
    qConfig: TIBQuery;
    procedure IBEvents1EventAlert(Sender: TObject; EventName: string;
      EventCount: Integer; var CancelAlerts: Boolean);
  private
  public
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
  fmain.Memo1.Lines.Add(Format('%s %d %s', [EventName, EventCount,
    CancelAlerts.ToString]));
end;

end.
