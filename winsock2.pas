unit winsock2;

interface

uses Windows, SysUtils;


const
  WSADESCRIPTION_LEN=256;
  WSASYS_STATUS_LEN=128;
  AF_BTH=32;
  SOCK_STREAM=1;
  BTHPROTO_RFCOMM=$0003;
  BT_PORT_ANY=Cardinal(-1);//4294967295;
  CXN_DEFAULT_LISTEN_BACKLOG=4;
  NS_BTH=16;

type
  ushort=word;
  ulong=cardinal;
  ulonglong=Int64;
  BTH_ADDR=ulonglong;
  dword=LongWord;

  GUID=packed record
    Data1: uLong;
    Data2: ushort;
    Data3: ushort;
    Data4: array[0..7] of char;
  end;

  WSAData=packed record
        wVersion:Word;
        wHighVersion:word;
        szDescription: array [0..WSADESCRIPTION_LEN] of char;
        szSystemStatus: array[0..WSASYS_STATUS_LEN] of char;
        iMaxSockets:Word;
        iMaxUdpDg:word;
        lpVendorInfo:PChar;
       // a: array[0..10000] of byte;
  end;
  LPWSADATA=^WSAData;

  WSAQUERYSET=packed record
    dwSize: DWORD;
    lpszServiceInstanceName: pchar;
    lpServiceClassId: ^GUID;
    lpVersion: Pointer;
    lpszComment: pointer;
    dwNameSpace: DWORD;
    lpNSProviderId: ^GUID;
    lpszContext: pchar;
    dwNumberOfProtocols: DWORD;
    lpafpProtocols: pointer;
    lpszQueryString: pointer;
    dwNumberOfCsAddrs: dword;
    lpcsaBuffer: pointer;
    dwOutputFlags: dword;
    lpBlob: pointer;
  end;
  LPWSAQUERYSET=^WSAQUERYSET;

  SOCKADDR_BTH=packed record
    addressFamily: USHORT;  // Always AF_BTH
    btAddr: BTH_ADDR;         // Bluetooth device address
    serviceClassId: GUID; // [OPTIONAL] system will query SDP for port
    port: ulong;           // RFCOMM channel or L2CAP PSM
  end;
  PSOCKADDR_BTH=^SOCKADDR_BTH;

  SOCKET_ADDRESS=packed record
    lpSockaddr: pointer;
    iSockaddrLength: Integer;
  end;

  CSADDR_INFO=packed record
    LocalAddr: SOCKET_ADDRESS;
    RemoteAddr: SOCKET_ADDRESS;
    iSocketType: Integer ;
    iProtocol: Integer;
  end;
  LPCSADDR_INFO=^CSADDR_INFO;

  WSAESETSERVICEOP=(
    RNRSERVICE_REGISTER=0,
    RNRSERVICE_DEREGISTER,
    RNRSERVICE_DELETE
  );


  TSocket=integer;

var
  DLLModule: THandle;

  WSAStartup: function(wVersionRequested: word; lpWSAData: LPWSADATA): Integer; stdcall;
  WSAGetLastError: function(): integer; stdcall;
  socket: function(af: Integer; type_: integer; protocol: Integer): TSocket; stdcall;
  bind: function(s: TSOCKET; name: pointer; namelen: integer):  integer; stdcall;
  listen: function(s: TSocket; backlog: Integer): Integer; stdcall;
  accept: function(s: TSocket; a: pointer; b: Pointer): TSocket; stdcall;
  getsockname: function(s :TSocket; name: Pointer; namelen: Pointer): Integer; stdcall;
  WSASetService: function(lpqsRegInfo: LPWSAQUERYSET; essoperation:WSAESETSERVICEOP; dwControlFlags: Cardinal): Integer; stdcall;
  recv: function(s:TSocket; buf: pointer; len: Integer; flags: Integer):Integer; stdcall;

function LoadDll: Boolean;
function ReleaseDll: Boolean;

implementation

function LoadDll: Boolean;
var
  m: String;
  p:pointer;
  vWSAData: WSAData;
begin
    Result:=True;
    if DllModule<>0 then Exit;
    m:='ws2_32.dll';
    DllModule:=LoadLibrary(PAnsiChar(m));

    if DllModule=0 then
    begin
        Result:=false;
        exit;
    end ;

    //p:=GetProcAddress(DllModule, 'WSAStarfftup');
    wsaStartup:=GetProcAddress(DllModule, 'WSAStartup');
    WSAGetLastError:=GetProcAddress(DllModule, 'WSAGetLastError');
    socket:=GetProcAddress(DllModule, 'socket');
    bind:=GetProcAddress(DllModule, 'bind');
    listen:=GetProcAddress(DllModule, 'listen');
    accept:=GetProcAddress(DllModule, 'accept');
    getsockname:=GetProcAddress(DllModule, 'getsockname');
    WSASetService:=GetProcAddress(DllModule, 'WSASetServiceW');
    if(@WSASetService=nil) then WSASetService:=GetProcAddress(DllModule, 'WSASetServiceA');
    recv:=GetProcAddress(DllModule, 'recv');
   // WSAStartup($0202, @vWsadata);
end;

function ReleaseDll: Boolean;
begin
    if DllModule<>0 then
    begin
        FreeLibrary(DllModule);
        DllModule:=0;
    end ;
    Result:=true;
end;

initialization

  LoadDll();

finalization

  ReleaseDll();

end.
