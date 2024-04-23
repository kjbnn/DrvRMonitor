unit Rostek;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL,
  IBX.IBUpdateSQL, IBX.IBTable, IBX.IBSQLMonitor;

type
  TdmRostek = class(TDataModule)
    dTB: TIBDatabase;
    dPB: TIBDatabase;
    trPBr: TIBTransaction;
    trTBr: TIBTransaction;
    qTBAnyR: TIBQuery;
    qPBAnyR: TIBQuery;
    qTBElement: TIBQuery;
    qPBElement: TIBQuery;
    qPBUsr: TIBQuery;
    qRmUsrGr: TIBQuery;
    trTBw: TIBTransaction;
    trPBw: TIBTransaction;
    qTBAnyW: TIBQuery;
    qPBAnyW: TIBQuery;
    IBSQLMonitor1: TIBSQLMonitor;
    procedure IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
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

procedure TdmRostek.IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
begin
  // fmain.Memo1.Lines.Add(EventText);
end;

end.
