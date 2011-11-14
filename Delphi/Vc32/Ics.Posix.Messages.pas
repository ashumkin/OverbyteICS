{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels
Creation:     October 30, 2011
Description:  Emulates Windows messages on MacOS.
Version:      0.9 Beta
EMail:        <arno.garrels@gmx.de>
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2011-2011 by Arno Garrels, Berlin, Germany,
              <arno.garrels@gmx.de>

              This software is freeware and provided 'as-is', without any
              express or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of this
              software.

              The following restrictions apply:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.


History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

unit Ics.Posix.Messages;

interface

{$I OverbyteIcsDefs.inc}

uses
  System.SysUtils,  System.Classes,  System.SyncObjs,
  Posix.PThread,
  Posix.Errno,
{$IFDEF MACOS}
  System.Mac.CFUtils,
  Macapi.CoreFoundation,
  Macapi.Foundation,
{$ENDIF}
{$IFNDEF NOFORMS}
  FMX.Forms,
  FMX.Platform,
  {$IFDEF MACOS}
    Macapi.AppKit,
  {$ENDIF}
{$ENDIF}
  Ics.Posix.WinTypes,
  OverbyteIcsAvlTrees;

const
  MESSAGE_QUEUE_SIZE  = 10000;

{ Message IDs }
  { 0 through WM_USER –1	Messages reserved for use by the system. }
  WM_NULL             = $00000000;
  WM_QUIT             = $00000002;
  WM_TIMER            = $00000003;
  { ------------------------- }
  WM_USER             = $00000400; // through 0x7FFF	Integer messages for use by private window classes.
  WM_APP              = $00008000; // through 0xBFFF Messages available for use by applications.
  { 0xC000 through 0xFFFF	String messages for use by applications. }
  { ------------------------- }
  { Greater than 0xFFFF	Reserved by the system.                    }
  WM_SYSHIGH          = $00010000;
  WM_ICS_THREAD_TIMER = WM_SYSHIGH + 1;

type
  WPARAM    = NativeUInt;
  LPARAM    = NativeInt;
  LRESULT   = NativeInt;
  HWND      = THandle;

{$A4}
  PMessage = ^TMessage;
  TMessage = record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: WPARAM;
        LParam: LPARAM;
        Result: LRESULT);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

  EIcsMessagePump = class(Exception);

  TWndMethod = procedure (var Msg: TMessage) of object;

  TIcsMessageEvent = function (
    ahWnd   : HWND;
    auMsg   : UINT;
    awParam : WPARAM;
    alParam : LPARAM;
    var Handled: Boolean): LRESULT of object;

  TIcsMessagePumpIdleEvent = procedure(Sender: TObject; var Done: Boolean) of object;
  TIcsExceptionEvent = procedure(Sender: TObject; ExceptObj: Exception) of object;
  { TIcsMessagePump is a thread local singleton }
  TIcsMessagePump = class
  private type
    PIcsSyncMessageRec = ^TIcsSyncMessageRec;
    TIcsSyncMessageRec = record
      aHwnd       : HWND;
      aMsg        : UINT;
      aWParam     : WPARAM;
      aLParam     : LPARAM;
      aResult     : LRESULT;
    end;
  private type
    PSynchronizeRecord = ^TSynchronizeRecord;
    TSynchronizeRecord = record
      FSyncMessageParams: TIcsSyncMessageRec;
      FSynchronizeException: TObject;
    end;
  private type
    TQueueMessage = record
    private
      FWnd      : HWND;
      FMsg      : UINT;
      FWParam   : WPARAM;
      FLParam   : LPARAM;
    end;
    PQueueMessage = ^TQueueMessage;

    TMessageQueue = class
    private
      FList : TList;
      FLock : TObject;
      FMessagePump: TIcsMessagePump;
      function GetCount: Integer;
      procedure Lock; inline;
      procedure Unlock; inline;
    public
      constructor Create;
      destructor Destroy; override;
      function Push(AWnd: HWND; AMsg: UINT; AWParam: WPARAM; ALParam: LPARAM): Boolean;
      function PushUnique(AWnd: HWND; AMsg: UINT; AWParam: WPARAM; ALParam: LPARAM): Boolean;
      procedure Clear;
      function Pop: PQueueMessage; {$IFDEF USE_INLINE} inline; {$ENDIF}
      { Removes all messages to AHwnd from the queue }
      procedure RemoveHwnd(AHwnd: HWND);
      property Count: Integer read GetCount;
    end;

    TCFRefType = (rfCFRunLoopTimer, rfCFRunLoopSocket);
    TMessagePumpHandle = record
      MessagePump : TIcsMessagePump;
      CFRef       : Pointer;    // A CFRunLoopSourceRef
      CFRefType   : TCFRefType; // Type of the CFRunLoopSourceRef
      hWindow     : HWND;
      ID          : NativeInt;  // ID plus CFRefType plus hWindow must be unique
      UData       : NativeInt;  // User data
    end;
    PMessagePumpHandle = ^TMessagePumpHandle;

    TMessagePumpHandleList = class
    private
      FList : TList;
      FMessagePump: TIcsMessagePump;
      procedure ReleaseRef(P: PMessagePumpHandle);
    public
      function Add(ACFRef: Pointer; ARefType: TCFRefType; AHwnd: Hwnd;
                   ID: NativeInt; UData: NativeInt): PMessagePumpHandle;
      function Get(AHwnd: Hwnd; ARefType: TCFRefType; ID: NativeInt): PMessagePumpHandle;
      procedure Deallocate(AHwnd: Hwnd; ARefType: TCFRefType; ID: NativeInt);
      procedure DeallocateAll; overload;
      procedure DeallocateAll(AHwnd: Hwnd); overload;
      constructor Create(AMessagePump: TIcsMessagePump);
      destructor Destroy; override;
    end;

  strict private class threadvar
    FCurrentMessagePump: TIcsMessagePump;
  private
    FOnException          : TIcsExceptionEvent;
    FHookedWakeMainThread : Boolean;
    FTerminated           : Boolean;
    FSynchronize          : TSynchronizeRecord;
    FSyncLock             : TCriticalSection;
    FSyncList             : TList;
    FHandles              : TMessagePumpHandleList;
    FRefCnt               : Integer;
    FOnMessage            : TIcsMessageEvent;
    FOnIdle               : TIcsMessagePumpIdleEvent;
    FRunLoopRef           : CFRunLoopRef;
    FWorkSourceRef        : CFRunLoopSourceRef;
    FIdleWorkSourceRef    : CFRunLoopSourceRef;
    FPreWaitObserverRef   : CFRunLoopObserverRef;
    //FPreSourceObserverRef : CFRunLoopObserverRef;
    FEnterExitObserverRef : CFRunLoopObserverRef;
    FThreadID             : TThreadID;
    FMessageQueue         : TMessageQueue;
    FSyncMessageRec       : TIcsSyncMessageRec;
    function CheckForSyncMessages(Timeout: Integer = 0): Boolean;
    procedure MsgSynchronize(ASyncRec: PSynchronizeRecord;
      ADestination: TIcsMessagePump); overload;
    procedure MsgSynchronize(hWnd: HWND; Msg: UINT; wParam: WPARAM;
      lParam: LPARAM; ADestination: TIcsMessagePump); overload;
    function TriggerMessage(ahWnd: HWND; auMsg: UINT;
      awParam: WPARAM; alParam: LPARAM): LRESULT;
    class function GetInstance: TIcsMessagePump; static;
  protected
    procedure RunWork; virtual;
    procedure RunIdleWork; virtual;
  public
    class function NewInstance: TObject; override;
    procedure FreeInstance; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function  ProcessMessage(AWaitTimeoutSec: LongWord = 0): Boolean;
    procedure ProcessMessages(AWaitTimeoutSec: LongWord = 0);
    procedure HandleMessages;
    procedure Wakeup(Sender: TObject);
    procedure HookWakeMainThread;
    procedure UnhookWakeMainThread;
    procedure HandleException(Sender: TObject);
    //class function GetMessagePump(AThreadID: TThreadID): TIcsMessagePump;
    class property Instance: TIcsMessagePump read GetInstance;
    property ThreadID: TThreadID read FThreadID;
    property Terminated: Boolean read FTerminated;
    property OnMessage: TIcsMessageEvent read FOnMessage write FOnMessage;
    property OnIdle: TIcsMessagePumpIdleEvent read FOnIdle write FOnIdle;
    property OnException: TIcsExceptionEvent read FOnException write FOnException;
  end;

{ This is the Delphi class except that Windows events are replaced by TEvent   }
{ EMBT did not port it to POSIX yet, it still maps to TSimpleRWSync in the RTL }
{ To be removed when EMBT provides a similar class for POSIX.                  }
{$IFDEF POSIX}
  TMultiReadExclusiveWriteSynchronizer = class(TInterfacedObject, IReadWriteSync)
  private
    FSentinel: Integer;
    FReadSignal: TEvent;
    FWriteSignal: TEvent;
    FWaitRecycle: Cardinal;
    FWriteRecursionCount: Cardinal;
    tls: TThreadLocalCounter;
    FWriterID: Cardinal;
    FRevisionLevel: Cardinal;
    procedure BlockReaders;
    procedure UnblockReaders;
    procedure UnblockOneWriter;
    procedure WaitForReadSignal;
    procedure WaitForWriteSignal;
{$IFDEF DEBUG_MREWS}
    procedure Debug(const Msg: string);
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
    property RevisionLevel: Cardinal read FRevisionLevel;
  end;
  TMREWSync = TMultiReadExclusiveWriteSynchronizer;
{$ENDIF POSIX}

  function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): LRESULT;
  function PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): Boolean;
  function PostUniqueMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): Boolean;
  function PostThreadMessage(AThreadID: TThreadID; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): Boolean;
  function AllocateHWND(AMethod: TWndMethod): HWND;
  function DeallocateHWND(AHwnd: HWND): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
  function CreateWindow: HWND;
  function DestroyWindow(AHwnd: HWND): Boolean;
  function IsWindow(AHwnd: HWND): Boolean;
  function SetTimer(AHwnd: HWND; nIDEvent: NativeUInt; uElapse: UINT; lpTimerFunc: Pointer): NativeUInt;
  function KillTimer(AHwnd: HWND; nIDEvent: NativeUInt): Boolean;

implementation

{$I Ics.InterlockedApi.inc}

const
  MaxSingle   =  3.4e+38;
  MaxDouble   =  1.7e+308;

type
  TIcsWindow = record
  private
    FThreadID    : TThreadID;
    FMessagePump : TIcsMessagePump;
    FWndProc     : TWndMethod;
  end;
  PIcsWindow = ^TIcsWindow;

type
  { It's a singleton containing one message pump ref per thread }
  TMessagePumpList = class
  private
    FList : TList;
    function FindMessagePump(AMsgPump: TIcsMessagePump): Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AMsgPump: TIcsMessagePump);
    function MessagePumpFromThreadID(AThreadID: TThreadID): TIcsMessagePump;
    procedure Remove(AMsgPump: TIcsMessagePump);
  end;

{ TGlobalWindowTree }

  { Singleton containing all windows of the app }
  TGlobalWindowTree = class
  private
    FTree: TIcsAvlPointerTree;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AWnd: HWND);
    function Contains(AWnd: HWND): Boolean;
    function Remove(AWnd: HWND): Boolean;
    procedure RemoveAndFreeAll(AThreadID: TThreadID);
  end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TGlobalWindowTree.RemoveAndFreeAll(AThreadID: TThreadID);
var
  LPWnd: PIcsWindow;
begin
  for LPWnd in FTree do
  begin
    if LPWnd^.FThreadID = AThreadID then
    begin
      FTree.Remove(LPWnd);
      Dispose(LPWnd);
    end;
  end; 
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TGlobalWindowTree.Add(AWnd: HWND);
begin
    FTree.Add(Pointer(AWnd));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TGlobalWindowTree.Contains(AWnd: HWND): Boolean;
begin
  Result := FTree.Contains(Pointer(AWnd));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TGlobalWindowTree.Create;
begin
  FTree := TIcsAvlPointerTree.Create(False);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TGlobalWindowTree.Destroy;
begin
    FTree.Free;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TGlobalWindowTree.Remove(AWnd: HWND): Boolean;
begin
  Result := FTree.Remove(Pointer(AWnd));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
var
  GLMessagePumps: TMessagePumpList = nil;
  GLWindowTree: TGlobalWindowTree = nil;
  GlobalSync: TMREWSync = nil;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TMessagePumpList }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

constructor TMessagePumpList.Create;
begin
  inherited;
  FList := TList.Create;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TMessagePumpList.Destroy;
begin
    Clear;
    FList.Free;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TMessagePumpList.Clear;
begin
  FList.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TMessagePumpList.Add(AMsgPump: TIcsMessagePump);
begin
  if Assigned(AMsgPump) and (FindMessagePump(AMsgPump) = -1) then
    FList.Add(AMsgPump);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TMessagePumpList.Remove(AMsgPump: TIcsMessagePump);
var
  I: Integer;
begin
  I := FindMessagePump(AMsgPump);
  if I > -1 then
    FList.Delete(I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TMessagePumpList.MessagePumpFromThreadID(
  AThreadID: TThreadID): TIcsMessagePump;
var
  I: Integer;
begin  
  for I := 0 to FList.Count -1 do
  begin
    if TIcsMessagePump(FList[I]).FThreadID = AThreadID then
    begin
      Result := TIcsMessagePump(FList[I]);
      Exit;
    end;
  end;
  Result := nil;  
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TMessagePumpList.FindMessagePump(
  AMsgPump: TIcsMessagePump): Integer;
var
  I: Integer;
begin
  for I := 0 to FList.Count -1 do
  begin
    if FList[I] = Pointer(AMsgPump) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TIcsMessagePump }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{$IFNDEF NOFORMS}
{$IFDEF MACOS}
type
  THackPlatformCocoa = class(TPlatform)  // This is a hack of course !
  private
    NSApp: NSApplication;
  end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ProcessCocoaAppMessageWithTimeout(ATimeOutSec: LongWord): Boolean;  // The hack !
var
  NSApp: NSApplication;
  TimeoutDate: NSDate;
  NSEvt: NSEvent;
begin
  NSApp := THackPlatformCocoa(platform).NSApp;
  if NSApp = nil then
    Exit(False);
  if ATimeoutSec = 0 then
    TimeoutDate := TNSDate.Wrap(TNSDate.OCClass.dateWithTimeIntervalSinceNow(0.1))
  else
    TimeoutDate := TNSDate.Wrap(TNSDate.OCClass.dateWithTimeIntervalSinceNow(ATimeOutSec));
  NSEvt := NSApp.nextEventMatchingMask(NSAnyEventMask, TimeoutDate, NSDefaultRunLoopMode, True);
  Result := NSEvt <> nil;
  if Result then
    NSApp.sendEvent(NSEvt); // Dispatch message
end;
{$ENDIF MACOS}
{$ENDIF !NOFORMS}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.ProcessMessage(AWaitTimeoutSec: LongWord = 0): Boolean;
begin
{$IFNDEF NOFORMS}
  if FThreadID = MainThreadID then
    Result := ProcessCocoaAppMessageWithTimeout(AWaitTimeoutSec)
  else
{$ENDIF}
  if AWaitTimeoutSec = 0 then
    Result := CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, True) = kCFRunLoopRunHandledSource
  else
    Result := CFRunLoopRunInMode(kCFRunLoopDefaultMode, AWaitTimeoutSec, True) = kCFRunLoopRunHandledSource;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.ProcessMessages(AWaitTimeoutSec: LongWord = 0);
begin
  while ProcessMessage(AWaitTimeoutSec) do {loop};
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.HandleMessages;
begin
{$IFDEF NOFORMS}
  while CFRunLoopRunInMode(kCFRunLoopDefaultMode, MaxDouble, False) <> kCFRunLoopRunStopped do
    {loop};
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*
procedure PreSourceObserver(observer: CFRunLoopObserverRef;
  activity: CFRunLoopActivity; info: Pointer); cdecl;
begin
  Assert((info <> nil) and (TObject(info) is TIcsMessagePump));
end;
*)


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure EnterExitObserver(observer: CFRunLoopObserverRef;
  activity: CFRunLoopActivity; info: Pointer); cdecl;
begin
 { if (info = nil) or (not (TObject(info) is TIcsMessagePump)) then
    raise EIcsMessagePump.Create('EnterExitObserver invalid info pointer'); }
  case activity of
    kCFRunLoopEntry :;
    kCFRunLoopExit  :;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure RunWorkSource(info: Pointer); cdecl;
begin
  if (info = nil) or (not (TObject(info) is TIcsMessagePump)) then
    raise EIcsMessagePump.Create('RunWorkSource invalid info pointer');
	TIcsMessagePump(info).RunWork;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.RunWork;
var
  P: PQueueMessage;
begin
  P := FMessageQueue.Pop;
  if P <> nil then
  begin
    try
      try
        TriggerMessage(P^.FWnd, P^.FMsg, P^.FWParam, P^.FLParam);
      except
        HandleException(Self);
      end;
    finally
      Dispose(P);
      CFRunLoopSourceSignal(FWorkSourceRef);
    end;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure PreWaitObserver(observer: CFRunLoopObserverRef;
  activity: CFRunLoopActivity; info: Pointer); cdecl;
begin
  if (info = nil) or (not (TObject(info) is TIcsMessagePump)) then
    raise EIcsMessagePump.Create('PreWaitObserver invalid info pointer');
  TIcsMessagePump(info).RunIdleWork;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure RunIdleWorkSource(info: Pointer); cdecl;
begin
  if (info = nil) or (not (TObject(info) is TIcsMessagePump)) then
    raise EIcsMessagePump.Create('RunIdleWorkSource invalid info pointer');
	TIcsMessagePump(info).RunIdleWork;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure RunWorkTimer(timer: CFRunLoopTimerRef; info: Pointer); cdecl;
var
  P: TIcsMessagePump.PMessagePumpHandle;
begin
  if (info = nil) then
    raise EIcsMessagePump.Create('RunWorkTimer info pointer = nil');
  P := TIcsMessagePump.PMessagePumpHandle(info);
  P^.MessagePump.TriggerMessage(P^.hWindow, WM_TIMER, WParam(P^.ID), 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.RunIdleWork;
var
  Done: Boolean;
begin
  Done := True;
  try
    if Assigned(FOnIdle) then
      FOnIdle(Self, Done);
    if (not Done) then
      CFRunLoopSourceSignal(FIdleWorkSourceRef)
    else begin
      if Self.CheckForSyncMessages then
      begin
        CFRunLoopSourceSignal(FIdleWorkSourceRef);
        Exit;
      end;
      if FHookedWakeMainThread and
         System.Classes.CheckSynchronize then
        CFRunLoopSourceSignal(FIdleWorkSourceRef);
    end;
  except
    HandleException(Self);
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsClass(Obj: TObject; Cls: TClass): Boolean;
var
  Parent: TClass;
begin
  Parent := Obj.ClassType;
  while (Parent <> nil) and (Parent.ClassName <> Cls.ClassName) do
    Parent := Parent.ClassParent;
  Result := Parent <> nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.HandleException(Sender: TObject);
var
  EObj: TObject;
begin
  EObj := ExceptObject;
  if IsClass(EObj, Exception) then
  begin
    if not IsClass(EObj, EAbort) then
    begin
      if Assigned(FOnException) then
        FOnException(Sender, Exception(EObj))
      else if (GetCurrentThreadID = MainThreadID) then
      begin
        if Assigned(System.Classes.ApplicationHandleException) then
          System.Classes.ApplicationHandleException(Sender)
        else
          System.SysUtils.ShowException(EObj, ExceptAddr);
      end;
    end;
  end
  else if (GetCurrentThreadID = MainThreadID) then
    System.SysUtils.ShowException(EObj, ExceptAddr);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.AfterConstruction;
var
  LSourceContext: CFRunLoopSourceContext;
  LObserverContext: CFRunLoopObserverContext;
begin
  if FRefCnt > 1 then
    Exit;
  FHandles := TMessagePumpHandleList.Create(Self);
  FSyncLock := TCriticalSection.Create;
  FMessageQueue := TMessageQueue.Create;
  FMessageQueue.FMessagePump := Self;
  FThreadID := GetCurrentThreadID;

  FRunLoopRef := CFRunLoopGetCurrent;
  CFRetain(FRunLoopRef); //Get ownership

  { Create and add a work source }
  FillChar(LSourceContext, SizeOf(LSourceContext), 0);
  LSourceContext.info := Self;
  LSourceContext.perform := RunWorkSource;
  FWorkSourceRef := CFRunLoopSourceCreate(nil, 1, @LSourceContext);
  CFRunLoopAddSource(FRunLoopRef, FWorkSourceRef, kCFRunLoopCommonModes);

  { Create and add a idle work source }
  LSourceContext.perform := RunIdleWorkSource;
  FIdleWorkSourceRef := CFRunLoopSourceCreate(nil, 2, @LSourceContext);
  CFRunLoopAddSource(FRunLoopRef, FIdleWorkSourceRef, kCFRunLoopCommonModes);

  { Create and add a pre-wait observer }
  FillChar(LObserverContext, SizeOf(LObserverContext), 0);
  LObserverContext.info := Self;
  FPreWaitObserverRef := CFRunLoopObserverCreate(nil,  // allocator
                                               kCFRunLoopBeforeWaiting,
                                               True,  // repeat
                                               0,     // priority
                                               PreWaitObserver,
                                               @LObserverContext);
  CFRunLoopAddObserver(FRunLoopRef, FPreWaitObserverRef, kCFRunLoopCommonModes);
 (*
  { Create and add a pre-source observer }
  LObserverContext.info := Self;
  FPreSourceObserverRef := CFRunLoopObserverCreate(nil,  // allocator
                                               kCFRunLoopBeforeSources,
                                               True,  // repeat
                                               0,     // priority
                                               PreSourceObserver,
                                               @LObserverContext);
  CFRunLoopAddObserver(FRunLoopRef, FPreSourceObserverRef, kCFRunLoopCommonModes);
  *)
  { Create and add a Enter/Exit observer }
  LObserverContext.info := Self;
  FEnterExitObserverRef := CFRunLoopObserverCreate(nil,  // allocator
                                               kCFRunLoopEntry or kCFRunLoopExit,
                                               True,  // repeat
                                               0,     // priority
                                               EnterExitObserver,
                                               @LObserverContext);
  CFRunLoopAddObserver(FRunLoopRef, FEnterExitObserverRef, kCFRunLoopCommonModes);

{$IFDEF NOFORMS}
  if (FThreadID = MainThreadID) and (not Assigned(WakeMainThread)) then
    HookWakeMainThread;
{$ENDIF}

  inherited AfterConstruction;

  GlobalSync.BeginWrite;
  try
    GLMessagePumps.Add(Self);
  finally
    GlobalSync.EndWrite
  end;  
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.BeforeDestruction;
begin
  if FRefCnt > 1 then
    Exit;

  if FHookedWakeMainThread then begin
      UnhookWakeMainThread;
  end;

  FTerminated := TRUE; // No new sync messages and CheckForSyncMessages will return just false, not processing anything

  CheckForSyncMessages; // Release waiting threads, just returns -1, releases the global read lock

  GlobalSync.BeginWrite;
  try  
    GLWindowTree.RemoveAndFreeAll(FThreadID); // no new Send/PostMessage
    GLMessagePumps.Remove(Self); { Remove ourself from the pump list }
  finally
    GlobalSync.EndWrite;
  end;

  { Release RunLoop stuff }
  CFRunLoopRemoveObserver(FRunLoopRef, FEnterExitObserverRef, kCFRunLoopCommonModes);
  CFRelease(FEnterExitObserverRef);
  //CFRunLoopRemoveObserver(FRunLoopRef, FPreSourceObserverRef, kCFRunLoopCommonModes);
  //CFRelease(FPreSourceObserverRef);
  CFRunLoopRemoveObserver(FRunLoopRef, FPreWaitObserverRef, kCFRunLoopCommonModes);
  CFRelease(FPreWaitObserverRef);
  CFRunLoopRemoveSource(FRunLoopRef, FIdleWorkSourceRef, kCFRunLoopCommonModes);
  CFRelease(FIdleWorkSourceRef);
  CFRunLoopRemoveSource(FRunLoopRef, FWorkSourceRef, kCFRunLoopCommonModes);
  CFRelease(FWorkSourceRef);
      
  { Clear the message queue }
  FMessageQueue.Free;
  { Clear all handles }
  FHandles.Free; // removes timer refs from runloop

  CFRelease(FRunLoopRef); // retained, so release

  FCurrentMessagePump := nil;

  FreeAndNil(FSyncLock);

  inherited BeforeDestruction;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TriggerMessage(
  ahWnd   : HWND;
  auMsg   : UINT;
  awParam : WPARAM;
  alParam : LPARAM): LRESULT;
var
  Handled: Boolean;
  MsgRec : TMessage;
begin
  Result := 0;
  if auMsg = WM_QUIT then begin
    FTerminated := True;
    CFRunLoopStop(FRunLoopRef);
  end;
  Handled := FALSE;
  if Assigned(FOnMessage) then
    Result := FOnMessage(ahWnd, auMsg, awParam, alParam, Handled);
  if not Handled then
  begin
    if (AHwnd <> 0) and Assigned(PIcsWindow(AHWnd)^.FWndProc) then
    begin
      MsgRec.Msg    := auMsg;
      MsgRec.wParam := awParam;
      MsgRec.lParam := alParam;
      PIcsWindow(AHWnd)^.FWndProc(MsgRec);
      Result := MsgRec.Result;
    end;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.Wakeup(Sender: TObject);
begin
  CFRunLoopWakeUp(FRunLoopRef);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.HookWakeMainThread;
begin
  if FThreadID = MainThreadID then
  begin
    WakeMainThread := Wakeup;
    FHookedWakeMainThread := True;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.UnhookWakeMainThread;
begin
  if FThreadID = MainThreadID then
  begin
    WakeMainThread := nil;
    FHookedWakeMainThread := False;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
class function TIcsMessagePump.NewInstance: TObject;
begin
  if FCurrentMessagePump = nil then
    FCurrentMessagePump := TIcsMessagePump(inherited NewInstance);
  Result := FCurrentMessagePump;
  Inc(TIcsMessagePump(Result).FRefCnt);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.FreeInstance;
begin
  Dec(FRefCnt);
  if FRefCnt = 0 then
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
class function TIcsMessagePump.GetInstance: TIcsMessagePump;
begin
  Result := FCurrentMessagePump;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
type
  TSyncProc = record
    SyncRec: TIcsMessagePump.PSynchronizeRecord;
    Signal: TEvent;
  end;
  PSyncProc = ^TSyncProc;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.CheckForSyncMessages(Timeout: Integer = 0): Boolean;
var
  SyncProc: PSyncProc;
  LocalSyncList: TList;
begin
  Assert(FThreadID = GetCurrentThreadID);
  LocalSyncList := nil;
  FSyncLock.Enter;
  try
    Pointer(LocalSyncList) := InterlockedExchangePointer(Pointer(FSyncList),
                                                    Pointer(LocalSyncList));
    try
      Result := (LocalSyncList <> nil) and (LocalSyncList.Count > 0);
      if Result then
      begin
        while LocalSyncList.Count > 0 do
        begin
          SyncProc := LocalSyncList[0];
          LocalSyncList.Delete(0);
          FSyncLock.Release;
          try
            try
              if FTerminated then
                SyncProc.SyncRec.FSyncMessageParams.aResult := -1
              else begin
                SyncProc.SyncRec.FSyncMessageParams.aResult :=
                    TriggerMessage(SyncProc.SyncRec.FSyncMessageParams.aHwnd,
                                   SyncProc.SyncRec.FSyncMessageParams.aMsg,
                                   SyncProc.SyncRec.FSyncMessageParams.aWParam,
                                   SyncProc.SyncRec.FSyncMessageParams.aLParam);
              end;
            except
              //raise;
              SyncProc.SyncRec.FSynchronizeException := AcquireExceptionObject;
            end;
          finally
            FSyncLock.Enter;
          end;
          SyncProc.Signal.SetEvent;
        end;
      end;
    finally
      LocalSyncList.Free;
    end;
  finally
    FSyncLock.Release;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.MsgSynchronize(ASyncRec: PSynchronizeRecord;
  ADestination: TIcsMessagePump);
var
  SyncProc: TSyncProc;
  SyncProcPtr: PSyncProc;
  LReleaseFlag: Boolean;
begin
    SyncProcPtr := @SyncProc;
    if ADestination.FTerminated then begin
      SyncProcPtr.SyncRec.FSyncMessageParams.aResult := -1;
      Exit;
    end;
    SyncProcPtr.Signal := TEvent.Create(nil, True, False, '');
    try
      LReleaseFlag := True;
      ADestination.FSyncLock.Enter;
      try
        if ADestination.FSyncList = nil then
          ADestination.FSyncList := TList.Create;
        SyncProcPtr.SyncRec := ASyncRec;
        ADestination.FSyncList.Add(SyncProcPtr);
        ADestination.Wakeup(nil); // Requires that messages are already processed in destination thread
        ADestination.FSyncLock.Release;
        LReleaseFlag := False;
        //try
          SyncProcPtr.Signal.WaitFor(INFINITE);
          //TMonitor.Wait(SyncProcPtr.Signal, ADestination.FLock, INFINITE);
        //finally
        //  ADestination.FLock.Enter;
        //end;
      finally
        if LReleaseFlag then // ADestination might be freed already
          ADestination.FSyncLock.Release;
      end;
    finally
      SyncProcPtr.Signal.Free;
    end;
    if Assigned(ASyncRec.FSynchronizeException) then
      raise ASyncRec.FSynchronizeException;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.MsgSynchronize(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM; ADestination: TIcsMessagePump);
begin
  FSynchronize.FSynchronizeException      := nil;
  FSynchronize.FSyncMessageParams.aHwnd   := hWnd;
  FSynchronize.FSyncMessageParams.aMsg    := Msg;
  FSynchronize.FSyncMessageParams.aWParam := wParam;
  FSynchronize.FSyncMessageParams.aLParam := lParam;
  FSynchronize.FSyncMessageParams.aResult := 0;
  MsgSynchronize(@FSynchronize, ADestination);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TMessageQueue }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

constructor TIcsMessagePump.TMessageQueue.Create;
begin
  inherited Create;
  FLock := TObject.Create;
  FList := TList.Create;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsMessagePump.TMessageQueue.Destroy;
begin
  Lock;
  try
    Clear;
    FList.Free;
    inherited Destroy;
  finally
    Unlock;
    FLock.Free;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessageQueue.Lock;
begin
  TMonitor.Enter(FLock);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessageQueue.Unlock;
begin
  TMonitor.Exit(FLock);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessageQueue.Clear;
var
  I : Integer;
begin
  Lock;
  try
    for I := 0 to FList.Count -1 do
    begin
      Dispose(PQueueMessage(FList[I]));
    end;
    FList.Clear;
  finally
    Unlock;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessageQueue.GetCount: Integer;
begin
  Result := FList.Count;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessageQueue.Pop: PQueueMessage;
begin
  Lock;
  try
    if (FList.Count > 0) then
    begin
      Result := FList[0];
      FList.Delete(0);
    end
    else
      Result := nil;
  finally
    Unlock;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessageQueue.Push(AWnd: HWND; AMsg: UINT;
  AWParam: WPARAM; ALParam: LPARAM): Boolean;
var
  P: PQueueMessage;
  LCnt: Integer;
begin
  Lock;
  try
    LCnt := FList.Count;
    if LCnt >= MESSAGE_QUEUE_SIZE then
    begin
      SetLastError(ERROR_NOT_ENOUGH_QUOTA);
      Exit(False);
    end
    else if FMessagePump.FTerminated then
    begin
      SetLastError(ERROR_ACCESS_DENIED);
      Exit(False);
    end;
    New(P);
    P^.FWnd     := AWnd;
    P^.FMsg     := AMsg;
    P^.FWParam  := AWParam;
    P^.FLParam  := ALParam;
    FList.Add(P);
    Result := True;
    if LCnt = 0 then
    begin
      CFRunLoopSourceSignal(FMessagePump.FWorkSourceRef);
      CFRunLoopWakeUp(FMessagePump.FRunLoopRef);
    end;
  finally
    Unlock;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessageQueue.PushUnique(AWnd: HWND; AMsg: UINT;
  AWParam: WPARAM; ALParam: LPARAM): Boolean;
{ Currently not used, faster with a tree, ToDo }
var
  I     : Integer;
  P     : PQueueMessage;
  LCnt  : Integer;
begin
  Lock;
  try
    LCnt := FList.Count;
    if LCnt >= MESSAGE_QUEUE_SIZE then
    begin
      SetLastError(ERROR_NOT_ENOUGH_QUOTA);
      Exit(False);
    end;
    for I := 0 to FList.Count -1 do // It's slow !
    begin
      P := PQueueMessage(FList[I]);
      if (P^.FWnd = AWnd) and (P^.FMsg = AMsg) and (P^.FWParam = AWParam) and
         (P^.FLParam = ALParam) then
        Exit(True);
    end;
    New(P);
    P^.FWnd     := AWnd;
    P^.FMsg     := AMsg;
    P^.FWParam  := AWParam;
    P^.FLParam  := ALParam;
    FList.Add(P);
    Result := True;
    if LCnt = 0 then
    begin
      CFRunLoopSourceSignal(FMessagePump.FWorkSourceRef);
      CFRunLoopWakeUp(FMessagePump.FRunLoopRef);
    end;
  finally
    Unlock;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessageQueue.RemoveHwnd(AHwnd: HWND);
{ Perhaps faster with a tree, ToDo }
var
  I : Integer;
  P : PQueueMessage;
  PackFlag : Boolean;
begin
  Lock;
  try
    if AHwnd = 0 then
      Exit;
    PackFlag := False;
    for I := 0 to FList.Count -1 do
    begin
      P := PQueueMessage(FList[I]);
      if P^.FWnd = AHwnd then
      begin
        Dispose(P);
        FList[I] := nil;
        PackFlag := True;
      end;
    end;
    if PackFlag then
      FList.Pack;
  finally
    Unlock;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Functions }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsWindow(AHwnd: HWND): Boolean;
begin
  GlobalSync.BeginRead;
  try
    Result := GLWindowTree.Contains(AHwnd);
  finally
    GlobalSync.EndRead
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AllocateHWND(AMethod: TWndMethod): HWND;
var
  LWnd: PIcsWindow;
  LMsgPump: TIcsMessagePump;
begin
  LMsgPump := TIcsMessagePump.Instance;
  if LMsgPump = nil then
    raise EIcsMessagePump.Create('Cannot create a window without a message pump');
  New(LWnd);
  LWnd^.FThreadID := LMsgPump.ThreadID;
  LWnd^.FMessagePump := LMsgPump;
  LWnd^.FWndProc := AMethod;
  GlobalSync.BeginWrite;
  try
    GLWindowTree.Add(HWND(LWnd));
  finally
    GlobalSync.EndWrite;
  end;
  Result := HWND(LWnd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CreateWindow: HWND;
begin
  Result := AllocateHWND(nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function DestroyWindow(AHWnd: HWND): Boolean;
var
  LMsgPump: TIcsMessagePump;
  LEhWnd: Boolean;
begin
  GlobalSync.BeginWrite;  
  try
    LEhWnd := not GLWindowTree.Remove(AHWnd);
    if (LEhWnd) or
       (PIcsWindow(AHWnd)^.FThreadID <> GetCurrentThreadID) then
    begin
      if LEhWnd then
        SetLastError(ERROR_INVALID_WINDOW_HANDLE)
      else
        SetLastError(ERROR_ACCESS_DENIED);
      Exit(False);
    end;
    LMsgPump := PIcsWindow(AHWnd)^.FMessagePump;  
    { Remove all messages to this window from the queue }
    LMsgPump.FMessageQueue.RemoveHwnd(AHWnd);
    LMsgPump.FHandles.DeallocateAll(AHWnd);
    Dispose(PIcsWindow(AHWnd)); // finally release mem
    Result := True;
  finally
    GlobalSync.EndWrite;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function DeallocateHWND(AHwnd: HWND): Boolean;
begin
  Result := DestroyWindow(AHwnd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT;
var
  LDstPump, LSrcPump: TIcsMessagePump;
  LUnLockFlag: Boolean;
begin
  LUnLockFlag := TRUE;
  GlobalSync.BeginRead;
  try
    if not GLWindowTree.Contains(hWnd) then
    begin
      SetLastError(ERROR_INVALID_WINDOW_HANDLE);
      Exit(-1);
    end;
    LDstPump := PIcsWindow(hWnd)^.FMessagePump;
    if LDstPump.FThreadID = GetCurrentThreadID then
    begin
      GlobalSync.EndRead;
      LUnLockFlag := False;
      Result := LDstPump.TriggerMessage(hWnd, Msg, wParam, lParam);
    end
    else begin
      { In order to avoid a true creation and destruction create one message pump
        in thread context explicitly and free it right before the thread exits
        otherwise SendMessage would be too slow }
      LSrcPump := TIcsMessagePump.Create;
      try
        LSrcPump.MsgSynchronize(hWnd, Msg, wParam, lParam, LDstPump);
        Result := LSrcPump.FSyncMessageRec.aResult;
      finally
        LSrcPump.Free;
      end;
    end;
  finally
    if LUnLockFlag then
      GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): Boolean;
var
  LDstPump: TIcsMessagePump;
begin
  if hWnd = 0 then
    Exit(PostThreadMessage(0, Msg, wParam, lParam));

  GlobalSync.BeginRead;
  try
    { Check for valid HWND }
    if not GLWindowTree.Contains(hWnd) then
    begin
      SetLastError(ERROR_INVALID_WINDOW_HANDLE);
      Exit(False);
    end;
    { Get message pump from HWND }
    LDstPump := PIcsWindow(hWnd)^.FMessagePump;
    Result := LDstPump.FMessageQueue.Push(hWnd, Msg, wParam, lParam);
  finally
    GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function PostUniqueMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): Boolean;
var
  LDstPump: TIcsMessagePump;
begin
  { Slow ! not used currently }
  GlobalSync.BeginRead;
  try
    if not GLWindowTree.Contains(hWnd) then
    begin
      SetLastError(ERROR_INVALID_WINDOW_HANDLE);
      Exit(False);
    end;
    LDstPump := PIcsWindow(hWnd)^.FMessagePump;
    Result := LDstPump.FMessageQueue.PushUnique(hWnd, Msg, wParam, lParam);
  finally
    GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function PostThreadMessage(AThreadID: TThreadID; Msg: UINT; wParam: WPARAM;
  lParam: LPARAM): Boolean;
var
  LDstPump: TIcsMessagePump;
begin
  GlobalSync.BeginRead;
  try
    if (AThreadID = 0) or (AThreadID = GetCurrentThreadID) then
      LDstPump := TIcsMessagePump.Instance
    else
      LDstPump := GLMessagePumps.MessagePumpFromThreadID(AThreadID);
    Result := LDstPump <> nil;
    if not Result then
    begin
      SetLastError(EINVAL);
      Exit;
    end;
    Result := LDstPump.FMessageQueue.Push(0, Msg, wParam, lParam);
  finally
    GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SetTimer(AHwnd: HWND; nIDEvent: NativeUInt; uElapse: UINT;
  lpTimerFunc: Pointer): NativeUInt;
var
  LMsgPump: TIcsMessagePump;
  LRunLoopTimerContext: CFRunLoopTimerContext;
  LRunLoopTimerRef: CFRunLoopTimerRef;
  LFireDate: CFAbsoluteTime;
  LInterval: Double;
  PHandle: TIcsMessagePump.PMessagePumpHandle;
begin
  GlobalSync.BeginRead;
  try
    if not GLWindowTree.Contains(AHwnd) then
    begin
      SetLastError(ERROR_INVALID_WINDOW_HANDLE);
      Exit(0);
    end;
    if (PIcsWindow(AHWnd)^.FThreadID <> GetCurrentThreadID) then
    begin
      SetLastError(ERROR_ACCESS_DENIED);
      Exit(0);
    end;
    LMsgPump := PIcsWindow(AHwnd)^.FMessagePump;
    PHandle:= LMsgPump.FHandles.Add(nil, rfCFRunLoopTimer, AHwnd, nIDEvent, 0);
    if PHandle = nil then
      Exit(0);
    try
      FillChar(LRunLoopTimerContext, SizeOf(LRunLoopTimerContext), 0);
      LRunLoopTimerContext.info := PHandle;
      LInterval := uElapse / 1000;
      LFireDate := CFAbsoluteTimeGetCurrent + LInterval;
      LRunLoopTimerRef := CFRunLoopTimerCreate(nil,                 // allocator
                                               LFireDate,           // fire time
                                               LInterval,           // interval
                                               0,                   // flags
                                               0,                   // priority
                                               RunWorkTimer,
                                               @LRunLoopTimerContext);
      if LRunLoopTimerRef = nil then
      begin
        LMsgPump.FHandles.Deallocate(AHwnd, rfCFRunLoopTimer, nIDEvent);
        Exit(0);
      end;
      PHandle^.CFRef := LRunLoopTimerRef;
      CFRunLoopAddTimer(LMsgPump.FRunLoopRef, LRunLoopTimerRef, kCFRunLoopCommonModes);
    except
      LMsgPump.FHandles.Deallocate(AHwnd, rfCFRunLoopTimer, nIDEvent);
      Exit(0);
    end;
    Result := NativeUInt(LRunLoopTimerRef);
  finally
    GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function KillTimer(AHwnd: HWND; nIDEvent: NativeUInt): Boolean;
var
  LMsgPump: TIcsMessagePump;
begin
  GlobalSync.BeginRead;
  try
    if not GLWindowTree.Contains(AHwnd) then
    begin
      SetLastError(ERROR_INVALID_WINDOW_HANDLE);
      Exit(False);
    end;
    if (PIcsWindow(AHWnd)^.FThreadID <> GetCurrentThreadID) then
    begin
      SetLastError(ERROR_ACCESS_DENIED);
      Exit(False);
    end;
    LMsgPump := PIcsWindow(AHwnd)^.FMessagePump;
    LMsgPump.FHandles.Deallocate(AHwnd, rfCFRunLoopTimer, nIDEvent);
    Result := True;
  finally
    GlobalSync.EndRead;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TIcsMessagePump.TMessagePumpHandleList }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsMessagePump.TMessagePumpHandleList.Create(
  AMessagePump: TIcsMessagePump);
begin
  inherited Create;
  FMessagePump := AMessagePump;
  FList := TList.Create;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessagePumpHandleList.ReleaseRef(P: PMessagePumpHandle);
begin
  case P^.CFRefType of
    rfCFRunLoopTimer:
    begin
      if P^.CFRef <> nil then
      begin
        CFRunLoopRemoveTimer(FMessagePump.FRunLoopRef, P^.CFRef, kCFRunLoopCommonModes);
        CFRelease(P^.CFRef);
      end;
    end;
    {rfCFRunLoopSocket:
    begin
      if P^.UData <> 0 then
      begin
        CFSocketInvalidate(CFSocketRef(P^.UData));
        CFRelease(CFSocketRef(P^.UData));
      end;
      if P^.CFRef <> nil then
      begin
        CFRunLoopRemoveSource(FMessagePump.FRunLoopRef, P^.CFRef, kCFRunLoopCommonModes);
        CFRelease(P^.CFRef);
      end;
    end;}
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessagePumpHandleList.DeallocateAll;
var
  I: Integer;
  P: PMessagePumpHandle;
begin
  for I := 0 to Flist.Count -1 do
  begin
    P := PMessagePumpHandle(FList[I]);
    ReleaseRef(P);
    Dispose(P);
  end;
  FList.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessagePumpHandleList.DeallocateAll(AHwnd: Hwnd);
var
  I: Integer;
  P: PMessagePumpHandle;
begin
  for I := 0 to Flist.Count -1 do
  begin
    P := PMessagePumpHandle(FList[I]);
    if P^.hWindow = AHwnd then
    begin
      ReleaseRef(P);
      Dispose(P);
      FList[I] := nil;
    end;
  end;
  FList.Pack;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsMessagePump.TMessagePumpHandleList.Destroy;
begin
  if Assigned(FList) then
    DeallocateAll;
  FList.Free;
  inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessagePumpHandleList.Get(AHwnd: Hwnd;
  ARefType: TCFRefType; ID: NativeInt): PMessagePumpHandle;
var
  P: PMessagePumpHandle;
  I: Integer;
begin
  for I := 0 to Flist.Count -1 do
  begin
    P := PMessagePumpHandle(FList[I]);
    if (P^.hWindow = AHwnd) and (P^.CFRefType = ARefType) and (P^.ID = ID) then
    begin
      Result := P;
      Exit;
    end;
  end;
  Result := nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsMessagePump.TMessagePumpHandleList.Add(ACFRef: Pointer;
  ARefType: TCFRefType; AHwnd: Hwnd; ID: NativeInt; UData: NativeInt): PMessagePumpHandle;
var
  P: PMessagePumpHandle;
  I: Integer;
begin
  { slow ! }
  for I := 0 to Flist.Count -1 do
  begin
    P := PMessagePumpHandle(FList[I]);
    if (P^.hWindow = AHwnd) and (P^.CFRefType = ARefType) and (P^.ID = ID) then
    begin
      Result := nil;
      Exit;
    end;
  end;
  New(P);
  P^.MessagePump := FMessagePump;
  P^.CFRef      := ACFRef;
  P^.hWindow    := AHwnd;
  P^.ID         := ID;
  P^.UData      := UData;
  P^.CFRefType  := ARefType;
  FList.Add(P);
  Result := P;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsMessagePump.TMessagePumpHandleList.Deallocate(AHwnd: Hwnd;
  ARefType: TCFRefType; ID: NativeInt);
var
  I: Integer;
  P: PMessagePumpHandle;
begin
  for I := 0 to Flist.Count -1 do
  begin
    P := PMessagePumpHandle(FList[I]);
    if (P^.hWindow = AHwnd) and (P^.CFRefType = ARefType) and (P^.ID = ID) then
    begin
      ReleaseRef(P);
      Dispose(P);
      FList.Delete(I);
      Exit;
    end;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF POSIX}
{ TMultiReadExclusiveWriteSynchronizer }

{ This is the Delphi class except that Windows events are replaced by TEvent. }
{ EMBT did not port it to POSIX yet it still maps to TSimpleRWSync in the RTL }
{ to be removed when EMBT provides a similar class for POSIX in the RTL.      }

const
  mrWriteRequest = $FFFF; // 65535 concurrent read requests (threads)
                          // 32768 concurrent write requests (threads)
                          // only one write lock at a time
                          // 2^32 lock recursions per thread (read and write combined)

constructor TMultiReadExclusiveWriteSynchronizer.Create;
begin
  inherited Create;
  FSentinel := mrWriteRequest;
  FReadSignal := TEvent.Create(nil, True, True, '');  // manual reset, start signaled
  FWriteSignal := TEvent.Create(nil, False, False, ''); // auto reset, start blocked
  FWaitRecycle := INFINITE;
  tls := TThreadLocalCounter.Create;
end;

destructor TMultiReadExclusiveWriteSynchronizer.Destroy;
begin
  BeginWrite;
  inherited Destroy;
  FReadSignal.Free;
  FWriteSignal.Free;
  tls.Free;
end;

procedure TMultiReadExclusiveWriteSynchronizer.BlockReaders;
begin
  FReadSignal.ResetEvent;
end;

procedure TMultiReadExclusiveWriteSynchronizer.UnblockReaders;
begin
  FReadSignal.SetEvent;
end;

procedure TMultiReadExclusiveWriteSynchronizer.UnblockOneWriter;
begin
  FWriteSignal.SetEvent;
end;

procedure TMultiReadExclusiveWriteSynchronizer.WaitForReadSignal;
begin
  FReadSignal.WaitFor(FWaitRecycle);
end;

procedure TMultiReadExclusiveWriteSynchronizer.WaitForWriteSignal;
begin
  FWriteSignal.WaitFor(FWaitRecycle);
end;

{$IFDEF DEBUG_MREWS}
var
  x: Integer;

procedure TMultiReadExclusiveWriteSynchronizer.Debug(const Msg: string);
begin
  OutputDebugString(PChar(Format('%d %s Thread=%x Sentinel=%d, FWriterID=%x',
    [InterlockedIncrement(x), Msg, GetCurrentThreadID, FSentinel, FWriterID])));
end;
{$ENDIF DEBUG_MREWS}

function TMultiReadExclusiveWriteSynchronizer.BeginWrite: Boolean;
var
  Thread: PThreadInfo;
  HasReadLock: Boolean;
  ThreadID: Cardinal;
  Test: Integer;
  OldRevisionLevel: Cardinal;
begin
  {
    States of FSentinel (roughly - during inc/dec's, the states may not be exactly what is said here):
    mrWriteRequest:         A reader or a writer can get the lock
    1 - (mrWriteRequest-1): A reader (possibly more than one) has the lock
    0:                      A writer (possibly) just got the lock, if returned from the main write While loop
    < 0, but not a multiple of mrWriteRequest: Writer(s) want the lock, but reader(s) have it.
          New readers should be blocked, but current readers should be able to call BeginRead
    < 0, but a multiple of mrWriteRequest: Writer(s) waiting for a writer to finish
  }


{$IFDEF DEBUG_MREWS}
  Debug('Write enter------------------------------------');
{$ENDIF DEBUG_MREWS}
  Result := True;
  ThreadID := GetCurrentThreadID;
  if FWriterID <> ThreadID then  // somebody or nobody has a write lock
  begin
    // Prevent new readers from entering while we wait for the existing readers
    // to exit.
    BlockReaders;

    OldRevisionLevel := FRevisionLevel;

    tls.Open(Thread);
    // We have another lock already. It must be a read lock, because if it
    // were a write lock, FWriterID would be our threadid.
    HasReadLock := Thread.RecursionCount > 0;

    if HasReadLock then    // acquiring a write lock requires releasing read locks
      InterlockedIncrement(FSentinel);

{$IFDEF DEBUG_MREWS}
    Debug('Write before loop');
{$ENDIF DEBUG_MREWS}
    // InterlockedExchangeAdd returns prev value
    while InterlockedExchangeAdd(FSentinel, -mrWriteRequest) <> mrWriteRequest do
    begin
{$IFDEF DEBUG_MREWS}
      Debug('Write loop');
      Sleep(1000); // sleep to force / debug race condition
      Debug('Write loop2a');
{$ENDIF DEBUG_MREWS}

      // Undo what we did, since we didn't get the lock
      Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest);
      // If the old value (in Test) was 0, then we may be able to
      // get the lock (because it will now be mrWriteRequest). So,
      // we continue the loop to find out. Otherwise, we go to sleep,
      // waiting for a reader or writer to signal us.

      if Test <> 0 then
      begin
        {$IFDEF DEBUG_MREWS}
        Debug('Write starting to wait');
        {$ENDIF DEBUG_MREWS}
        WaitForWriteSignal;
      end
      {$IFDEF DEBUG_MREWS}
      else
        Debug('Write continue')
      {$ENDIF DEBUG_MREWS}
    end;

    // At the EndWrite, first Writers are awoken, and then Readers are awoken.
    // If a Writer got the lock, we don't want the readers to do busy
    // waiting. This Block resets the event in case the situation happened.
    BlockReaders;

    // Put our read lock marker back before we lose track of it
    if HasReadLock then
      InterlockedDecrement(FSentinel);

    FWriterID := ThreadID;

    Result := Integer(OldRevisionLevel) = (InterlockedIncrement(Integer(FRevisionLevel)) - 1);
  end;

  Inc(FWriteRecursionCount);
{$IFDEF DEBUG_MREWS}
  Debug('Write lock-----------------------------------');
{$ENDIF DEBUG_MREWS}
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndWrite;
var
  Thread: PThreadInfo;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Write end');
{$ENDIF DEBUG_MREWS}
  assert(FWriterID = GetCurrentThreadID);
  tls.Open(Thread);
  Dec(FWriteRecursionCount);
  if FWriteRecursionCount = 0 then
  begin
    FWriterID := 0;
    InterlockedExchangeAdd(FSentinel, mrWriteRequest);
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockOneWriter');
    {$ENDIF DEBUG_MREWS}
    UnblockOneWriter;
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockReaders');
    {$ENDIF DEBUG_MREWS}
    UnblockReaders;
  end;
  if Thread.RecursionCount = 0 then
    tls.Delete(Thread);
{$IFDEF DEBUG_MREWS}
  Debug('Write unlock');
{$ENDIF DEBUG_MREWS}
end;

procedure TMultiReadExclusiveWriteSynchronizer.BeginRead;
var
  Thread: PThreadInfo;
  WasRecursive: Boolean;
  SentValue: Integer;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Read enter');
{$ENDIF DEBUG_MREWS}

  tls.Open(Thread);
  Inc(Thread.RecursionCount);
  WasRecursive := Thread.RecursionCount > 1;

  if FWriterID <> GetCurrentThreadID then
  begin
{$IFDEF DEBUG_MREWS}
    Debug('Trying to get the ReadLock (we did not have a write lock)');
{$ENDIF DEBUG_MREWS}
    // In order to prevent recursive Reads from causing deadlock,
    // we need to always WaitForReadSignal if not recursive.
    // This prevents unnecessarily decrementing the FSentinel, and
    // then immediately incrementing it again.
    if not WasRecursive then
    begin
      // Make sure we don't starve writers. A writer will
      // always set the read signal when it is done, and it is initially on.
      WaitForReadSignal;
      while (InterlockedDecrement(FSentinel) <= 0) do
      begin
  {$IFDEF DEBUG_MREWS}
        Debug('Read loop');
  {$ENDIF DEBUG_MREWS}
        // Because the InterlockedDecrement happened, it is possible that
        // other threads "think" we have the read lock,
        // even though we really don't. If we are the last reader to do this,
        // then SentValue will become mrWriteRequest
        SentValue := InterlockedIncrement(FSentinel);
        // So, if we did inc it to mrWriteRequest at this point,
        // we need to signal the writer.
        if SentValue = mrWriteRequest then
          UnblockOneWriter;

        // This sleep below prevents starvation of writers
        Sleep(0);

  {$IFDEF DEBUG_MREWS}
        Debug('Read loop2 - waiting to be signaled');
  {$ENDIF DEBUG_MREWS}
        WaitForReadSignal;
  {$IFDEF DEBUG_MREWS}
        Debug('Read signaled');
  {$ENDIF DEBUG_MREWS}
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read lock');
{$ENDIF DEBUG_MREWS}
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndRead;
var
  Thread: PThreadInfo;
  Test: Integer;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Read end');
{$ENDIF DEBUG_MREWS}
  tls.Open(Thread);
  Dec(Thread.RecursionCount);
  if (Thread.RecursionCount = 0) then
  begin
     tls.Delete(Thread);

    // original code below commented out
    if (FWriterID <> GetCurrentThreadID) then
    begin
      Test := InterlockedIncrement(FSentinel);
      // It is possible for Test to be mrWriteRequest
      // or, it can be = 0, if the write loops:
      // Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest) + mrWriteRequest;
      // Did not get executed before this has called (the sleep debug makes it happen faster)
      {$IFDEF DEBUG_MREWS}
      Debug(Format('Read UnblockOneWriter may be called. Test=%d', [Test]));
      {$ENDIF}
      if Test = mrWriteRequest then
        UnblockOneWriter
      else if Test <= 0 then // We may have some writers waiting
      begin
        if (Test mod mrWriteRequest) = 0 then
          UnblockOneWriter; // No more readers left (only writers) so signal one of them
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read unlock');
{$ENDIF DEBUG_MREWS}
end;
{$ENDIF POSIX TMultiReadExclusiveWriteSynchronizer}

initialization
  GLMessagePumps := TMessagePumpList.Create;
  GLWindowTree := TGlobalWindowTree.Create;
  GlobalSync := TMREWSync.Create;
  
finalization
  FreeAndNil(GLWindowTree);
  FreeAndNil(GLMessagePumps);
  FreeAndNil(GlobalSync);

end.
