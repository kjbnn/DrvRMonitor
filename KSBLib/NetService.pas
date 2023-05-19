// {$A-}
unit NetService;

interface

uses Winapi.Windows, Winapi.Winsock, System.Sysutils, WinApi.NB30;

function WSAIoctl(s: TSocket; cmd:DWORD; lpInBuffer:PCHAR; dwInBufferLen:DWORD;
  lpOutBuffer: PCHAR; dwOutBufferLen: DWORD;
  lpdwOutBytesReturned: LPDWORD;
  lpOverLapped: POINTER;
  lpOverLappedRoutine: POINTER): Integer; stdcall; external 'WS2_32.DLL';


const SIO_GET_INTERFACE_LIST = $4004747F;
const IFF_UP = $00000001;
const IFF_BROADCAST = $00000002;
const IFF_LOOPBACK = $00000004;
const IFF_POINTTOPOINT = $00000008;
const IFF_MULTICAST = $00000010;

type
    sockaddr_gen = packed record
        AddressIn: sockaddr_in;
        filler: packed array[0..7] of char;
    end;

type
    INTERFACE_INFO = packed record
        iiFlags: u_long; // ����� ����������
        iiAddress: sockaddr_gen; // ����� ����������
        iiBroadcastAddress: sockaddr_gen; // Broadcast �����
        iiNetmask: sockaddr_gen; // ����� �������
    end;

function GetMACAddress: string;

implementation

//-----------------------------------------------------------------------------

function EnumInterfaces(var sInt: string): Boolean;
var
    s: TSocket;
    wsaD: WSADATA;
    NumInterfaces: Integer;
    BytesReturned, SetFlags: u_long;
    pAddrInet: SOCKADDR_IN;
    pAddrString: PAnsiChar;
    PtrA: pointer;
    Buffer: array[0..20] of INTERFACE_INFO;
    i: Integer;
begin
    result := true;                                // �������������� ����������
    sInt := '';
    WSAStartup($0101, wsaD);                      // ��������� WinSock
                                                // ����� ����� �������� ��������� ����������� ������ :)

    s := Socket(AF_INET, SOCK_STREAM, 0);          // ��������� �����
    if (s = INVALID_SOCKET) then
        exit;
    try                                            // �������� WSAIoCtl
        PtrA := @bytesReturned;
        if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer, 1024, PtrA, nil,nil)<>SOCKET_ERROR)then
          begin                                        // ���� OK, �� ���������� ���������� ������������ �����������
            NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);
            for i := 0 to NumInterfaces - 1 do        // ��� ������� ����������
              begin
                pAddrInet := Buffer[i].iiAddress.addressIn;            // IP �����
                pAddrString := inet_ntoa(pAddrInet.sin_addr);
                sInt := sInt + ' IP=' + pAddrString + ',';
                pAddrInet := Buffer[i].iiNetMask.addressIn;            // ����� �������
                pAddrString := inet_ntoa(pAddrInet.sin_addr);
                sInt := sInt + ' Mask=' + pAddrString + ',';
                pAddrInet := Buffer[i].iiBroadCastAddress.addressIn;  // Broadcast �����
                pAddrString := inet_ntoa(pAddrInet.sin_addr);
                sInt := sInt + ' Broadcast=' +  pAddrString + ',';

                SetFlags := Buffer[i].iiFlags;
                if(SetFlags and IFF_UP) = IFF_UP then
                    sInt := sInt + ' Interface UP,'                    // ������ ���������� up/down
                else
                    sInt := sInt + ' Interface DOWN,';

                if (SetFlags and IFF_BROADCAST) = IFF_BROADCAST then  // Broadcasts
                    sInt := sInt + ' Broadcasts supported,'              // ������������ ���
                else                                                  // �� ��������������
                    sInt := sInt + ' Broadcasts NOT supported,';

                if (SetFlags and IFF_LOOPBACK) = IFF_LOOPBACK then    // ����������� ���
                    sInt := sInt + ' Loopback interface'
                else
                    sInt := sInt + ' Network interface';                  // ����������

                sInt := sInt + #13#10;                                // CRLF ����� ������ �����������
            end;
        end;
    except
    end;
//
// ��������� ������
//
    CloseSocket(s);
    WSACleanUp;
    result := false;
end;

//-----------------------------------------------------------------------------

function GetAdapterInfo(Lana: AnsiChar): String;
var
    Adapter: TAdapterStatus;
    NCB: TNCB;
begin
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := Char(NCBRESET);
    NCB.ncb_lana_num := Lana;
    if Netbios(@NCB) <> Char(NRC_GOODRET) then
      begin
        Result := 'mac not found';
        Exit;
      end;

    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := Char(NCBASTAT);
    NCB.ncb_lana_num := Lana;
    NCB.ncb_callname := '*';

    FillChar(Adapter, SizeOf(Adapter), 0);
    NCB.ncb_buffer := @Adapter;
    NCB.ncb_length := SizeOf(Adapter);
    if Netbios(@NCB) <> Char(NRC_GOODRET) then
      begin
        Result := 'mac not found';
        Exit;
      end;
    Result := IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
        IntToHex(Byte(Adapter.adapter_address[5]), 2);
end;
//-----------------------------------------------------------------------------
function GetMACAddress: string;
var
    AdapterList: TLanaEnum;
    NCB: TNCB;
begin
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := Char(NCBENUM);
    NCB.ncb_buffer := @AdapterList;
    NCB.ncb_length := SizeOf(AdapterList);
    Netbios(@NCB);
    if Byte(AdapterList.length) > 0 then
        Result := GetAdapterInfo(AdapterList.lana[0])
    else
        Result := 'mac not found';
end;

end.
