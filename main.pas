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

  TCu = packed record
  end;

  TGr = packed record
  end;

  TTz = packed record
  end;

  TAl = packed record
  end;

  TUs = packed record
  end;

  TTypeNode = (N_ZONE, N_TC, N_CU, N_GR, N_TZ, N_AL, N_US);

  TNode = record
    kindNode: TTypeNode;
    pcNameLen: byte;
    pcName: UnicodeString;
    parentNode: pointer;
    case integer of
      0:
        (zn: TZone);
      1:
        (tc: TTc);
      2:
        (cu: TCu);
      3:
        (gr: TGr);
      4:
        (tz: TTz);
      5:
        (al: TAl);
      6:
        (us: TUs);
  end;

  TPNode = ^TNode;

const
  pRM_ADDRESS = 'Адрес Рубеж-Монитор';
  pTB = 'База Techbase';
  pPB = 'База Passbase';
  pPARENT_ELEMENT = 'Родительский элемент';
  pPARENT_USER = 'Родительский пользователь';
  pPARENT_DEPARTMENT = 'Родительское подразделение';
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
  //Memo1.Lines.Add(mes.Code.ToString);
end;

procedure Tfmain.FormCreate(Sender: TObject);
begin
  inherited;
  NumberApplication := GetKey('NUMBER', 40);

  with vle1 do
  begin
    Strings.Clear;
    Values[pRM_ADDRESS] := GetKey(pRM_ADDRESS, Values[pRM_ADDRESS]);
    Values[pTB] := GetKey(pTB, Values[pTB]);
    Values[pPB] := GetKey(pPB, Values[pPB]);
    Values['ModuleNetDevice'] := ModuleNetDevice.ToString;
    Values['ModuleBigDevice'] := ModuleBigDevice.ToString;
    Values[pPARENT_ELEMENT] := GetKey(pPARENT_ELEMENT, Values[pPARENT_USER]);
    Values[pPARENT_USER] := GetKey(pPARENT_USER, Values[pPARENT_USER]);
    Values[pPARENT_DEPARTMENT] := GetKey(pPARENT_DEPARTMENT,
      Values[pPARENT_DEPARTMENT]);
    Values[pWORK_MODE] := GetKey(pWORK_MODE, Values[pWORK_MODE]);
    Values[pEVENT] := GetKey(pEVENT, Values[pEVENT]);
    Try
      curEvent:= StrToInt(Values[pEVENT]);
    except
    End;
    saveEvent:= curEvent;
    //
    dmSigma.DB_Protocol.Close;
    dmSigma.DB_Protocol.DatabaseName := vle1.Values[pRM_ADDRESS] + ':' +
      ProtocolDatabaseName;
    dmSigma.DB_Work.Close;
    dmSigma.DB_Work.DatabaseName := vle1.Values[pRM_ADDRESS] + ':' +
      WorkDatabaseName;
    dmRostek.DB_Techbase.Close;
    dmRostek.DB_Techbase.DatabaseName := vle1.Values[pTB];
    dmRostek.DB_Passbase.Close;
    dmRostek.DB_Passbase.DatabaseName := vle1.Values[pPB];
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
     saveEvent:= curEvent;
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
