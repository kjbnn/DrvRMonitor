// {$A-}
unit cMainKsb;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.Menus, VCL.ExtCtrls, VCL.StdCtrls, connection, VCL.Grids, cAppKsb, SharedBuffer, System.UITypes;

type
  TaMainKsb = class(TForm)
    InitTimer: TTimer;
    TimerVisible: TTimer;
    TimerStop: TTimer;
    procedure miExitClick(Sender: TObject);
    procedure miHideClick(Sender: TObject);
    procedure InitTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerVisibleTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerStopTimer(Sender: TObject);
  private
    KsbList : TStringList;
    procedure WMQueryEndSession(var Message: TWMEndSession); message WM_QUERYENDSESSION;
  public
    NumberApplication : integer;
    AppKsb : TAppKsb;
    _Visible : integer;
    KsbNet : TSharedString;
    ModuleNetDevice : WORD;
    ModuleBigDevice : WORD;
    procedure Send(str:Ansistring); overload; virtual;
    procedure Send(mes:KSBMES);overload; virtual;
    procedure Send(mes:KSBMES;str:PAnsiChar); overload; virtual;
    procedure Consider(mes:KSBMES); overload; virtual;
    procedure Consider(mes:KSBMES; str:AnsiString); overload; virtual;
    procedure FreeAllTimer;
    procedure SwitchAllTimer(value : boolean);
    procedure SelfKill;
    procedure SelfClose; //bsl, 27.06.2014
    procedure CheckExecute(_load : boolean; _show : boolean);
    procedure ClearBuffer;
  end;

var
  aMainKsb: TaMainKsb;

implementation

uses constants;

{$R *.DFM}

//-----------------------------------------------------------------------------
procedure TaMainKsb.miHideClick(Sender: TObject);
begin
    AppKsb.Visible:=false;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.InitTimerTimer(Sender: TObject);
var
    mes : KSBMES;
begin
    InitTimer.Free;
    Init(mes);
    mes.SysDevice:=SYSTEM_PROGRAM;
    mes.NetDevice:=ModuleNetDevice;
    mes.BigDevice:=NumberApplication;
    mes.TypeDevice:=3;
    mes.NumDevice:=0;
    mes.Code:=START_PROGRAM;
    Send(mes);
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.FormCreate(Sender: TObject);
begin
    try
        if(ReadPath='') then
          begin
            SelfKill;
          end
        else
          begin
            GetKey('RESTARTCOUNT',65535);
            CheckExecute(true,false);
            Caption:=Application.Title;
            StoppedFlag:=0;

            _Visible:=GetKey('VISIBLE',0);
            ModuleNetDevice:=GetKey('MODULENETDEVICE',0);
            ModuleBigDevice:=GetKey('MODULEBIGDEVICE',0);
            SetKey('CLASS',ClassName);
            SetKey('CAPTION',Application.Title);
            SetKey('NUMBER',NumberApplication);

            FormatSettings.DateSeparator:='.';
            FormatSettings.TimeSeparator:=':';
            FormatSettings.ShortTimeFormat:='hh:mm:ss';
            FormatSettings.ShortDateFormat:='dd.mm.yyyy';

            if(NumberApplication=0) then
                NumberApplication:=GetKey('KSBAPPLICATION',0);
            AppKsb:=TAppKsb.Create(NumberApplication);
            KsbList:=TStringList.Create;
            KsbNet:=TSharedString.Create(self);
            if(KsbNet._Init(AppKsb.AppName,true,4096)=false)then
              begin
                MessageDlg('Ошибка инициализации программы!',mtError,[mbOk],0);
                Application.Terminate;
              end;
          end;
    except
        MessageDlg('Фатальная ошибка запуска программы!',mtError,[mbOk],0);
        Application.Terminate;
    end;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.TimerVisibleTimer(Sender: TObject);
var
    j : integer;
    mes : KSBMES;
    str : string;
    s : string;
begin
    TimerVisible.Enabled:=false;
    case _Visible of
        -1:
          begin
            Visible:=false;
          end;
        0:
          begin
            Visible:=AppKsb.Visible;
          end;
        1:
          begin
            Visible:=true;
          end;
    end;//case

    case AppKsb.Command of
        KILL_SELF:
          begin
            AppKsb.Command:=0;
            SelfKill;
            exit;
          end;
        //bsl, 27.06.2014
        CLOSE_SELF:
          begin
            AppKsb.Command:=0;
            SelfClose;
            exit;
          end;
    end;
    //--
    KsbNet.Receive(KsbList);
    j:=0;
    while j<KsbList.Count do
      begin
        str:=KsbList.Strings[j];
        try
            Simbol2Bin(str,@mes,sizeof(KSBMES));
            if(mes.Size>0) then
                s:=PChar(@str[sizeof(KSBMES)*2+1]);
        except
        end;
        Consider(mes);
        Consider(mes,s);
        Inc(j);
      end;
    KsbList.Clear();
    TimerVisible.Enabled:=true;
end;

procedure TaMainKsb.Consider(mes : KSBMES);
begin
//
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.Send(mes : KSBMES);
begin
    if(mes.Code=0) then
        exit;
    if(mes.Proga=$FFFF) then
        mes.Proga:=NumberApplication;
    KsbNet.SendInBuffer(Bin2Simbol(mes));
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.Send(mes:KSBMES; str:PAnsiChar);
begin
    if(mes.Code=0) then
        exit;
    mes.Proga:=NumberApplication;
    KsbNet.SendInBuffer(Bin2Simbol(mes)+Bin2Simbol(str,mes.Size));
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.Send(str:AnsiString);
begin
    str:=Trim(str);
    if(str='') then
        exit;
    KsbNet.SendInBuffer(str);
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.FreeAllTimer;
var
    i : integer;
    c : TComponent;
    t : TTimer;
begin
    i:=0;
    while i<ComponentCount do
      begin
        c:=Components[i];
        if((c.ClassName='TTimer') and (c.Name<>'TimerStop')) then
          begin
            t:=c as TTimer;
            t.Free();
          end;
        Inc(i);
      end;
    KsbNet.Free;
    Show;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.SwitchAllTimer(value : boolean);
var
    i : integer;
    c : TComponent;
    t : TTimer;
begin
    i:=0;
    while i<ComponentCount do
      begin
        c:=Components[i];
        if((c.ClassName='TTimer') and (c.Name<>'TimerStop')) then
          begin
            t:=c as TTimer;
            t.Enabled:=value;
          end;
        Inc(i);
      end;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.miExitClick(Sender: TObject);
begin
    SelfClose;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.SelfKill;
var
    Pid : DWORD;
    ps : THANDLE;
begin
    try
        StoppedFlag:=1;
        SwitchAllTimer(false);
        GetWindowThreadProcessId(handle,@Pid);
        //bsl, 27.06.2014
        //ps:=OpenProcess(PROCESS_ALL_ACCESS,false,Pid);
        ps:=OpenProcess(PROCESS_TERMINATE,false,Pid);
        TerminateProcess(ps,DWORD(-1));
    finally
    end;
end;

//bsl, 27.06.2014
procedure TaMainKsb.SelfClose;
var
    mes : KSBMES;
begin
    Init(mes);
    mes.SysDevice:=SYSTEM_PROGRAM;
    mes.NetDevice:=ModuleNetDevice;
    mes.BigDevice:=NumberApplication;
    mes.TypeDevice:=3;
    mes.NumDevice:=0;
    mes.Code:=STOP_PROGRAM;
    Send(mes);
    TimerStop.Enabled:=true;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    StoppedFlag:=1;
    miExitClick(Sender);
    CanClose:=false;
    ShowMessage('Программа остановлена');
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.TimerStopTimer(Sender: TObject);
begin
    SelfKill();
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.Consider(mes:KSBMES; str:AnsiString);
var
    p:PAnsiChar;
begin
    p:=PAnsiChar(@mes);
    if((p[0]<>AnsiChar($aa)) or ((p[1]<>AnsiChar($55))and(p[1]<>AnsiChar($50))) ) then
      begin
        WriteLog(' Неизвестен формат сообщения '+p);
        exit;
      end;
    case mes.Code of
        CHECK_LIVE_PROGRAM:
          begin
            Init(mes);
            mes.Code:=I_LIVE_PROGRAM;
            mes.SysDevice:=SYSTEM_PROGRAM;
            mes.NetDevice:=ModuleNetDevice;
            mes.BigDevice:=NumberApplication;
            mes.TypeDevice:=3;
            mes.NumDevice:=0;
            Send(mes);
          end;
        KILL_PROGRAM:
          begin
            if((mes.NetDevice=ModuleNetDevice) and (mes.Proga=NumberApplication)) then
              begin
                SelfKill;
              end;
          end;
        //bsl, 27.06.2014
        EXIT_PROGRAM:
          begin
            if((mes.NetDevice=ModuleNetDevice) and (mes.Proga=NumberApplication)) then
              begin
                SelfClose;
              end;
          end;
    end;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.CheckExecute(_load : boolean; _show : boolean);
var
    Pid : DWORD;
    ps : THANDLE;
    _Name : string;
begin
    _Name:=ExtractFileName(Application.ExeName);
    _Name:=AnsiUpperCase(_Name);
    _Name:=_Name+IntToStr(NumberApplication);

    if(_load=false) then
      begin
        CloseHandle(ApplicationLoaded);
      end
    else
        ApplicationLoaded:=CreateEvent(nil,false,false,@_Name[1]);
    if((GetLastError()=ERROR_ALREADY_EXISTS) and (ParamStr(1)<>'SECOND') ) then
      begin
        if(_show=true) then
            ShowMessage('Программа уже выполняется : '+_Name);
        GetWindowThreadProcessId(Handle,@Pid);
        ps := OpenProcess(PROCESS_ALL_ACCESS	,false,Pid);
        TerminateProcess(ps,DWORD(-1));
      end;
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.WMQueryEndSession(var Message: TWMEndSession);
begin
    SelfKill();
end;
//-----------------------------------------------------------------------------
procedure TaMainKsb.ClearBuffer();
begin
    KsbNet.Clear();
end;
//-----------------------------------------------------------------------------
end.
