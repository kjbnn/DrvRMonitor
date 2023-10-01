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
    N2: TMenuItem;
    N_One: TMenuItem;
    N_All: TMenuItem;
    N_Stop: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    UpdateConfigTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N_OneClick(Sender: TObject);
    procedure N_AllClick(Sender: TObject);
    procedure N_StopClick(Sender: TObject);
    procedure ClearCheckedMenu;
    procedure N3Click(Sender: TObject);
    procedure UpdateConfigTimerTimer(Sender: TObject);
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

  TGr = packed record
    Num: byte;
    TextNamePointer: byte;
    kc: word;
  end;

  TNu = packed record
    HardwareID: array [0 .. 2] of byte;
    HWVersion: word;
    NDCFlagsWord: byte;
    NDConfig: array [0 .. 7] of byte;
    kc: word;
  end;

  TUser = packed record
    UserFlagsWord: byte;
    ID: word;
    IdentifierType: byte;
    IdentifierCodeDataUnion: array [0 .. 7] of byte;
    Pincode: Longword;
    AL: byte;
    CheckRulesLevel: byte;
    RObjectNumber: array [0 .. 3] of byte;
    LifeTime: Longword;
    AccessToBCP: byte;
    AL2: byte;
    TimeZoneForOwnerZone: byte;
    Weight: byte;
    kc: word;
  end;

  TPUser = ^TUser;

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

  case SigmaOperation of
    OP_STOP_EVENT:
      if not N_Stop.Checked then
      begin
        ClearCheckedMenu;
        N_Stop.Checked := True;
      end;

    OP_NEXT_ONE_EVENT:
      if not N_One.Checked then
      begin
        ClearCheckedMenu;
        N_One.Checked := True;
      end;

    OP_NEXT_EVENT:
      if not N_All.Checked then
      begin
        ClearCheckedMenu;
        N_All.Checked := True;
      end;

  end;

end;

procedure Tfmain.UpdateConfigTimerTimer(Sender: TObject);
begin
  SigmaOperation := OP_SYNC_CONFIG;
  TTimer(Sender).Enabled:= False;
end;

procedure Tfmain.N1Click(Sender: TObject);
var
  mes: KSBMES;
begin
  Init(mes);
  mes.Code := 11111;
  send(mes);
end;

procedure Tfmain.ClearCheckedMenu;
begin
  N_Stop.Checked := False;
  N_One.Checked := False;
  N_All.Checked := False;
end;

procedure Tfmain.N_StopClick(Sender: TObject);
begin
  SigmaOperation :=  OP_STOP_EVENT;
end;

procedure Tfmain.N_OneClick(Sender: TObject);
begin
  SigmaOperation := OP_NEXT_ONE_EVENT;
end;

procedure Tfmain.N_AllClick(Sender: TObject);
begin
  SigmaOperation := OP_NEXT_EVENT;
end;

procedure Tfmain.N3Click(Sender: TObject);
begin
  SigmaOperation:= OP_SYNC_CONFIG;
end;

Initialization

Finalization

end.
