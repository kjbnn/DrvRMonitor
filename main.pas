unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery, Vcl.Grids, Vcl.DBGrids, IBX.IBDatabase, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ValEdit, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.StdActns,
  System.Actions, Vcl.ActnList, System.Types,
  cMainKsb, Process, SharedBuffer, Vcl.Menus;

type
  Tfmain = class(TaMainKsb)
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    vle1: TValueListEditor;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    RefreshTimer: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
  public
    procedure Consider(mes: KSBMES); override;
  end;

  TZone = packed record
    flags: byte;
    number: array [0 .. 3] of byte;
    stringNamePointer: byte;
    status: byte;
    kc: word;
    zero4: array [0 .. 3] of byte;
  end;

  TTc = packed record
    bcp: word;
    id: word;
    kind: byte; // 0-7
    number: array [0 .. 3] of byte;
    stringNamePointer: byte;
    flags: byte;
    parentZone: array [0 .. 3] of byte;
    group: byte;
    hwType: byte;
    hwSerial: word;
    hwElement: byte;
    tcoConfig: array [0 .. 15] of byte;
    kc: word;
  end;

const
  pRM_ADDRESS = 'Адрес Рубеж-Монитор';
  pTB = 'База Techbase (TB)';
  pPB = 'База Passbase (PB)';
  pPARENT_ELEMENT = 'Родительский элемент TB';
  pWORK_MODE = 'Режим работы';
  pEVENT = 'Событие';

var
  fmain: Tfmain;
  saveEvent: Int64 = 0;
  curEvent: Int64 = 0;
  Process: TProcess;

implementation

{$R *.dfm}

uses
  sigma, rostek, IBX.IBServices,
  constants, connection;

const
  ProtocolDatabaseName = 'c:\Рубеж\DB\Protocol\PROTOCOL.gdb';
  WorkDatabaseName = 'c:\Рубеж\DB\R08Work.gdb';

procedure Tfmain.Consider(mes: KSBMES);
begin
  inherited;
  // Memo1.Lines.Add(mes.Code.ToString);
end;

procedure Tfmain.FormCreate(Sender: TObject);
begin
  NumberApplication := GetKey('NUMBER', 40);
  inherited;

  with vle1 do
  begin
    Strings.Clear;
    Values[pRM_ADDRESS] := GetKey(pRM_ADDRESS, 'localhost');
    Values[pTB] := GetKey(pTB, 'localhost/3051:d:\Database\Techbase.gdb');
    Values[pPB] := GetKey(pPB, 'localhost/3051:d:\Database\Passbase.gdb');
    Values['ModuleNetDevice'] := ModuleNetDevice.ToString;
    Values['ModuleBigDevice'] := ModuleBigDevice.ToString;
    Values[pPARENT_ELEMENT] := GetKey(pPARENT_ELEMENT, '0');
    Values[pWORK_MODE] := GetKey(pWORK_MODE, '0');

    Values[pEVENT] := GetKey(pEVENT, '0');
    Try
      curEvent := StrToInt(Values[pEVENT]);
    except
    End;
    saveEvent := curEvent;

    //
    dmSigma.DB_Protocol.Close;
    dmSigma.DB_Protocol.DatabaseName := vle1.Values[pRM_ADDRESS] + ':' +
      ProtocolDatabaseName;
    dmSigma.DB_Work.Close;
    dmSigma.DB_Work.DatabaseName := vle1.Values[pRM_ADDRESS] + ':' +
      WorkDatabaseName;
    dmRostek.dTB.Close;
    dmRostek.dTB.DatabaseName := vle1.Values[pTB];
    dmRostek.dPB.Close;
    dmRostek.dPB.DatabaseName := vle1.Values[pPB];
  end;

  StatusBar1.Panels[0].Text := 'Старт: ' + DateTimeToStr(now);
  Process := TProcess.Create;
end;

procedure Tfmain.RefreshTimerTimer(Sender: TObject);
begin
  vle1.Values[pEVENT] := curEvent.ToString + ' (' + testSigmaDb.ToString + ')';
  if (curEvent > saveEvent) then
    try
      SetKey(pEVENT, curEvent);
      saveEvent := curEvent;
    except
    end;
end;

procedure Tfmain.N1Click(Sender: TObject);
var
  mes: KSBMES;
begin
  Init(mes);
  mes.Code := 11111;
  send(mes);
end;

Initialization

Finalization

end.
