{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels <arno.garrels@gmx.de>
Description:  Headers for iconv library (LGPL) 
Creation:     Apr 25, 2010
Version:      1.00
EMail:        http://www.overbyte.be       francois.piette@overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
              
History:

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsIconv;

interface

uses
    Windows;

const
  {$IFDEF MSWINDOWS}
      libiconv        = 'iconv.dll';
      libmsvcrt       = 'msvcrt.dll';
      E2BIG           =  7;
      EINVAL          = 22;
      EILSEQ          = 42;
  {$ELSE}
  {$ENDIF}

type
    cint      = LongInt;
    pcint     = ^cint;
    iconv_t   = Pointer;
    piconv_t  = ^iconv_t;
    size_t    = LongWord;
    psize_t   = ^size_t;

{$IFNDEF BCB}
    function Errno: cint; overload;
    procedure Errno(Err: cint); overload;
{$ENDIF}
    function iconv(cd: iconv_t; InBuf: PPAnsiChar; InBytesLeft: psize_t;
      OutBuf: PPAnsiChar; OutBytesLeft: psize_t): size_t;
    function iconv_open(ToCode: PAnsiChar; FromCode: PAnsiChar): iconv_t;
    function iconv_close(cd: iconv_t): Integer;
    function Load_Iconv: Boolean;

implementation

type
    TIconv = function(cd: iconv_t; InBuf: PPAnsiChar; InBytesLeft: psize_t;
       OutBuf: PPAnsiChar; OutBytesLeft: psize_t): size_t; cdecl;
    TIconvOpen = function(ToCode: PAnsiChar; FromCode: PAnsiChar): iconv_t; cdecl;
    TIconvClose = function(cd: iconv_t): Integer; cdecl;

var
    hIconvLib       : HMODULE = 0;
    fptrIconv       : TIconv = nil;
    fptrIconvOpen   : TIconvOpen = nil;
    fptrIconvClose  : TIconvClose = nil;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF BCB}
function GetErrnoLocation: pcint; cdecl; external libmsvcrt name '_errno';


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Errno: cint;
begin
    Result := GetErrnoLocation^;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Errno(Err: cint);
begin
    GetErrnoLocation^ := Err;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function iconv(cd: iconv_t; InBuf: PPAnsiChar; InBytesLeft: psize_t;
  OutBuf: PPAnsiChar; OutBytesLeft: psize_t): size_t;
begin
    Result := fptrIconv(cd, InBuf, InBytesLeft, OutBuf, OutBytesLeft);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function iconv_open(ToCode: PAnsiChar; FromCode: PAnsiChar): iconv_t;
begin
    Result := fptrIconvOpen(ToCode, FromCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function iconv_close(cd: iconv_t): Integer;
begin
    Result := fptrIconvClose(cd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Load_Iconv: Boolean;
begin
    if Assigned(fptrIconv) then
        Result := TRUE
    else begin
        Result := FALSE;
        hIconvLib := LoadLibrary(libiconv);
        if hIconvLib = 0 then
            hIconvLib := LoadLibrary('lib' + libiconv);
        if hIconvLib <> 0 then
        begin
            fptrIconv      := GetProcAddress(hIconvLib, 'libiconv');
            fptrIconvOpen  := GetProcAddress(hIconvLib, 'libiconv_open');
            fptrIconvClose := GetProcAddress(hIconvLib, 'libiconv_close');
            Result := Assigned(fptrIconv) and Assigned(fptrIconvOpen) and
                      Assigned(fptrIconvClose);
            if not Result then
                fptrIconv  := nil;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.
