const
  GWsDLLName      = 'wsock32.dll';      { 32 bits TCP/IP system DLL }
  GWs2DLLName     = 'ws2_32.dll';       { 32 bits TCP/IP system DLL version 2}
  GWship6DLLName  = 'wship6.dll';       { IPv6 }

var
  WSocketGForced  : Boolean = FALSE;

  GWsDLLHandle      : HMODULE  = 0;
  GWs2DLLHandle     : HMODULE  = 0;
  GWship6DllHandle  : HMODULE  = 0;
  GWs2ProcHandle    : HMODULE  = 0;
  GHasIPv6Func      : Boolean  = FALSE;
  GInitData         : TWSADATA;

type
    TWSAStartup            = function (wVersionRequired: word;
                                       var WSData: TWSAData): Integer; stdcall;
    TWSACleanup            = function : Integer; stdcall;
    TWSASetLastError       = procedure (iError: Integer); stdcall;
    TWSAGetLastError       = function : Integer; stdcall;
    TWSACancelAsyncRequest = function (hAsyncTaskHandle: THandle): Integer; stdcall;
    TWSAAsyncGetHostByName = function (HWindow: HWND;
                                       wMsg: u_int;
                                       name, buf: PAnsiChar;
                                       buflen: Integer): THandle; stdcall;
    TWSAAsyncGetHostByAddr = function (HWindow: HWND;
                                       wMsg: u_int; addr: PAnsiChar;
                                       len, Struct: Integer;
                                       buf: PAnsiChar;
                                       buflen: Integer): THandle; stdcall;
    TWSAAsyncSelect        = function (s: TSocket;
                                       HWindow: HWND;
                                       wMsg: u_int;
                                       lEvent: Longint): Integer; stdcall;
    TGetServByName         = function (name, proto: PAnsiChar): PServEnt; stdcall;
    TGetProtoByName        = function (name: PAnsiChar): PProtoEnt; stdcall;
    TGetHostByName         = function (name: PAnsiChar): PHostEnt; stdcall;
    TGetHostByAddr         = function (addr: Pointer; len, Struct: Integer): PHostEnt; stdcall;
    TGetHostName           = function (name: PAnsiChar; len: Integer): Integer; stdcall;
    TOpenSocket            = function (af, Struct, protocol: Integer): TSocket; stdcall;
    TShutdown              = function (s: TSocket; how: Integer): Integer; stdcall;
    TSetSockOpt            = function (s: TSocket; level, optname: Integer;
                                       optval: PAnsiChar;
                                       optlen: Integer): Integer; stdcall;
    TGetSockOpt            = function (s: TSocket; level, optname: Integer;
                                       optval: PAnsiChar;
                                       var optlen: Integer): Integer; stdcall;
    TSendTo                = function (s: TSocket; var Buf;
                                       len, flags: Integer;
                                       var addrto: TSockAddr;
                                       tolen: Integer): Integer; stdcall;
    TSend                  = function (s: TSocket; var Buf;
                                       len, flags: Integer): Integer; stdcall;
    TRecv                  = function (s: TSocket;
                                       var Buf;
                                       len, flags: Integer): Integer; stdcall;
    TRecvFrom              = function (s: TSocket;
                                       var Buf; len, flags: Integer;
                                       var from: TSockAddr;
                                       var fromlen: Integer): Integer; stdcall;
    Tntohs                 = function (netshort: u_short): u_short; stdcall;
    Tntohl                 = function (netlong: u_long): u_long; stdcall;
    TListen                = function (s: TSocket;
                                       backlog: Integer): Integer; stdcall;
    TIoctlSocket           = function (s: TSocket; cmd: DWORD;
                                       var arg: u_long): Integer; stdcall;
    TWSAIoctl              = function (s                 : TSocket;
                                       IoControlCode     : DWORD;
                                       InBuffer          : Pointer;
                                       InBufferSize      : DWORD;
                                       OutBuffer         : Pointer;
                                       OutBufferSize     : DWORD;
                                       var BytesReturned : DWORD;
                                       Overlapped        : POverlapped;
                                       CompletionRoutine : FARPROC): Integer; stdcall;
    TInet_ntoa             = function (inaddr: TInAddr): PAnsiChar; stdcall; 
    TInet_addr             = function (cp: PAnsiChar): u_long; stdcall;
    Thtons                 = function (hostshort: u_short): u_short; stdcall;
    Thtonl                 = function (hostlong: u_long): u_long; stdcall;
    TGetSockName           = function (s: TSocket; var name: TSockAddr;
                                       var namelen: Integer): Integer; stdcall;
    TGetPeerName           = function (s: TSocket; var name: TSockAddr;
                                       var namelen: Integer): Integer; stdcall;
    TConnect               = function (s: TSocket; var name: TSockAddr;
                                       namelen: Integer): Integer; stdcall;
    TCloseSocket           = function (s: TSocket): Integer; stdcall;
    TBind                  = function (s: TSocket; var addr: TSockAddr;
                                       namelen: Integer): Integer; stdcall;
    TAccept                = function (s: TSocket; addr: PSockAddr;
                                       addrlen: PInteger): TSocket; stdcall;
    TGetAddrInfo           = function(NodeName: PChar; ServName: PChar;
                                      Hints: PAddrInfo;
                                      var Addrinfo: PAddrInfo): Integer; stdcall;
    TFreeAddrInfo          = procedure(ai: PAddrInfo); stdcall;
    TGetNameInfo           = function(addr: PSockAddr; namelen: Integer;
                                      host: PChar; hostlen: DWORD;
                                      serv: PChar; servlen: DWORD;
                                      flags: Integer): Integer; stdcall;
var
   FWSAStartup            : TWSAStartup = nil;
   FWSACleanup            : TWSACleanup = nil;
   FWSASetLastError       : TWSASetLastError = nil;
   FWSAGetLastError       : TWSAGetLastError = nil;
   FWSACancelAsyncRequest : TWSACancelAsyncRequest = nil;
   FWSAAsyncGetHostByName : TWSAAsyncGetHostByName = nil;
   FWSAAsyncGetHostByAddr : TWSAAsyncGetHostByAddr = nil;
   FWSAAsyncSelect        : TWSAAsyncSelect = nil;
   FGetServByName         : TGetServByName = nil;
   FGetProtoByName        : TGetProtoByName = nil;
   FGetHostByName         : TGetHostByName = nil;
   FGetHostByAddr         : TGetHostByAddr = nil;
   FGetHostName           : TGetHostName = nil;
   FOpenSocket            : TOpenSocket = nil;
   FShutdown              : TShutdown = nil;
   FSetSockOpt            : TSetSockOpt = nil;
   FGetSockOpt            : TGetSockOpt = nil;
   FSendTo                : TSendTo = nil;
   FSend                  : TSend = nil;
   FRecv                  : TRecv = nil;
   FRecvFrom              : TRecvFrom = nil;
   Fntohs                 : Tntohs = nil;
   Fntohl                 : Tntohl = nil;
   FListen                : TListen = nil;
   FIoctlSocket           : TIoctlSocket = nil;
   FWSAIoctl              : TWSAIoctl = nil;
   FInet_ntoa             : TInet_ntoa = nil;
   FInet_addr             : TInet_addr = nil;
   Fhtons                 : Thtons = nil;
   Fhtonl                 : Thtonl = nil;
   FGetSockName           : TGetSockName = nil;
   FGetPeerName           : TGetPeerName = nil;
   FConnect               : TConnect = nil;
   FCloseSocket           : TCloseSocket = nil;
   FBind                  : TBind = nil;
   FAccept                : TAccept = nil;
   FGetAddrInfo           : TGetAddrInfo = nil;
   FFreeAddrInfo          : TFreeAddrInfo = nil;
   FGetNameInfo           : TGetNameInfo = nil;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SocketErrorDesc(ErrCode : Integer) : String;
begin
    case ErrCode of
    0:
      Result := 'No Error';
    WSAEINTR:
      Result := 'Interrupted system call';
    WSAEBADF:
      Result := 'Bad file number';
    WSAEACCES:
      Result := 'Permission denied';
    WSAEFAULT:
      Result := 'Bad address';
    WSAEINVAL:
      Result := 'Invalid argument';
    WSAEMFILE:
      Result := 'Too many open files';
    WSAEWOULDBLOCK:
      Result := 'Operation would block';
    WSAEINPROGRESS:
      Result := 'Operation now in progress';
    WSAEALREADY:
      Result := 'Operation already in progress';
    WSAENOTSOCK:
      Result := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      Result := 'Destination address required';
    WSAEMSGSIZE:
      Result := 'Message too long';
    WSAEPROTOTYPE:
      Result := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      Result := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      Result := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      Result := 'Socket type not supported';
    WSAEOPNOTSUPP:
      Result := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      Result := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      Result := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      Result := 'Address already in use';
    WSAEADDRNOTAVAIL:
      Result := 'Address not available';
    WSAENETDOWN:
      Result := 'Network is down';
    WSAENETUNREACH:
      Result := 'Network is unreachable';
    WSAENETRESET:
      Result := 'Network dropped connection on reset';
    WSAECONNABORTED:
      Result := 'Connection aborted';
    WSAECONNRESET:
      Result := 'Connection reset by peer';
    WSAENOBUFS:
      Result := 'No buffer space available';
    WSAEISCONN:
      Result := 'Socket is already connected';
    WSAENOTCONN:
      Result := 'Socket is not connected';
    WSAESHUTDOWN:
      Result := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      Result := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      Result := 'Connection timed out';
    WSAECONNREFUSED:
      Result := 'Connection refused';
    WSAELOOP:
      Result := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      Result := 'File name too long';
    WSAEHOSTDOWN:
      Result := 'Host is down';
    WSAEHOSTUNREACH:
      Result := 'No route to host';
    WSAENOTEMPTY:
      Result := 'Directory not empty';
    WSAEPROCLIM:
      Result := 'Too many processes';
    WSAEUSERS:
      Result := 'Too many users';
    WSAEDQUOT:
      Result := 'Disc quota exceeded';
    WSAESTALE:
      Result := 'Stale NFS file handle';
    WSAEREMOTE:
      Result := 'Too many levels of remote in path';
    WSASYSNOTREADY:
      Result := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      Result := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      Result := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      Result := 'Host not found';
    WSATRY_AGAIN:
      Result := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      Result := 'Non-recoverable error';
    WSANO_DATA:
      Result := 'No Data';
    else
      Result := 'Not a WinSock error';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetWinsockErr(ErrCode: Integer): String ;    { V5.26 }
begin
    Result := SocketErrorDesc(ErrCode) + ' (#' + IntToStr(ErrCode) + ')' ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetProc(const ProcName : AnsiString) : Pointer;
var
    LastError : Longint;
begin
    { Prevents compiler warning "Return value might be undefined"  }
    Result := nil;

    EnterCriticalSection(GWSockCritSect);
    try
        if GWs2DLLHandle = 0 then begin
            GWs2DLLHandle := LoadLibrary(GWs2DLLName);
            if GWs2DLLHandle = 0 then
                raise Exception.Create('Unable to load ' + GWs2DLLName +
                              ' - ' + SysErrorMessage(GetLastError));
            LastError := WSAStartup(MAKEWORD(GReqVerLow, GReqVerHigh), GInitData);
            if LastError <> 0 then
                raise ESocketAPIException.Create('Winsock startup error ' +
                               GWs2DLLName + ' - ' + GetWinsockErr (LastError));
        end;
        if Length(ProcName) = 0 then
            Result := nil
        else begin
            Result := GetProcAddress(GWs2DLLHandle, PAnsiChar(ProcName));
            if Result = nil then
                raise ESocketAPIException.Create('Procedure ' + String(ProcName) +
                                              ' not found in ' + GWs2DLLName +
                                   ' - ' + SysErrorMessage(GetLastError));
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetProc2(const ProcName : AnsiString) : Pointer;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if GWs2DLLHandle = 0 then begin
                GetProc('');
            GHasIPv6Func := FALSE;
            {
            if (Win32Platform <> VER_PLATFORM_WIN32_NT) or
                                               (Win32MajorVersion < 5) then
                Exit;
            }
            GWs2ProcHandle := GWs2DLLHandle;
            @FGetAddrInfo := GetProcAddress(GWs2ProcHandle,
                {$IFDEF UNICODE}'GetAddrInfoW' {$ELSE} 'getaddrinfo' {$ENDIF});
            if @FGetAddrInfo = nil then
            begin
                GWship6DllHandle := LoadLibrary(GWship6DLLname);
                GWs2ProcHandle := GWship6DllHandle;
                @FGetAddrInfo := GetProcAddress(GWs2ProcHandle,
                {$IFDEF UNICODE}'GetAddrInfoW' {$ELSE} 'getaddrinfo' {$ENDIF});
            end;
            GHasIPv6Func := @FGetAddrInfo <> nil;
        end;
        if Length(ProcName) = 0 then
            Result := nil
        else begin
            Result := GetProcAddress(GWs2DLLHandle, PAnsiChar(ProcName));
            if Result = nil then
                raise ESocketAPIException.Create('Procedure ' + String(ProcName) +
                                              ' not found in ' + GWs2DLLName +
                                ' - ' + SysErrorMessage(GetLastError));
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  IsSocketAPILoaded : Boolean;
begin
    Result := GWs2DLLHandle <> 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Winsock is dynamically loaded and unloaded when needed. In some cases     }
{ you may find winsock being loaded and unloaded very often in your app     }
{ This happend for example when you dynamically create a TWSocket and       }
{ destroy a TWSocket when there is no "permanant" TWSocket (that is a       }
{ TWSocket dropped on a persitant form). It is the very inefficiant.        }
{ Calling WSocketForceLoadWinsock will increament the reference count so    }
{ that winsock will not be unloaded when the last TWSocket is destroyed.    }
procedure ForceLoadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if not WSocketGForced then begin
            WSocketGForced := TRUE;
            Inc(WSocketGCount);
            GetProc('');
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Cancel the operation done with WSocketForceLoadWinsock.                   }
procedure CancelForceLoadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if WSocketGForced then begin
            WSocketGForced := FALSE;
            Dec(WSocketGCount);
            if WSocketGCount <= 0 then
                UnloadWinsock;
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure UnloadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if (GWsDLLHandle <> 0) and (WSocketGCount = 0) then begin
            WSACleanup;
            if GWs2DLLHandle <> 0 then begin
                FreeLibrary(GWs2DLLHandle);
                GWs2DLLHandle      := 0;
                FWSAIoctl          := nil;
                if GWship6DllHandle <> 0 then begin
                    FreeLibrary(GWs2DLLHandle);
                    GWship6DllHandle := 0;
                end;
                FGetAddrInfo       := nil;
                FFreeAddrInfo      := nil;
                FGetNameInfo       := nil;
            end;
            FreeLibrary(GWsDLLHandle);
            GWsDLLHandle           := 0;
            FWSAStartup            := nil;
            FWSACleanup            := nil;
            FWSASetLastError       := nil;
            FWSAGetLastError       := nil;
            FWSACancelAsyncRequest := nil;
            FWSAAsyncGetHostByName := nil;
            FWSAAsyncGetHostByAddr := nil;
            FWSAAsyncSelect        := nil;
            FGetServByName         := nil;
            FGetProtoByName        := nil;
            FGetHostByName         := nil;
            FGetHostByAddr         := nil;
            FGetHostName           := nil;
            FOpenSocket            := nil;
            FShutdown              := nil;
            FSetSockOpt            := nil;
            FGetSockOpt            := nil;
            FSendTo                := nil;
            FSend                  := nil;
            FRecv                  := nil;
            FRecvFrom              := nil;
            Fntohs                 := nil;
            Fntohl                 := nil;
            FListen                := nil;
            FIoctlSocket           := nil;
            FWSAIoctl              := nil;
            FInet_ntoa             := nil;
            FInet_addr             := nil;
            Fhtons                 := nil;
            Fhtonl                 := nil;
            FGetSockName           := nil;
            FGetPeerName           := nil;
            FConnect               := nil;
            FCloseSocket           := nil;
            FBind                  := nil;
            FAccept                := nil;
        end;
        WSocketGForced := FALSE;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WinsockInfo : TWSADATA;
begin
    { Load winsock and initialize it as needed }
    EnterCriticalSection(GWSockCritSect);
    try
        GetProc('');
        Result := GInitData;
        { If no socket created, then unload winsock immediately }
        if WSocketGCount <= 0 then
            UnloadWinsock;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAStartup(
    wVersionRequired: word;
    var WSData: TWSAData): Integer;
begin
    if @FWSAStartup = nil then
        @FWSAStartup := GetProc('WSAStartup');
    Result := FWSAStartup(wVersionRequired, WSData);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSACleanup : Integer;
begin
    if @FWSACleanup = nil then
        @FWSACleanup := GetProc('WSACleanup');
    Result := FWSACleanup;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure WSASetLastError(iError: Integer);
begin
    if @FWSASetLastError = nil then
        @FWSASetLastError := GetProc('WSASetLastError');
    FWSASetLastError(iError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAGetLastError: Integer;
begin
    if @FWSAGetLastError = nil then
        @FWSAGetLastError := GetProc('WSAGetLastError');
    Result := FWSAGetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;
begin
    if @FWSACancelAsyncRequest = nil then
        @FWSACancelAsyncRequest := GetProc('WSACancelAsyncRequest');
    Result := FWSACancelAsyncRequest(hAsyncTaskHandle);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncGetHostByName(
    HWindow: HWND; wMsg: u_int;
    name, buf: PAnsiChar;
    buflen: Integer): THandle;
begin
    if @FWSAAsyncGetHostByName = nil then
        @FWSAAsyncGetHostByName := GetProc('WSAAsyncGetHostByName');
    Result := FWSAAsyncGetHostByName(HWindow, wMsg, name, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncGetHostByAddr(
    HWindow: HWND;
    wMsg: u_int; addr: PAnsiChar;
    len, Struct: Integer;
    buf: PAnsiChar;
    buflen: Integer): THandle;
begin
    if @FWSAAsyncGetHostByAddr = nil then
        @FWSAAsyncGetHostByAddr := GetProc('WSAAsyncGetHostByAddr');
    Result := FWSAAsyncGetHostByAddr(HWindow, wMsg, addr, len, struct, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncSelect(
    s: TSocket;
    HWindow: HWND;
    wMsg: u_int;
    lEvent: Longint): Integer;
begin
    if @FWSAAsyncSelect = nil then
        @FWSAAsyncSelect := GetProc('WSAAsyncSelect');
    Result := FWSAAsyncSelect(s, HWindow, wMsg, lEvent);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getservbyname(name, proto: PAnsiChar): PServEnt;
begin
    if @Fgetservbyname = nil then
        @Fgetservbyname := GetProc('getservbyname');
    Result := Fgetservbyname(name, proto);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getprotobyname(name: PAnsiChar): PProtoEnt;
begin
    if @Fgetprotobyname = nil then
        @Fgetprotobyname := GetProc('getprotobyname');
    Result := Fgetprotobyname(PAnsiChar(Name));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostbyname(name: PAnsiChar): PHostEnt;
begin
    if @Fgethostbyname = nil then
        @Fgethostbyname := GetProc('gethostbyname');
    Result := Fgethostbyname(name);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostbyaddr(addr: Pointer; len, Struct: Integer): PHostEnt;
begin
    if @Fgethostbyaddr = nil then
        @Fgethostbyaddr := GetProc('gethostbyaddr');
    Result := Fgethostbyaddr(addr, len, Struct);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostname(name: PAnsiChar; len: Integer): Integer;
begin
    if @Fgethostname = nil then
        @Fgethostname := GetProc('gethostname');
    Result := Fgethostname(name, len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function socket(af, Struct, protocol: Integer): TSocket;
begin
    if @FOpenSocket= nil then
        @FOpenSocket := GetProc('socket');
    Result := FOpenSocket(af, Struct, protocol);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function shutdown(s: TSocket; how: Integer): Integer;
begin
    if @FShutdown = nil then
        @FShutdown := GetProc('shutdown');
    Result := FShutdown(s, how);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function setsockopt(s: TSocket; level, optname: Integer;
  optval: PAnsiChar; optlen: Integer): Integer; overload;
begin
    if @FSetSockOpt = nil then
        @FSetSockOpt := GetProc('setsockopt');
    Result := FSetSockOpt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getsockopt(
    s: TSocket; level, optname: Integer;
    optval: PAnsiChar; var optlen: Integer): Integer;
begin
    if @FGetSockOpt = nil then
        @FGetSockOpt := GetProc('getsockopt');
    Result := FGetSockOpt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function sendto(
    s          : TSocket;
    var Buf;
    len, flags : Integer;
    var addrto : TSockAddr;
    tolen      : Integer): Integer;
begin
    if @FSendTo = nil then
        @FSendTo := GetProc('sendto');
    Result := FSendTo(s, Buf, len, flags, addrto, tolen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function send(s: TSocket; var Buf;
  len, flags: Integer): Integer;
begin
    if @FSend = nil then
        @FSend := GetProc('send');
    Result := FSend(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohs(netshort: u_short): u_short;
begin
    if @Fntohs = nil then
        @Fntohs := GetProc('ntohs');
    Result := Fntohs(netshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohl(netlong: u_long): u_long;
begin
    if @Fntohl = nil then
        @Fntohl := GetProc('ntohl');
    Result := Fntohl(netlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function listen(s: TSocket; backlog: Integer): Integer;
begin
    if @FListen = nil then
        @FListen := GetProc('listen');
    Result := FListen(s, backlog);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer;
begin
    if @FIoctlSocket = nil then
        @FIoctlSocket := GetProc('ioctlsocket');
    Result := FIoctlSocket(s, cmd, arg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAIoctl(
    s                 : TSocket; IoControlCode : DWORD;
    InBuffer          : Pointer; InBufferSize  : DWORD;
    OutBuffer         : Pointer; OutBufferSize : DWORD;
    var BytesReturned : DWORD; Overlapped      : POverlapped;
    CompletionRoutine : FARPROC): Integer;
begin
    if @FWSAIoctl = nil then
        @FWSAIoctl := GetProc2('WSAIoctl');
    Result := FWSAIoctl(s, IoControlCode, InBuffer, InBufferSize, OutBuffer,
                        OutBufferSize, BytesReturned, Overlapped, CompletionRoutine);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function inet_ntoa(inaddr: TInAddr): PAnsiChar;
begin
    if @FInet_ntoa = nil then
        @FInet_ntoa := GetProc('inet_ntoa');
    Result := FInet_ntoa(inaddr);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function inet_addr(cp: PAnsiChar): u_long;
begin
    if @FInet_addr = nil then
        @FInet_addr := GetProc('inet_addr');
    Result := FInet_addr(cp);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htons(hostshort: u_short): u_short;
begin
    if @Fhtons = nil then
        @Fhtons := GetProc('htons');
    Result := Fhtons(hostshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htonl(hostlong: u_long): u_long;
begin
    if @Fhtonl = nil then
        @Fhtonl := GetProc('htonl');
    Result := Fhtonl(hostlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getsockname(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer;
begin
    if @FGetSockName = nil then
        @FGetSockName := GetProc('getsockname');
    Result := FGetSockName(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getpeername(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer;
begin
    if @FGetPeerName = nil then
        @FGetPeerName := GetProc('getpeername');
    Result := FGetPeerName(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function connect(
    s        : TSocket;
    var name : TSockAddr;
    namelen  : Integer): Integer;
begin
    if @FConnect= nil then
        @FConnect := GetProc('connect');
    Result := FConnect(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function closesocket(s: TSocket): Integer;
begin
    if @FCloseSocket = nil then
        @FCloseSocket := GetProc('closesocket');
    Result := FCloseSocket(s);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function bind(
    s: TSocket;
    var addr: TSockAddr;
    namelen: Integer): Integer;
begin
    if @FBind = nil then
        @FBind := GetProc('bind');
    Result := FBind(s, addr, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function accept(
    s: TSocket;
    addr: PSockAddr;
    addrlen: PInteger): TSocket;
begin
    if @FAccept = nil then
        @FAccept := GetProc('accept');
    Result := FAccept(s, addr, addrlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function recv(s: TSocket; var Buf;
  len, flags: Integer): Integer;
begin
    if @FRecv= nil then
        @FRecv := GetProc('recv');
    Result := FRecv(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function recvfrom(
    s: TSocket;
    var Buf; len, flags: Integer;
    var from: TSockAddr;
    var fromlen: Integer): Integer;
begin
    if @FRecvFrom = nil then
        @FRecvFrom := GetProc('recvfrom');
    Result := FRecvFrom(s, Buf, len, flags, from, fromlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetAddrInfo(
    NodeName    : PChar;
    ServName    : PChar;
    Hints       : PAddrInfo;
    var Addrinfo: PAddrInfo): Integer;
begin
    if @FGetAddrInfo = nil then
        @FGetAddrInfo := GetProc2(
           {$IFDEF UNICODE}'GetAddrInfoW' {$ELSE} 'getaddrinfo' {$ENDIF});
    Result := FGetAddrInfo(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure FreeAddrInfo(ai: PAddrInfo);
begin
    if @FFreeAddrInfo = nil then
        @FFreeAddrInfo := GetProc2(
              {$IFDEF UNICODE}'FreeAddrInfoW' {$ELSE} 'freeaddrinfo' {$ENDIF});
    FFreeAddrInfo(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetNameInfo(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PChar;
    hostlen : LongWord;
    serv    : PChar;
    servlen : LongWord;
    flags   : Integer): Integer;
begin
    if @FGetNameInfo = nil then
        @FGetNameInfo := GetProc2(
                 {$IFDEF UNICODE}'GetNameInfoW' {$ELSE} 'getnameinfo' {$ENDIF});
    Result := FGetNameInfo(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ Macros }

function IN6ADDR_ANY_INIT: TIn6Addr;
begin
    with Result do
        FillChar(s6_addr, SizeOf(TIn6Addr), 0);
end;

function IN6ADDR_LOOPBACK_INIT: TIn6Addr;
begin
    with Result do
    begin
        FillChar(s6_addr, SizeOf(TIn6Addr), 0);
        s6_addr[15] := $01;
    end;
end;

procedure IN6ADDR_SETANY(sa: PSockAddrIn6);
begin
    if sa <> nil then
        with sa^ do
        begin
            sin6_family := AF_INET6;
            sin6_port := 0;
            sin6_flowinfo := 0;
            PULONG(@sin6_addr.s6_addr[0])^  := 0;
            PULONG(@sin6_addr.s6_addr[4])^  := 0;
            PULONG(@sin6_addr.s6_addr[8])^  := 0;
            PULONG(@sin6_addr.s6_addr[12])^ := 0;
        end;
end;

procedure IN6ADDR_SETLOOPBACK(sa: PSockAddrIn6);
begin
    if sa <> nil then begin
        with sa^ do begin
          sin6_family := AF_INET6;
          sin6_port := 0;
          sin6_flowinfo := 0;
          PULONG(@sin6_addr.s6_addr[0])^ := 0;
          PULONG(@sin6_addr.s6_addr[4])^ := 0;
          PULONG(@sin6_addr.s6_addr[8])^ := 0;
          PULONG(@sin6_addr.s6_addr[12])^ := 1;
        end;
    end;
end;

function IN6ADDR_ISANY(sa: PSockAddrIn6): Boolean;
begin
    if sa <> nil then begin
        with sa^ do begin
            Result := (sin6_family = AF_INET6) and
                      (PULONG(@sin6_addr.s6_addr[0])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[4])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[8])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[12])^ = 0);
        end;
    end
    else
      Result := False;
end;

function IN6ADDR_ISLOOPBACK(sa: PSockAddrIn6): Boolean;
begin
    if sa <> nil then begin
        with sa^ do begin
            Result := (sin6_family = AF_INET6) and
                      (PULONG(@sin6_addr.s6_addr[0])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[4])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[8])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[12])^ = 1);
        end;
    end
    else
      Result := False;
end;

function IN6_ADDR_EQUAL(const a: PIn6Addr; const b: PIn6Addr): Boolean;
begin
    Result := CompareMem(a, b, SizeOf(TIn6Addr));
end;

function IN6_IS_ADDR_UNSPECIFIED(const a: PIn6Addr): Boolean;
begin
    Result := IN6_ADDR_EQUAL(a, @in6addr_any);
end;

function IN6_IS_ADDR_LOOPBACK(const a: PIn6Addr): Boolean;
begin
    Result := IN6_ADDR_EQUAL(a, @in6addr_loopback);
end;

function IN6_IS_ADDR_MULTICAST(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FF)
    else
        Result := False;
end;

function IN6_IS_ADDR_LINKLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FE) and ((a^.s6_addr[1] and $C0) = $80)
    else
        Result := False;
end;

function IN6_IS_ADDR_SITELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FE) and ((a^.s6_addr[1] and $C0) = $C0)
    else
        Result := False;
end;

function IN6_IS_ADDR_V4MAPPED(const a: PIn6Addr): Boolean;
begin
    if a <> nil then begin
        with a^ do begin
            Result := (Word[0] = 0) and
                      (Word[1] = 0) and
                      (Word[2] = 0) and
                      (Word[3] = 0) and
                      (Word[4] = 0) and
                      (Word[5] = $FFFF);
        end;
    end
    else
        Result := False;
end;

function IN6_IS_ADDR_V4COMPAT(const a: PIn6Addr): Boolean;
begin
    if a <> nil then begin
        with a^ do begin
          Result := (Word[0] = 0) and
                    (Word[1] = 0) and
                    (Word[2] = 0) and
                    (Word[3] = 0) and
                    (Word[4] = 0) and
                    (Word[5] = 0) and
                    not ((Word[6] = 0) and (s6_addr[14] = 0) and
                    ((s6_addr[15] = 0) or (s6_addr[15] = 1)));
        end;
    end
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_NODELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 1)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_LINKLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 2)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_SITELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 5)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_ORGLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 8)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_GLOBAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = $E)
    else
        Result := False;
end;


    

