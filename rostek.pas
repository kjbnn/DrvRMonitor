unit Rostek;


interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, IBX.IBServices, IBX.IBScript, IBX.IBEvents, IBX.IBSQL,
  IBX.IBUpdateSQL, IBX.IBTable;

type
  TdmRostek = class(TDataModule)
    dTB: TIBDatabase;
    dPB: TIBDatabase;
    trPB: TIBTransaction;
    trTB: TIBTransaction;
    qTBAny: TIBQuery;
    qPBAny: TIBQuery;
    qTBElement: TIBQuery;
    qPBElement: TIBQuery;
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

end.
