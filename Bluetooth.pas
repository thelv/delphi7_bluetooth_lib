unit Bluetooth;

interface
  uses winsock2;
  
var
  vWSAData: WSAData;
  vGuid: GUID;

function start(): Integer;

implementation

var
  a: integer;

function start(): Integer;
var
  socketServer, socketClient: TSocket;
//  sockAddrLocal: SOCKADD
  res: Integer;
  SockAddrBthLocal: SOCKADDR_BTH;
  addrLen: integer;
  vwsaQuerySet: WSAQUERYSET;
  vCSAddrInfo:CSADDR_INFO;
begin
  addrLen:=sizeof(SOCKADDR_BTH);
  vGuid.Data1:= $b62c4e8d;
  vGuid.Data2:=$62cc;
  vGuid.Data3:=$404b;
  vGuid.Data4[0]:=Chr($bb);
  vGuid.Data4[1]:=chr($bf);
  vGuid.Data4[2]:=chr($bf);
  vGuid.Data4[3]:=chr($3e);
  vGuid.Data4[4]:=chr($3b);
  vGuid.Data4[5]:=chr($bb);
  vGuid.Data4[6]:=chr($13);
  vGuid.Data4[7]:=chr($74);        
  FillChar(SockAddrBthLocal, SizeOf(SOCKADDR_BTH), chr(0));
  //res:=11;
  res:=WSAStartup($0202, @vWsadata);
  //while(res=123) do begin
    socketServer:=socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
    //if(socketServer=9) then res:=7;

    SockAddrBthLocal.addressFamily := AF_BTH;
    SockAddrBthLocal.port := BT_PORT_ANY;
    SockAddrBthLocal.serviceClassId:=vGuid;
  //end;
   res:=bind(socketServer, @sockAddrBthLocal, SizeOf(SOCKADDR_BTH));
   //if(res=9) then res:=7;
   res:=listen(socketServer, CXN_DEFAULT_LISTEN_BACKLOG);
    //if(res=9) then res:=7; if(res=9) then res:=7;
       res:=WSAGetLastError();
    //if(res=9) then res:=7;
    res:=getsockname(socketServer, @sockaddrbthlocal, @addrLen);
    //if(res=9) then res:=7;

    FillChar(vwsaQuerySet, sizeof(WSAQUERYSET), chr(0));
        vwsaQuerySet.dwSize:= sizeof(WSAQUERYSET);
        vwsaQuerySet.lpServiceClassId := @vGUID;
        vwsaQuerySet.dwNameSpace:=NS_BTH;
        vwsaQuerySet.dwNumberOfCsAddrs:=1;

        vCSAddrInfo.LocalAddr.iSockaddrLength:=SizeOf(sockaddr_bth);
        vCSAddrInfo.LocalAddr.lpSockaddr:=@sockAddrBthLocal;
        vCSAddrInfo.RemoteAddr.iSockaddrLength:=SizeOf(sockaddr_bth);
        vCSAddrInfo.RemoteAddr.lpSockaddr:=@sockAddrBthLocal;
        vCSAddrInfo.iSocketType:=SOCK_STREAM;
        vCSAddrInfo.iProtocol:=BTHPROTO_RFCOMM;

        vwsaQuerySet.lpcsaBuffer:=@vCSAddrInfo;
		
        vwsaQuerySet.lpszComment:=Pointer(PChar('some comment'));
        vwsaQuerySet.lpszServiceInstanceName:=Pointer(PChar('some name'));

        res:=WSASetService(@vwsaQuerySet, RNRSERVICE_REGISTER, 0);

       //if(res=9) then res:=7;
   //res:=WSAGetLastError();
         // if(res=9) then res:=7;
   socketClient:=accept(socketServer, Nil, nil);
   
   //
  // then do recv and send
  // actlen:=recv(socketClient , *some pointer on buffer*, len, 0);
end;

initialization

finalization

end.

