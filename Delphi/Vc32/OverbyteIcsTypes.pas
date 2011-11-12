{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:
Creation:     April 2004
Version:      1.07
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2004-2011 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Apr 10, 2009 Arno changed TBytes to an alias of SysUtils.TBytes in D2007 and
             better. Added alias EAbort.
Dec 03, 2009 Arno added some of the polymorphic integer types from
             Windows.pas/BaseTsd.h.
May 07, 2010 Arno added a few declarations.
Apr 15, 2011 Arno prepared for 64-bit.
May 06, 2011 Arno added TThreadID 

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsTypes;

interface

{$I OverbyteIcsDefs.inc}

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Classes, SysUtils;

const
  OverbyteIcsTypesVersion = 107;
  CopyRight : String      = ' OverbyteIcsTypes (c) 2004-2011 F. Piette V1.07 ';

type
{$IFDEF COMPILER11_UP} // D2007 and better
  TBytes                    = SysUtils.TBytes;
{$ELSE} // D7 - D2006
  TBytes                    = array of Byte;
{$ENDIF}

{$IFNDEF COMPILER15_UP}
  TThreadID                 = LongWord;
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$EXTERNALSYM size_t}
  {$IFDEF CPUX64}
    size_t                    = UInt64;
  {$ELSE}
    size_t                    = LongWord;
  {$ENDIF}
    Psize_t                   = ^size_t;

  {$IFDEF COMPILER14_UP} // D2010 and better
      {$EXTERNALSYM HANDLE_PTR}
      HANDLE_PTR                = Windows.HANDLE_PTR;
  {$ELSE} // D7 - D2009
      {$EXTERNALSYM HANDLE_PTR}
      HANDLE_PTR                = type LongWord;
  {$ENDIF}

  {$IFDEF COMPILER11_UP} // D2007 and better
      {$EXTERNALSYM INT_PTR}
      INT_PTR                   = Windows.INT_PTR;
      {$EXTERNALSYM LONG_PTR}
      LONG_PTR                  = Windows.LONG_PTR;
      {$EXTERNALSYM UINT_PTR}
      UINT_PTR                  = Windows.UINT_PTR;
      {$EXTERNALSYM ULONG_PTR}
      ULONG_PTR                 = Windows.ULONG_PTR;
      {$EXTERNALSYM DWORD_PTR}
      DWORD_PTR                 = Windows.DWORD_PTR;
  {$ELSE} // D7 - D2006
      // From BaseTsd.h
      {$EXTERNALSYM INT_PTR}
      INT_PTR                   = Integer;
      {$EXTERNALSYM LONG_PTR}
      LONG_PTR                  = Longint;
      {$EXTERNALSYM UINT_PTR}
      UINT_PTR                  = Cardinal;
      {$EXTERNALSYM ULONG_PTR}
      ULONG_PTR                 = LongWord;
      {$EXTERNALSYM DWORD_PTR}
      DWORD_PTR                 = ULONG_PTR;
  {$ENDIF}
  {$EXTERNALSYM PINT_PTR}
  PINT_PTR                  = ^INT_PTR;
  {$EXTERNALSYM PUINT_PTR}
  PUINT_PTR                 = ^UINT_PTR;
{$ENDIF MSWINDOWS}

  {$EXTERNALSYM Exception}
  Exception                 = SysUtils.Exception;
  {$EXTERNALSYM ExceptClass}
  ExceptClass               = SysUtils.ExceptClass;
  {$EXTERNALSYM EAbort}
  EAbort                    = SysUtils.EAbort;
  {$EXTERNALSYM TSearchRec}
  TSearchRec                = SysUtils.TSearchRec;
  {$EXTERNALSYM TReplaceFlags}
  TReplaceFlags             = SysUtils.TReplaceFlags;
  {$EXTERNALSYM TComponent}
  TComponent                = Classes.TComponent;
  {$EXTERNALSYM TPersistent}
  TPersistent               = Classes.TPersistent;
  {$EXTERNALSYM TNotifyEvent}
  TNotifyEvent              = Classes.TNotifyEvent;
  {$EXTERNALSYM TList}
  TList                     = Classes.TList;
  {$EXTERNALSYM TStrings}
  TStrings                  = Classes.TStrings;
  {$EXTERNALSYM TStringList}
  TStringList               = Classes.TStringList;
  {$EXTERNALSYM TThread}
  TThread                   = Classes.TThread;
  {$EXTERNALSYM TOperation}
  TOperation                = Classes.TOperation;
  {$EXTERNALSYM TListNotification}
  TListNotification         = Classes.TListNotification;

{$IFDEF MSWINDOWS}
  {$EXTERNALSYM TMessage}
  TMessage                  = Messages.TMessage;
  {$EXTERNALSYM TTimeZoneInformation}
  TTimeZoneInformation      = Windows.TTimeZoneInformation;
  {$EXTERNALSYM HWND}
  HWND                      = Windows.HWND;
  {$EXTERNALSYM DWORD}
  DWORD                     = Windows.DWORD;
  {$EXTERNALSYM UINT}
  UINT                      = Windows.UINT;
  {$EXTERNALSYM TRTLCriticalSection}
  TRTLCriticalSection       = Windows.TRTLCriticalSection;
  {$EXTERNALSYM TWndClass}
  TWndClass                 = Windows.TWndClass;
  {$EXTERNALSYM TMsg}
  TMsg                      = Windows.TMsg;
  {$EXTERNALSYM WPARAM}
  WPARAM                    = Windows.WPARAM;
  {$EXTERNALSYM LPARAM}
  LPARAM                    = Windows.LPARAM;
  {$EXTERNALSYM POverlapped}
  POverlapped               = Windows.POverlapped;
  {$EXTERNALSYM FARPROC}
  FARPROC                   = Windows.FARPROC;
  {$EXTERNALSYM LRESULT}
  LRESULT                   = Windows.LRESULT;
  {$EXTERNALSYM short}
  Short                     = Windows.Short;
  {$EXTERNALSYM TSystemInfo}
  TSystemInfo               = Windows.TSystemInfo;
{$ENDIF}

  LOWORD = Word;

implementation

end.
