unit rostek;


interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL;

type
  TdmRostek = class(TDataModule)
    DB_Techbase: TIBDatabase;
    TR_Techbase: TIBTransaction;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    DB_Passbase: TIBDatabase;
    TR_Passbase: TIBTransaction;
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
