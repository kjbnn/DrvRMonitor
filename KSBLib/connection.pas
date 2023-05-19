// {$A-}

unit connection;

interface

uses System.Win.Registry, WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, VCL.Controls, VCL.Forms, Vcl.Dialogs,
     System.Syncobjs, System.IniFiles, SharedBuffer, Vcl.Stdctrls, System.DateUtils;

//-----------------------------------------------------------------------------

const      KILL_SELF       = 2;
const      CLOSE_SELF      = 3;
const      ROSTEK_ROOT_KEY = '\Software\RostVSP\';

//-----------------------------------------------------------------------------
const       DM_SOURCE=1;
const       DM_TAGET=2;

type
    TDragComponent = class
      public
        Handle : HWND;
        FlagDrag : WORD;
        Component : TWinControl;
        ProcDrop : procedure(Sender : TDragComponent);
        X : integer;
        Y : integer;
        xOle : integer;
        ElementId : integer;
        ModelId : integer;
end;

type
    KSBCONNECT = record
        Computer : string;
        Proga : string;
        User : string;
        Pass : string;
        UserID : Integer;
        FirstEvent : Integer;
end;


type ARRAYWORD = array[0..1] of WORD;
type PARRAYWORD = ^ARRAYWORD;

type
    sInteger= record
        Number : Integer;
end;

var
    ApplicationLoaded : THandle;
    StoppedFlag : integer;
    LogCount : integer;

function    GenTimeName:string;
function    GetComputerName2:string;
function    GetAppName:string;
procedure   RegisterLibrary(Nam:string);
function    ChangeByte(x:WORD):WORD;
procedure   SetRusLan;
procedure   CreateFolder(nam:string);
function    BreakString(var str:string):string;
function    SetFileExt(FileName:string;ext:string):string;
procedure   CreateListCOM(cbComPort:TComboBox);
function    iReadReg(section:string;key:string):integer;
function    sReadReg(section:string;key:string):string;
procedure   WriteReg(section:string;key:string;value:string); overload;
procedure   WriteReg(section:string;key:string;value:integer); overload;
function    IsLoadedBorlandSocketServer:boolean;
function    ReadPath:string;
function    Bin2Simbol(bin:PAnsiChar;n:integer):AnsiString; overload;
function    Bin2Simbol(mes:KSBMES):AnsiString; overload;
function    GetParam(var str:AnsiString):AnsiString;
procedure   WriteLog(mes:string);
function    IntToDig(n:integer;size:integer):string;
procedure   CheckExecute(_load:boolean;_show:boolean);
procedure   DeleteKey(key:string);
function    GetKey(key,def:string):string; overload;
function    GetKey(key:string; def:integer):integer; overload;
procedure   Init(var mes:KSBMES); overload;
procedure   Init(var mes:UTILMES); overload;
procedure   Simbol2Bin(str:AnsiString; mes:PAnsiChar; n:integer);
procedure   SetKey(key:string; value:string); overload;
procedure   SetKey(key:string; value:integer); overload;
function    GetInt(str:string; pos:integer;size:integer):integer;
function    GetSubkey1(str:string; sub:string):string;
procedure   SetInt(var str:string; pos:integer;size:integer;value:integer); overload;
procedure   SetInt(var str:string; pos:integer;value:integer); overload;
procedure   CheckIni;
function    GetSubkey(str:string; sub:string):string;
function    iGetSubkey(str:string; sub:string):integer;
function    pad(str:string; count:integer ):string;
function    CompUpStr(str1,str2:string):boolean;
function    Rotate(b:BYTE):BYTE;
procedure   ShowCenter(form:TForm);
function    PrintPacket(buf:PARRAYBYTE; size:integer):string;
function    ReadDatabase:string;
procedure   CheckFitScreen(form:TForm);
procedure   SavePosition(form:TForm; FormName:string);
procedure   RestorePosition(form:TForm; FormName:string);

implementation

//-----------------------------------------------------------------------------
function Bin2Simbol(mes:KSBMES):AnsiString;
begin
    Result:=Bin2Simbol(PAnsiChar(@mes),sizeof(KSBMES));
end;
//-----------------------------------------------------------------------------
function Bin2Simbol(bin:PAnsiChar; n:integer):AnsiString;
var
    temp:AnsiString;
    i:integer;
    b1:BYTE;
    b2:BYTE;
begin
    i:=0;
    temp:='';
    while i<n do
      begin
        b1:=BYTE(bin[i]);
        b2:=BYTE(bin[i]) and $F;
        temp:=temp+Format('%X%X',[((b1 shr 4) and $F),b2]);
        Inc(i);
      end;
    Result:=temp;
end;
//-----------------------------------------------------------------------------
function GetParam(var str:AnsiString):AnsiString;
var
    temp:AnsiString;
    p : integer;
begin
    str:=Trim(str);
    p:=pos(' ',str);
    SetLength(temp,p);
    StrLCopy(PChar(temp),PChar(str),p);
    Result:=Trim(temp);
    SetLength(temp,120);
    StrCopy(PChar(temp),PChar(@str[p]));
    str:=Trim(temp);
end;

function IntToDig(n : integer; size : integer) : string;
var
    str : string;
    i : integer;
    p : integer;
begin
    SetLength(str,size);
    i:=1;
    p:=10;
    str[size]:=Char((n mod 10)+$30);
    while i<size do
      begin
        str[size-i]:=Char(((n div p) mod 10)+$30);
        p:=p*10;
        Inc(i);
      end;
    Result:=str;
end;
//-----------------------------------------------------------------------------
function  IsLoadedBorlandSocketServer:boolean;
var
    hWnd : THandle;
begin
    hWnd:=FindWindow('TSocketForm','Borland Socket Server');
    Result:=(hWnd<>0);
end;
//-----------------------------------------------------------------------------
procedure Init(var mes : KSBMES);
begin
    FillChar(mes,sizeof(KSBMES),0);
    mes.VerMinor:=$AA;
    mes.VerMajor:=$55;
    mes.SendTime:=Now;
    mes.WriteTime:=Now;
    mes.TypeDevice:=$FFFF;
    mes.NumDevice:=$FFFF;
    mes.ElementId:=$FFFFFFFF;
end;
//-----------------------------------------------------------------------------
procedure DeleteKey(key:string);
var
    str : string;
    ini : TIniFile;
begin
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    str:=ExtractFileName(ParamStr(0));
    SetLength(str,Length(str)-4);
    ini.DeleteKey(str,key);
    ini.Free;
end;
//-----------------------------------------------------------------------------
function GetKey(key,def : string) : string;
var
    str : string;
    ini : TIniFile;
begin
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    str:=ExtractFileName(ParamStr(0));
    SetLength(str,Length(str)-4);
    str:=ini.ReadString(str,key,def);
    ini.Free;
    Result:=str;
    SetKey(key,Result);
end;
//-----------------------------------------------------------------------------
function GetKey(key : string;def : integer) : integer;
var
    i : integer;
    ini : TIniFile;
    str : string;
begin
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    str:=ExtractFileName(ParamStr(0));
    SetLength(str,Length(str)-4);
    i:=ini.ReadInteger(str,key,def);
    ini.Free;
    Result:=i;
    SetKey(key,Result);
end;

procedure SetKey(key : string; value : string);
var
    sec : string;
    ini : TIniFile;
begin
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    sec:=ExtractFileName(ParamStr(0));
    SetLength(sec,Length(sec)-4);
    ini.WriteString(sec,key,value);
    ini.Free();
end;

procedure SetKey(key : string; value : integer);
var
    sec : string;
    ini : TIniFile;
begin
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    sec:=ExtractFileName(ParamStr(0));
    SetLength(sec,Length(sec)-4);
    ini.WriteInteger(sec,key,value);
    ini.Free;
end;
//------------------------------------------------------------------------------
procedure CheckIni;
var
    ini : TIniFile;
    Strings: TStringList;
    i : integer;
    l : integer;
    str : string;
    key : string;
    sec : string;
begin
    sec:=ExtractFileName(ParamStr(0));
    ini:=TIniFile.Create(ReadPath+'setting.ini');
    Strings:=TStringList.Create;

    ini.ReadSectionValues(sec,Strings);
    ini.EraseSection(sec);
    i:=0;
    while i<strings.count do
      begin
        str:=strings[i];
        l:=pos('=',strings[i]);
        SetLength(key,Length(str));
        StrCopy(PChar(key),PChar(@str[l+1]));
        SetLength(str,l-1);

        while ini.ValueExists (sec,str) do
          begin
            ini.DeleteKey(sec,str);
          end;
        ini.WriteString(sec,str,key);
        inc(i);
      end;
    ini.Free;
end;

procedure SetInt(var str : string; pos : integer;size : integer;value : integer);
var
    temp : string;
    newlen : integer;
begin
    temp:=IntToDig(value,size);
    newlen:=pos+size;
    if(Length(str)<newlen) then
        SetLength(str,newlen);
    Move(temp[1],str[pos],size);
end;

procedure SetInt(var str : string; pos : integer; value : integer);
var
    s : sInteger;
    size : Integer;
    temp : string;
begin
    size:=sizeof(sInteger);
    s.Number:=value;
    temp:=Bin2Simbol(@s,size);
    Move(temp[1],str[pos],2*size);
end;
//-----------------------------------------------------------------------------
function GetInt(str : string; pos : integer;size : integer) : integer;
var
    temp : string;
begin
    SetLength(temp,size+1);
    StrLCopy(PChar(temp),PChar(@str[pos]),size);
    temp:=Trim(temp);
    try
        Result:=StrToInt(temp);
    except
        on E: Exception do
          begin
            WriteLog('GetInt(str='+str+Format(',pos=%u,size=%u)',[pos,size])+' -> '+E.Message);
            Result:=-1;
          end;
    end;
end;
//-----------------------------------------------------------------------------
function GetSubkey(str : string; sub : string) : string;
var
    i : integer;
    temp: string;
begin
    str:=AnsiUpperCase(str);
    sub:=AnsiUpperCase(sub);
    i:=pos(sub,str);
    temp:=PChar(@str[i+Length(sub)]);
    i:=pos('=',temp);
    temp:=Trim(PChar(@temp[i+1]));
    i:=pos(';',temp);
    SetLength(temp,i-1);
    Result:=Trim(temp);
end;
//-----------------------------------------------------------------------------
procedure CheckExecute(_load : boolean; _show : boolean);
var
    str : string;
begin
    str:=ExtractFileName(Application.ExeName);
    if(_load=false) then
      begin
        CloseHandle(ApplicationLoaded);
      end
    else
      begin
        ApplicationLoaded:=CreateEvent(nil,false,false,@str[1]);
        if((GetLastError()=ERROR_ALREADY_EXISTS) and (ParamStr(1)<>'SECOND') ) then
          begin
            if(_show=true) then
                ShowMessage('Программа уже выполняется : '+str);

            Application.Terminate;
            ShowMessage('STOP');
          end;
      end;
end;
//-----------------------------------------------------------------------------
function Char2Int(x : integer) : integer;
begin
    if(x>=65) and (x<=70) then
      begin
        x:=x-55;
      end
    else if(x>=48) and (x<=58) then
      begin
        x:=x-48;
      end;
    Result:=x;
end;
//-----------------------------------------------------------------------------
procedure Simbol2Bin(str:AnsiString;mes:PAnsiChar;n:integer);
var
    i : integer;
    x1 : integer;
    x2 : integer;
    len : integer;
begin
    len:=Length(str);
    n:=n*2;

    i:=1;
    while (i<=len) and (i<n) do
      begin
        x1:=integer( str[i] );
        x2:=integer( str[i+1] );
        mes[i shr 1]:=AnsiChar((Char2Int(x1) shl 4) + Char2Int(x2));
        i:=i+2;
      end;
end;
//-----------------------------------------------------------------------------
function pad(str : string; count : integer ) : string;
var
    i : integer;
begin
    i:=Length(str);
    while  i<count do
      begin
        str:=str+' ';
        Inc(i);
      end;
    Result:=str;
end;
//-----------------------------------------------------------------------------
function CompUpStr(str1,str2 : string) : boolean;
begin
    str1:=AnsiUpperCase(str1);
    str2:=AnsiUpperCase(str2);
    Result:=CompareStr(str1,str2)=0;
end;
//-----------------------------------------------------------------------------
function Rotate(b : BYTE) : BYTE;
var
    i : BYTE;
    one : BYTE;
    temp : BYTE;
begin
    i:=0;
    one:=$80;
    temp:=0;
    while i<8 do
      begin
        if(b and (BYTE(1) shl i ))>0 then
            temp:=temp or (one shr i);
        Inc(i);
      end;
    Result:=temp;
end;
//-----------------------------------------------------------------------------
function sReadReg(section : string; key : string) : string;
var
    Reg : TRegistry;
begin
    Result:='';
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
        if Reg.OpenKey(ROSTEK_ROOT_KEY+section,True) then
            Result:=Reg.ReadString(key);
    except
    end;

    Reg.CloseKey;
    Reg.Free;
end;
//-----------------------------------------------------------------------------
procedure  WriteReg(section : string; key : string; value : string);
var
    Reg : TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
        if Reg.OpenKey(ROSTEK_ROOT_KEY+section,True) then
            Reg.WriteString(key,value);
    except
    end;
    Reg.CloseKey;
    Reg.Free;
end;

//-----------------------------------------------------------------------------

function iReadReg(section : string; key : string) : integer;
var
    Reg : TRegistry;
begin
    Result:=0;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
        if Reg.OpenKey(ROSTEK_ROOT_KEY+section,True) then
            Result:=Reg.ReadInteger(key);
    except
    end;
    Reg.CloseKey;
    Reg.Free;
end;

//-----------------------------------------------------------------------------

procedure  WriteReg(section : string; key : string; value : integer);
var
    Reg : TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
        if Reg.OpenKey(ROSTEK_ROOT_KEY+section,True) then
            Reg.WriteInteger(key,value);
    except
    end;
    Reg.CloseKey;
    Reg.Free;
end;

//-----------------------------------------------------------------------------

procedure  ShowCenter(form : TForm);
begin
    form.Left:=(Screen.Width div 2) - (form.Width div 2);
    form.Top:=(Screen.Height div 2) - (form.Height div 2);
end;

//-----------------------------------------------------------------------------

function ExtractDate(str : string) : Double;
var
    i : integer;
begin
    str:=Trim(str);
    i:=pos(' ',str);
    if(i=0) then
      begin
        if(str='') then
            Result:=0
        else
            Result:=Double( StrToDate(str) );
      end
    else
      begin
        SetLength(str,i);
        Result:=Double( StrToDateTime(str) );
      end;
end;

//-----------------------------------------------------------------------------

procedure CreateListCOM(cbComPort: TComboBox);
var
    reg : TRegistry;
    ts : TStrings;
    i : integer;
begin
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('hardware\devicemap\serialcomm',false);
    ts := TStringList.Create;
    reg.GetValueNames(ts);
    for i := 0 to ts.Count -1 do
      begin
        cbComPort.Items.Add(reg.ReadString(ts.Strings[i]));
      end;
    ts.Free;
    reg.CloseKey;
    reg.free;
    if(cbComPort.Items.Count>0) then
        cbComPort.ItemIndex:=0
    else
      begin
        cbComPort.Enabled:=false;
      end;
end;

//-----------------------------------------------------------------------------

function SetFileExt(FileName : string; ext : string) : string;
var
    i : integer;
begin
    FileName:=Trim(FileName);
    i:=Length(ExtractFileExt(FileName));
    if(i>0) and (i<=4) then
        SetLength(FileName,Length(FileName)-i);
    Result:=FileName+'.'+ext;
end;

//-----------------------------------------------------------------------------

function BreakString(var str : string) : string;
var
    i : integer;
begin
    i:=pos(';;',str);
    while i>0 do
      begin
        str[i]:=#13;
        str[i+1]:=#10;
        i:=pos(';;',str);
      end;
    Result:=str;
end;

//-----------------------------------------------------------------------------

procedure CreateFolder(nam : string);
begin
    if not DirectoryExists(nam) then
        if not CreateDir(nam) then
          begin
            ShowMessage('Создайте директорию `'+nam+'` и перезапустите программу !');
          end;
end;

//-----------------------------------------------------------------------------

function PrintPacket(buf : PARRAYBYTE; size : integer) : string;
var
    i : integer;
    str : string;
begin
    i:=0;
    str:='';
    while i<size do
      begin
        str:=str+IntToHex(BYTE(buf[i]),2)+' ';
        Inc(i);
      end;
    Result:=str;
end;

//-----------------------------------------------------------------------------

procedure WriteLog(mes : string);
var
    f : TextFile;
    st : SYSTEMTIME;
    Name : string;
    logname: string;
    logname2: string;
    is_exist:boolean;
    size: Longint;
    AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
    SYear, SMonth, SDay, SHour, SMinute, SSecond, SMilliSecond: String;
begin
    GetLocalTime(st);
    name:=ExtractFileName(Application.ExeName);
    SetLength(name,Length(name)-4);
    logname:=ReadPath+name+'.log';
    is_exist:=FileExists(logname);
    AssignFile(f,logname);
    if(is_exist)then
      begin
        Append(f);
        size:=FilePos(f);
        if(size>250000)then
          begin
            CloseFile(f);
            DecodeDateTime(Now,AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
            SYear:=IntToStr(AYear);
            SMonth:=IntToStr(AMonth);
            if(AMonth<10)then
                SMonth:='0'+SMonth;
            SDay:=IntToStr(ADay);
            if(ADay<10)then
                SDay:='0'+SDay;
            SHour:=IntToStr(AHour);
            if(AHour<10)then
                SHour:='0'+SHour;
            SMinute:=IntToStr(AMinute);
            if(AMinute<10)then
                SMinute:='0'+SMinute;
            SSecond:=IntToStr(ASecond);
            if(ASecond<10)then
                SSecond:='0'+SSecond;
            logname2:=ReadPath+name+'.'+SYear+SMonth+SDay+SHour+SMinute+SSecond+'.log';
            RenameFile(logname,logname2);
            AssignFile(f,logname);
            Rewrite(f);
            WriteLn(f,'['+Application.ExeName+']');
          end;
      end
    else
      begin
        Rewrite(f);
        WriteLn(f,'['+Application.ExeName+']');
      end;
    WriteLn(f,Format('[%.4u/%.2u/%.2u %.2u:%.2u:%.2u:%.3u]',[st.wYear, st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds])+' '+mes);
    Flush(f);
    CloseFile(f);
end;

//-----------------------------------------------------------------------------

procedure SetRusLan;
var
    Layout: array[0.. KL_NAMELENGTH] of char;
begin
    LoadKeyboardLayout( StrCopy(Layout,'00000419'),KLF_ACTIVATE);
end;

//-----------------------------------------------------------------------------

function ReadDatabase : string;
var
    Reg : TRegistry;
    path : string;
begin
    Result:='';
    try
        Reg := TRegistry.Create;
        Reg.RootKey := HKEY_CURRENT_USER;
        if Reg.OpenKey(ROSTEK_ROOT_KEY+'\PathSystem',True) then
            Path:=Trim(Reg.ReadString('Database'));
        Reg.CloseKey;
        Reg.Free;
    except
    end;
    Result:=path;
end;

//-----------------------------------------------------------------------------

function ChangeByte(x : WORD) : WORD;
begin
    Result:=(x shl 8)+(x shr 8);
end;

//-----------------------------------------------------------------------------

procedure CheckFitScreen(form : TForm);
begin
    if(form.Left>Screen.Width) then
        form.Left:=Screen.Width-form.Width;
    if(form.Top>Screen.Height) then
        form.Top:=Screen.Height-form.Height;
    if(form.Left<0) then
        form.Left:=0;
    if(form.Top<0) then
        form.Top:=0;
end;

//-----------------------------------------------------------------------------

procedure RegisterLibrary(Nam : string);
var
   hModule : DWORD;
   fun : procedure;
begin
    hModule:=LoadLibrary(PChar(Nam));
    fun:=GetProcAddress(hModule,'DllRegisterServer');
    if Assigned(fun) then
        fun;
    FreeLibrary(hModule);
end;

//-----------------------------------------------------------------------------

function GetAppName:string;
var
    str : string;
begin
    str:=ExtractFileName(ParamStr(0));
    SetLength(str,Length(str)-4);
    Result:=AnsiUpperCase(str);
end;

//-----------------------------------------------------------------------------
function ReadPath:string;
var
    Reg : TRegistry;
    path : string;
begin
    Result:='';
    try
        Reg:=TRegistry.Create;
    except
        exit;
    end;
    try
        Reg.RootKey := HKEY_CURRENT_USER;
        if(Reg.OpenKey(ROSTEK_ROOT_KEY+'PathSystem',false)) then
            path:=Trim(Reg.ReadString('path'));
        if(path<>'') then
          begin
            Reg.CloseKey;
            Reg.Free;
            Result:=path;
            exit;
          end;
    except
    end;
    if(path<>'') then
        exit;
    try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.OpenKey(ROSTEK_ROOT_KEY+'PathSystem',false) then
            path:=Trim(Reg.ReadString('path'));
        Result:=path;
        Reg.CloseKey;
        Reg.Free;
    except
    end;
end;

//-----------------------------------------------------------------------------

procedure SavePosition(form : TForm; FormName : string);
begin
    if(form.Left>=Screen.Width) then
        form.Left:=0;
    if(form.Top>=Screen.Height) then
        form.Top:=0;
    WriteReg(FormName,'LEFT',form.Left);
    WriteReg(FormName,'TOP',form.Top);
    WriteReg(FormName,'WIDTH',form.Width);
    WriteReg(FormName,'HEIGHT',form.Height);
end;

//-----------------------------------------------------------------------------
procedure RestorePosition(form : TForm; FormName : string);
begin
    form.Left:=iReadReg(FormName,'LEFT');
    form.Top:=iReadReg(FormName,'TOP');
    form.Width:=iReadReg(FormName,'WIDTH');
    form.Height:=iReadReg(FormName,'HEIGHT');
    if(form.Left>=Screen.Width) then
        form.Left:=0;
    if(form.Top>=Screen.Height) then
        form.Top:=0;
end;

//-----------------------------------------------------------------------------

function GetComputerName2:string;
var
    NameComp : string;
    len : DWORD;
begin
    SetLength(NameComp,128);
    len:=Length(NameComp);
    WinApi.Windows.GetComputerName(PChar(NameComp),len);
    SetLength(NameComp,len);
    Result:=NameComp;
end;

//-----------------------------------------------------------------------------

function GenTimeName() : string;
var
    st : SYSTEMTIME;
begin
    GetLocalTime(st);
    Result:=Format('%u%u%u%u%u%u',[st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds]);
end;

//-----------------------------------------------------------------------------

function GetSubkey1(str : string; sub : string) : string;
var
    i : integer;
    temp: string;
begin
    str:=AnsiUpperCase(str);
    sub:=AnsiUpperCase(sub);
    i:=pos(sub,str);
    temp:=PChar(@str[i+Length(sub)]);
    i:=pos('=',temp);
    temp:=Trim(PChar(@temp[i+1]));
    i:=pos(',',temp);
    SetLength(temp,i-1);
    Result:=Trim(temp);
end;

//-----------------------------------------------------------------------------

function iGetSubkey(str : string; sub : string) : integer;
begin
    str:=GetSubkey(str,sub);
    if(str='') then
      begin
        Result:=0;
        exit;
      end;
    try
        Result:=StrToInt(str);
    except
        Result:=0;
    end;
end;

procedure Init(var mes : UTILMES);
begin
    FillChar(mes,sizeof(UTILMES),0);
end;

end.


