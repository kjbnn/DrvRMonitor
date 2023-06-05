unit SharedBuffer;

interface

uses WinApi.Windows, System.classes, System.Syncobjs, Vcl.Dialogs, Vcl.Extctrls, System.Sysutils;

type
    ARRAYBYTE = array[0..2] of BYTE;
type
    PARRAYBYTE = ^ARRAYBYTE;

type
  KSBMES = packed record
    VerMinor : BYTE;         // ������� ���� ������
    VerMajor : BYTE;         // ������� ���� ������
    Num : DWORD;             // ���������� ����� ���������
    SysDevice : WORD;        // ���������� �� ������ SYSTEM_OPS,SYSTEM_SUD,SYSTEM_TV
    NetDevice : WORD;        // ����� ����������� ���������
    BigDevice : WORD;        // ����� Vista,RS90,Ernitec,Uniplex
    SmallDevice : WORD;      // ����� ���� ,�����������
    Code : WORD;             // ��� ���������
    Partion : WORD;          // ������ �����
    Level : WORD;            // ������� �������
    _Group : WORD;           // ������ ���
    User : WORD;             // ������������ ����� ��� ����������
    Size : WORD;             // ����� ������ Data ���� ���������
    SendTime : TDateTime;    // ���� � ����� ��������
    WriteTime : TDateTime;   // ���� � ����� �����
    PIN : array[0..5] of AnsiChar;   // ��� ��� ����� ��� ������� � ��
    Fill : array[0..2] of BYTE;  // ��������� ������ �� RS90
    Proga : WORD;            // ����� ������������ ������
    Keyboard : WORD;         // ���������� � ��
    Camera : WORD;           // ������
    Monitor : WORD;          // ����� ��������
    NumCard : WORD;          // ����� �����
    RepPass : BYTE;          // "���������� ��������" - �������� ��� ���������� �����
    Facility : BYTE;         // ��� � RS90
    Scenary : WORD;          // ����� �������� � ��
    TypeDevice : WORD;       // ��� ����������
    NumDevice  : WORD;       // ���������� ����� ���������� (��� ?)
    Mode : WORD;             // �����
    Group : DWORD;           // ������ ���
    ElementID : DWORD;       // �� ��������
    CodeID : DWORD;          // �� ���� �������
    EmployeeID: WORD;        // �� ����������
    OperatorID: WORD;        // �� �������� �����
    CmdTime: TDateTime;      // ���� � ����� �������������
    IsQuit: WORD;            // ������������� ���������
    DomainId: Byte;          // �� ������
    Data: array[0..1] of BYTE; // ������������ ������
end;

type
  SHAREDSTRING = record
    HeadPointer : DWORD;
    EndPointer : DWORD;
    CountByte  : DWORD;
    FILL : DWORD;
    StrData : array[0..1] of AnsiChar;
end;

type
  UTILMES = record
    SysDevice : WORD;    // ���������� �� ������ SYSTEM_OPS,SYSTEM_SUD,SYSTEM_TV
    TypeDevice : WORD;     // ��� ����������
    NetDevice : WORD;   //  ����� ����������� ���������
    BigDevice : WORD;     //  ����� Vista,RS90,Ernitec,Uniplex
    NumDevice  : WORD;     // ���������� ����� ���������� (��� ?)
    Code1 : WORD;           //   ��� ��������� 1
    Code2 : WORD;        //
    Code3 : WORD;
    Level : WORD;         //   ������� �������
    User : WORD;          //  ������������
    Proga : WORD;          // ����� ������������ ������
    NumCard : WORD;        //  ����� �����
end;

type
  PSHAREDSTRING = ^SHAREDSTRING;

type
  TSharedString = class(TTimer)
    public
        r : PSHAREDSTRING;
        s : PSHAREDSTRING;
        _EventSend  : THandle;
        _CSec : TCriticalSection;
        size : DWORD;
        _Buffer : TStringList;
        procedure _Send(str:AnsiString);
    public
        Connected : integer;
        AllCount : integer;
        _AllSend : integer;
        _AllReceive : integer;
        constructor Create(AOwner: TComponent); override;
        function _Init(name:AnsiString; send : boolean; siz : WORD):boolean;
        procedure SendInBuffer(str:AnsiString);
        procedure Receive(var list:TStringList);
        function ReceiveString:AnsiString;
        procedure SendTimer(Sender:TObject);
        function Clear:integer;
end;

implementation

uses Connection, cBuilderAppKsb;
//----------------------------------------------------------------------------
function TSharedString.Clear:integer;
begin
    Result:=r.CountByte;
    r.EndPointer:=0;
    r.HeadPointer:=0;
    r.CountByte:=0;
    r.FILL:=1;

    s.EndPointer:=0;
    s.HeadPointer:=0;
    s.CountByte:=0;
    s.FILL:=1;
end;
//----------------------------------------------------------------------------
constructor TSharedString.Create(AOwner: TComponent);
begin
    _Buffer:=TStringList.Create;
    inherited Create(AOwner);
    Enabled:=false;
    Interval:=10;
    OnTimer:=SendTimer;
end;
//----------------------------------------------------------------------------
function TSharedString._Init(name : AnsiString; send: boolean; siz : WORD):boolean;
var
    Pid : DWORD;
    ps : THANDLE;
    Handle: hWnd;
begin
    try
        size:=siz;
        if(send=true) then
          begin
            r:=CreateShared('r'+name,size);
            s:=CreateShared('s'+name,size);
          end
        else
          begin
            r:=CreateShared('s'+name,size);
            s:=CreateShared('r'+name,size);
          end;
        //bsl, 26.06.2014
        if((r=nil) or (s=nil))then
          begin
            WriteLog('������ �������� ������� ������ '+name);
            Result:=false;
            exit;
          end;
        Connected:=0;
        _EventSend:=CreateEvent(nil,false,false,PChar('es'+name));
        _CSec:=TCriticalSection.Create();

        r.CountByte:=0;
        s.CountByte:=0;

        r.EndPointer:=0;
        r.HeadPointer:=0;
        s.EndPointer:=0;
        s.HeadPointer:=0;
        r.FILL:=0;
        s.FILL:=0;
        Enabled:=true;
        Result:=true;
    except on E:Exception do
      begin
        //bsl, 26.06.2014
        WriteLog('������ �������� ������� ������ '+name+', exception='+E.Message);
        Result:=false;
      end;
    end;
end;
//----------------------------------------------------------------------------
procedure TSharedString.Receive(var list : TStringList);
var
    str : AnsiString;
    i : DWORD;
begin
    try
        i:=0;
        str:='';
        if(r=nil) then
            Halt;

        while r.EndPointer<>r.HeadPointer do
          begin
            if(r.StrData[r.EndPointer+i]<>#0) then
              begin
                str:=str+r.StrData[r.EndPointer+i];
                if s.CountByte>0 then Dec(s.CountByte); //kjb
                Inc(i);
              end
            else
              begin
                list.Add(str);
                Dec(AllCount);
                Inc(_AllReceive);
                r.EndPointer:=r.EndPointer+WORD(Length(str))+WORD(1);
                str:='';
                i:=0;
              end;
          end;
        r.EndPointer:=0;
        r.HeadPointer:=0;
        r.CountByte:=0;
    except
    end;
end;
//----------------------------------------------------------------------------
function TSharedString.ReceiveString:AnsiString;
var
    str : AnsiString;
    i : DWORD;
begin
    try
        i:=0;
        str:='';
        Result:='';
        if(r=nil) then
            Halt;

        while r.EndPointer<>r.HeadPointer do
          begin
            if(r.StrData[r.EndPointer+i]<>#0) then
              begin
                str:=str+r.StrData[r.EndPointer+i];
                Dec(s.CountByte);
                Inc(i);
              end
            else
              begin
                Result:=str;
                Dec(AllCount);
                r.EndPointer:=r.EndPointer+WORD(Length(str))+WORD(1);
                Inc(_AllReceive);
                exit;
              end;
          end;
        r.EndPointer:=0;
        r.HeadPointer:=0;
        r.CountByte:=0;
    except
    end;
end;
//-----------------------------------------------------------------------------
procedure TSharedString.SendTimer(Sender: TObject);
var
    str : AnsiString;
begin
    inherited;
    if(s.FILL>0) then
      begin
        _Buffer.Clear();
        s.FILL:=0;
        exit;
      end;

    while _Buffer.Count>0 do
      begin
        str:=_Buffer.Strings[0];
        if((s.HeadPointer+WORD(Length(str))>=(size-WORD(16)))) then
            exit;
        _Send(str);
        _Buffer.Delete(0);
      end;
end;
//-----------------------------------------------------------------------------
procedure TSharedString.SendInBuffer(str:AnsiString);
begin
    _Buffer.Add(str);
    Inc(AllCount);
    while _Buffer.Count>2000 do
      begin
        _Buffer.Delete(0);
        Dec(AllCount);
      end;
end;
//-----------------------------------------------------------------------------
procedure TSharedString._Send(str:AnsiString);
var
    //j:DWORD;//bsl, 28.06.2014
    j:WORD;
begin
    j:=0;
    //while j<DWORD(Length(str)) do //bsl, 28.06.2014
    while j<WORD(Length(str)) do
      begin
        s.StrData[s.HeadPointer+j]:=str[1+j];
        Inc(s.CountByte);
        Inc(j);
      end;

    s.StrData[s.HeadPointer+WORD(Length(str))]:=#0;
    Inc(s.HeadPointer,WORD(Length(str)+1) );
    SetEvent(_EventSend);
    Inc(_AllSend);
end;
//----------------------------------------------------------------------------
end.
