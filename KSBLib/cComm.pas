{$A-}
unit cComm;

interface

uses
    Forms,Classes,Windows,Dialogs,SysUtils,Graphics,connection,SharedBuffer;

type
  TComm = class(TThread)
    private
        o : OVERLAPPED ;
        po : POverlapped;
        mask : DWORD;
        error : DWORD;
        stat : COMSTAT;
        RxLive : integer;
        protected
        procedure Execute; override;
        procedure UseEvent;
        procedure Read; virtual;
        procedure Log;
        procedure Write;
    public
        Canvas : TCanvas;
        TextView : boolean;
        Debug : boolean;
        TxColor : TColor;
        RxColor : TColor;
        ErrorFlag : integer;
        _Number : integer;
        ex : integer;
        iHandle : DWORD;
        sName : string;
        sDCB : string;
        TimeOut : DWORD;
        NowRxBytes : DWORD;
        RxCount : DWORD;
        ErrorCount : DWORD;
        RxBuffer :  array [0..4095] of BYTE;
        _TxCount : integer;
        TxBuffer : array[0..255] of BYTE;
        mes : string;
        dwInQueue : DWORD;
        dwOutQueue : DWORD;
        function IsRxLive : boolean;
        procedure InitPort(i : integer); virtual;
        procedure SendModem(buf : string); overload;
        procedure SendModem(buf : PARRAYBYTE; j : DWORD); overload;
        procedure Consider; virtual;
        procedure ResetComm;
        procedure ResetBaund(b : string);
        procedure DrawCursor(var pos : integer); virtual;
        procedure DrawByte(var pos : integer; b : Char;c : TColor); virtual;
        procedure ScrollRxBuffer(p : DWORD);
        procedure __SetDTR;
        procedure __ClearDTR;
        procedure EscapeCommFunction(commmand : WORD);
        procedure ClosePort;
  end;

var
    CurPos  : integer;
    ImageSize  : WORD=20;

implementation


procedure TComm.Execute();
begin
    while true do
      begin
        ClearCommError(iHandle,error,@stat);
        ResetEvent(o.hEvent);
        mes:='WaitCommEvent';
        Synchronize(Log);
        if(WaitCommEvent(iHandle,mask,po)) then
          begin
            UseEvent();
            mes:='1';
            Synchronize(Log);
          end
        else
          begin
            if(WaitForSingleObject(iHandle,INFINITE)=WAIT_OBJECT_0) then
              begin
                mes:='2';
                Synchronize(Log);
                UseEvent();
              end
            else
              begin
                mes:='exit';
                Synchronize(Log);
                exit;
              end;
          end;
      end;
end;
//-----------------------------------------------------------------------------
procedure TComm.Consider();
begin

end;
//-----------------------------------------------------------------------------
procedure  TComm.ResetComm();
begin
    RxCount:=0;
    PurgeComm(iHandle,PURGE_TXABORT+PURGE_RXABORT+PURGE_TXCLEAR+PURGE_RXCLEAR);
    // TxCount:=0;
    NowRxBytes:=0;
    SetupComm(iHandle,dwInQueue,dwOutQueue);
end;

procedure TComm.SendModem(buf : string);
begin
    SendModem(@buf[1],Length(buf));
end;
//-----------------------------------------------------------------------------
function TComm.IsRxLive () : boolean;
begin
    Result:=(RxLive<>0);
    RxLive:=0;
end;
//-----------------------------------------------------------------------------
procedure TComm.DrawCursor(var pos : integer);
begin
    if( (Canvas=nil) or (not Debug) ) then
        exit;
    Canvas.Brush.Color:=clBlack;
    Canvas.TextOut((pos mod ImageSize)*20,((pos div ImageSize) mod ImageSize)*20,IntToHex(0,2)+' ');
    Inc(pos);
end;
//-----------------------------------------------------------------------------
procedure TComm.Read();
var
    i : DWORD;
begin
    i:=0;
    while i < NowRxBytes do
      begin
        DrawByte(CurPos,Char(RxBuffer[i+RxCount]),RxColor);
        inc(i);
        inc(RxLive);
      end;
    RxCount:=RxCount+NowRxBytes;
    Consider();
end;
//-----------------------------------------------------------------------------
procedure TComm.UseEvent();
var
    buf : pChar;
    ret : DWORD;
begin
    if( (mask and  EV_TXEMPTY)>0) then
      begin
        ResetEvent(o.hEvent);
        Synchronize(Write);
        exit;
      end;
    buf:=@RxBuffer[RxCount];
    if((mask and EV_RXCHAR)>0) or ((mask and EV_ERR)>0) then
      begin
        ClearCommError(iHandle,error,@stat);
        if( ReadFile(iHandle,buf^,stat.cbInQue,NowRxBytes,po)=false) then
          begin
            ret:=WaitForSingleObject(iHandle,500);
            if(ret=WAIT_TIMEOUT) then
              begin
                WriteLog('Not read bytes 2 sec');
                exit;
              end;
            if(ret=WAIT_ABANDONED) then
              begin
                WriteLog('WAIT_ABANDONED');
                exit;
              end;
          end;//
        Synchronize(Read);
        ResetEvent(o.hEvent);
      end
    else
      begin
        ClearCommError(iHandle,error,@stat);
        ResetEvent(o.hEvent);
      end;
end;
//-----------------------------------------------------------------------------
procedure TComm.Log;
begin
    // aMain.Memo1.Lines.Add(mes);
end;
//-----------------------------------------------------------------------------
procedure TComm.ResetBaund(b : string);
var
    dcb : TDCB;
begin
    SetKey('DCB1','baud='+b+' parity=N data=8 stop=1');
    sDCB:=GetKey('DCB1','');
    BuildCommDCB(PChar(sDCB),dcb);
    SetCommState(iHandle,dcb);
end;
//-----------------------------------------------------------------------------
procedure TComm.ScrollRxBuffer(p : DWORD);
var
    i : DWORD;
begin
    i:=0;
    while i<RxCount-p do
      begin
        RxBuffer[i]:=RxBuffer[p+i];
        Inc(i);
      end;
    RxCount:=(RxCount-p);
end;
//-----------------------------------------------------------------------------
procedure TComm.__ClearDTR;
begin
    // EscapeCommFunction(h,SETRTS);
    // EscapeCommFunction(h,CLRDTR);
    // EscapeCommFunction(h,CLRRTS);
    // windows.EscapeCommFunction(h,SETDTR);
end;
//-----------------------------------------------------------------------------
procedure TComm.__SetDTR;
begin
    // windows.EscapeCommFunction(h,CLRDTR);
    // EscapeCommFunction(h,CLRRTS);
    windows.EscapeCommFunction(iHandle,SETDTR);
    windows.EscapeCommFunction(iHandle,SETRTS);
end;
//-----------------------------------------------------------------------------
procedure TComm.Write;
begin
    //
end;
//-----------------------------------------------------------------------------
procedure TComm.SendModem(buf : PARRAYBYTE;j : DWORD);
var
    i : DWORD;
begin
    i:=0;
    _TxCount:=j;
    while(i<j) do
      begin
        DrawByte(CurPos,Char(BYTE(buf[i])),TxColor);
        Inc(i);
      end;
    i:=0;
    if( WriteFile(iHandle,buf[0],j,i,po)=false) then
        if(GetLastError()<>ERROR_IO_PENDING) then
            WriteLog(Format('WriteFile Error = %X %u',[error,error]));
end;
//-----------------------------------------------------------------------------
procedure TComm.DrawByte(var pos : integer; b : Char; c : TColor);
begin
    // b:=Char($FF);
    if((Canvas=nil) or (not Debug)) then
        exit;
    if(TextView) then
      begin
        Canvas.Brush.Color:=clGray;
        Canvas.TextOut((pos mod ImageSize)*20,((pos div ImageSize) mod ImageSize)*20,'      ');
        Canvas.Brush.Color:=c;
        Canvas.TextOut((pos mod ImageSize)*20,((pos div ImageSize) mod ImageSize)*20,b);
      end
    else
      begin
        Canvas.Brush.Color:=clGray;
        Canvas.TextOut((pos mod ImageSize)*20,((pos div ImageSize) mod ImageSize)*20,'      ');
        Canvas.Brush.Color:=c;
        Canvas.TextOut((pos mod ImageSize)*20,((pos div ImageSize) mod ImageSize)*20,IntToHex(BYTE(b),2));
      end;
    Inc(pos);
    DrawCursor(pos);
    Dec(pos);
end;
//-----------------------------------------------------------------------------
procedure TComm.EscapeCommFunction(commmand : WORD);
begin
    //  windows.EscapeCommFunction(h,commmand);
end;
//-----------------------------------------------------------------------------
procedure TComm.InitPort(i : integer);
var
    dcb : TDCB;
    dwEvtMask : DWORD;
begin
    // dwInQueue:=128;
    // dwOutQueue:=128;
    dwInQueue:=1;
    dwOutQueue:=128;
    TxColor:=clRed;
    RxColor:=clLime;
    _Number:=i;
    ErrorCount:=0;
    po:=@o;
    if(sName='') then
        sName:=GetKey('PORT'+IntToStr(i),'');
    if(sName='') then
      begin
        iHandle:=INVALID_HANDLE_VALUE;
        exit;
      end;
    iHandle:=CreateFile(PChar(sName),GENERIC_READ or GENERIC_WRITE ,0,nil,OPEN_EXISTING,FILE_FLAG_OVERLAPPED,0);
    if(iHandle=INVALID_HANDLE_VALUE) then
      begin
        WriteLog('Не открывается '+sName);
        exit;
      end;
    GetCommState(iHandle,dcb);
    if(sDCB='') then
        sDCB:=GetKey('DCB'+IntToStr(i),'');
    if(sDCB='') then
      begin
        iHandle:=INVALID_HANDLE_VALUE;
        exit;
      end;
    BuildCommDCB(PChar(sDCB),dcb);
    SetCommState(iHandle,dcb);
    dwEvtMask:=EV_RXCHAR or  EV_TXEMPTY;
    dwEvtMask:=dwEvtMask or EV_ERR;
    SetCommMask(iHandle,dwEvtMask);
end;
//-----------------------------------------------------------------------------
procedure TComm.ClosePort;
begin
    Suspend;
    CloseHandle(iHandle);
end;
//-----------------------------------------------------------------------------
end.


