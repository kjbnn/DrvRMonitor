// {$A-}
unit cAppKsb;

interface

uses WinApi.ShellApi, System.IniFiles, Vcl.Dialogs, Connection, SharedBuffer;

type
    KSBAPPLICATION = record
        Visible : boolean;
        Command : Integer;
        LiveCount : integer;
        FailCount : integer;
        Fill : array[0..2] of BYTE;
end;

type
    ARRAYKSBAPPLICATION = array [0..64] of KSBAPPLICATION;
type
    PARRAYKSBAPPLICATION=^ARRAYKSBAPPLICATION;

type
    TAppKsb = class
      private
        procedure SetCommand(value : integer);
        function  GetCommand : integer;
        procedure SetFailCount(value : integer);
        function  GetFailCount : integer;
        procedure SetLiveCount(value : integer);
        function  GetLiveCount : integer;
        function  GetVisible : boolean;
        procedure SetVisible(value : boolean);
      protected
        KsbApplication : PARRAYKSBAPPLICATION;
      published
        property Command : Integer read GetCommand write SetCommand;
        property FailCount : Integer read GetFailCount write SetFailCount;
        property LiveCount : Integer read GetLiveCount write SetLiveCount;
        property Visible : boolean read GetVisible write SetVisible;
      public
        Number : integer;
        _Class : string;
        _Caption : string;
        _Name: string; //bsl, 27.06.2014
        ExeName : string;
        BmpName : string;
        KillCount : integer;
        StartCount : integer;
        ReStartCount : integer;
        Enabled  : boolean;
        AppName : string;
        SlowCount : integer;
        SlowRestart : integer;
        _ReStartCount : integer;
        ReLive : integer;
        procedure Kill;
        procedure Close;
        procedure Start;
        constructor Create(Num : integer);
end;

implementation

uses System.Sysutils, WinApi.Windows, cBuilderAppKsb;

procedure TAppKsb.SetFailCount(value : integer);
begin
    KsbApplication[Number].FailCount:=value;
end;

function TAppKsb.GetFailCount : integer;
begin
    Result:=KsbApplication[Number].FailCount;
end;

procedure TAppKsb.SetLiveCount(value : integer);
begin
    KsbApplication[Number].LiveCount:=value;
end;

function TAppKsb.GetLiveCount : integer;
begin
    Result:=KsbApplication[Number].LiveCount;
end;

//bsl, 27.06.2014
procedure TAppKsb.Start;
var
    ProgramHandle: HWND;
    InstanceHandle: HINST;
    ConHandle: HWND;
begin
    Command:=0;
    FailCount:=0;
    ProgramHandle:=0;
    InstanceHandle:=0;
    ConHandle:=0;
    try
        // Запуск ----------------------------------------------------------
        if(Visible)then
            InstanceHandle:=ShellExecute(ConHandle, nil, PChar(ExeName), nil, nil, SW_SHOW)
        else
            InstanceHandle:=ShellExecute(ConHandle, nil, PChar(ExeName), nil, nil, SW_HIDE);
        if(InstanceHandle>32)then
            WriteLog(Format('%s - успешно запущен',[ExeName]))
        else
            WriteLog(Format('%s - ошибка запуска (error=%d)',[ExeName, InstanceHandle]));
    except
        WriteLog('Ошибка запуска '+ExeName);
    end;
end;

procedure TAppKsb.SetVisible(value : boolean);
begin
    KsbApplication[Number].Visible:=value;
end;

function TAppKsb.GetVisible : boolean;
begin
    Result:=KsbApplication[Number].Visible;
end;

procedure TAppKsb.SetCommand(value : integer);
begin
    KsbApplication[Number].Command:=value;
end;

function  TAppKsb.GetCommand : integer;
begin
    Result:=KsbApplication[Number].Command;
end;
//-----------------------------------------------------------------------------
procedure TAppKsb.Kill;
var
    h : integer;
    Pid : DWORD;
    ps : THANDLE;
begin
    Command:=KILL_SELF;
    while true do
      begin
        h:=FindWindow(PChar(_class),PChar(_caption));
        if(h=0) then
            h:=FindWindow(PChar(_class),'');
        if(h=0) then
          begin
            exit;
          end;
        GetWindowThreadProcessId(h,@Pid);
        //bsl, 27.06.2014
        //ps := OpenProcess(PROCESS_ALL_ACCESS,false,Pid);
        ps:=OpenProcess(PROCESS_TERMINATE,false,Pid);
        TerminateProcess(ps,DWORD(-1));
        CloseHandle(ps);
    end;
end;

//bsl, 27.06.2014
procedure TAppKsb.Close;
begin
    Command:=CLOSE_SELF;
end;
//-----------------------------------------------------------------------------
constructor TAppKsb.Create(Num : integer);
var
    ini : TIniFile;
begin
    SlowCount:=0;
    ReLive:=0;
    Number:=Num;

    KsbApplication:=CreateShared('KSBAPPLICATION',4096);
    ini:=TIniFile.Create(ReadPath()+'setting.ini');
    Enabled:=ini.ReadInteger('GUARDKSB',Format('ONOFF_%u',[Number]),0)=1;
    _Class:=ini.ReadString('GUARDKSB',Format('CLASS_%u',[Number]),'');
    _Caption:=ini.ReadString('GUARDKSB',Format('CAPTION_%u',[Number]),'');
    _Name:=ini.ReadString('GUARDKSB',Format('NAME_%u',[Number]),'');
    ExeName:=ini.ReadString('GUARDKSB',Format('ExeName_%u',[Number]),'');
    BmpName:=ini.ReadString('GUARDKSB',Format('BmpName_%u',[Number]),'');
    KillCount:=ini.ReadInteger('GUARDKSB',Format('KillCount_%u',[Number]),-1);
    StartCount:=ini.ReadInteger('GUARDKSB',Format('StartCount_%u',[Number]),-1);
    SlowRestart:=ini.ReadInteger('GUARDKSB',Format('SlowRestart_%u',[Number]),3600);
    AppName:=AnsiUpperCase(ExtractFileName(ExeName));

    if(Length(AppName)>4) then
      begin
        SetLength(AppName,Length(AppName)-4);
        ReStartCount:=ini.ReadInteger(AppName,'RESTARTCOUNT',65535);
        _ReStartCount:=ReStartCount;
      end
    else
      begin
        AppName:=ExtractFileName(ParamStr(0));
        SetLength(AppName,Length(AppName)-4);
      end;
    ini.Free;
end;
//-----------------------------------------------------------------------------
end.
