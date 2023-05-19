// {$A-}
unit cBuilderAppKsb;

interface

uses System.IniFiles, Vcl.Dialogs, System.Sysutils, WinApi.Windows, System.Win.Registry;

const      ROSTEK_ROOT_KEY = '\Software\RostVSP\';

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
        Number : integer;
        KsbApplication : PARRAYKSBAPPLICATION;
      published
        property Command : Integer read GetCommand write SetCommand;
        property FailCount : Integer read GetFailCount write SetFailCount;
        property LiveCount : Integer read GetLiveCount write SetLiveCount;
        property Visible : boolean read GetVisible write SetVisible;
      public
        _Class : string;
        _Caption : string;
        ExeName : string;
        BmpName : string;
        KillCount : integer;
        StartCount : integer;
        Enabled  : boolean;
        procedure Kill;
        procedure Start;
        constructor Create(Num : integer);
end;

type
    ARRAYBYTE = array[0..1] of BYTE;
type
    PARRAYBYTE = ^ARRAYBYTE;

procedure CloseAppKsb;
function  HideAppKsb : BYTE;
procedure InitAppKsb(num : integer);
procedure LiveAppKsb(num : integer);
function  CreateShared(name : AnsiString; size : DWORD):Pointer;

implementation

uses Vcl.Forms;

var AppKsb : TAppKsb;

//-----------------------------------------------------------------------------
function ReadPath : string;
var
    Reg : TRegistry;
    path : string;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(ROSTEK_ROOT_KEY+'\PathSystem',True) then
        Path:=Reg.ReadString('path');
    Reg.CloseKey;
    Reg.Free;
    Result:=path;
end;
//-----------------------------------------------------------------------------
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

procedure TAppKsb.Kill;
var
    h : integer;
    Pid : DWORD;
    ps : THANDLE;
begin
    while true do
      begin
        h:=FindWindow(PChar(_class),PChar(_caption));
        if(h=0) then
            exit;
        GetWindowThreadProcessId(h,@Pid);
        ps := OpenProcess(1,false,Pid);
        TerminateProcess(ps,1);
    end;
end;

procedure TAppKsb.Start;
begin
    FailCount:=0;
    WinExec(PAnsiChar(ExeName),SW_SHOW);
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
//-----------------------------------------------------------------------------
function  TAppKsb.GetCommand : integer;
begin
    Result:=KsbApplication[Number].Command;
end;
//-----------------------------------------------------------------------------
constructor TAppKsb.Create(Num : integer);
var
    ini : TIniFile;
begin
    Number:=Num;
    KsbApplication:=CreateShared('KSBAPPLICATION',4096);
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    Enabled:=ini.ReadInteger('GUARDKSB',Format('ONOFF_%u',[Number]),0)=1;
    _Class:=ini.ReadString('GUARDKSB',Format('CLASS_%u',[Number]),'');
    _Caption:=ini.ReadString('GUARDKSB',Format('CAPTION_%u',[Number]),'');
    ExeName:=ini.ReadString('GUARDKSB',Format('ExeName_%u',[Number]),'');
    BmpName:=ini.ReadString('GUARDKSB',Format('BmpName_%u',[Number]),'');
    KillCount:=ini.ReadInteger('GUARDKSB',Format('KillCount_%u',[Number]),-1);
    StartCount:=ini.ReadInteger('GUARDKSB',Format('StartCount_%u',[Number]),-1);
    ini.Free;
end;
//-----------------------------------------------------------------------------
procedure InitAppKsb(num : integer);
begin
    AppKsb:=TAppKsb.Create(num);
end;
//-----------------------------------------------------------------------------
procedure LiveAppKsb;
begin
    if(AppKsb<>nil) then
        AppKsb.LiveCount:=AppKsb.LiveCount+num;
end;
//-----------------------------------------------------------------------------
function CreateShared(Name: AnsiString; Size: DWORD): Pointer;
var
    i : DWORD;
    hMapObject : THANDLE;
    Test : PARRAYBYTE;
    fInit : Boolean;
begin
    //bsl, 26.06.2014
    hMapObject:=CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, size, PChar(UpperCase(name)));
    if (hMapObject = 0) then
      begin
        Result :=nil;
        Exit;
      end;
    fInit:= (GetLastError() <> ERROR_ALREADY_EXISTS);
    Result := MapViewOfFile(hMapObject, FILE_MAP_WRITE, 0, 0, 0);
    if Result = nil then
        Exit;
    if fInit then
      begin
        i:=0;
        Test := Result;
        while (i < size) do
          begin
            test[i]:=0;
            Inc(i);
          end;
      end;
end;
//----------------------------------------------------------------------------
function HideAppKsb:BYTE;
begin
    if(AppKsb<>nil) then
        Result:=integer(AppKsb.Visible) else Result:=1;
end;
//----------------------------------------------------------------------------
procedure CloseAppKsb;
begin
    if(AppKsb<>nil) then
        AppKsb.Free;
end;
//----------------------------------------------------------------------------
end.
