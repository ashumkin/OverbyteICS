{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels <arno.garrels@gmx.de>
Description:  A place for common utilities.
Creation:     Apr 25, 2008
Version:      7.33
EMail:        http://www.overbyte.be       francois.piette@overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2002-2008 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
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
                 to Francois PIETTE. Use a nice stamp and mention your name,
                 street address, EMail address and any comment you like to say.

History:
Apr 25, 2008 V1.00 AGarrels added first functions UnicodeToAscii, UnicodeToAnsi,
             AnsiToUnicode and IsUsAscii .
May 01, 2008 V1.01 AGarrels added StreamWriteString.
May 02, 2008 V1.02 AGarrels a few optimizations and a bugfix in StreamWriteString.
May 11, 2008 V1.03 USchuster added atoi implementations (moved from several units)
May 15, 2008 V1.04 AGarrels fix in IcsAppendStr made StreamWriteString a function.
May 19, 2008 V1.05 AGarrels added BOM-support to StreamWriteString plus two
             overloads. Made UnicodeString a type alias of WideString in compiler
             versions < COMPILER12 in order to enable use of some conversion
             routines for older compilers as well.
May 19, 2008 V1.06 Don't check actual string codepage but assume UTF-16 Le
             in function StreamWriteString() (temp fix).
Jul 14, 2008 V1.07 atoi improved, should be around 3 times faster.
Jul 17, 2008 V1.08 Added OverbyteIcsTypes to the uses clause and removed
             SysUtils, removed some defines for unsupported old compilers.
             StreamWriteString should work with WideStrings as well with old
             compilers.
Jul 20, 2008 V1.09 Added Utf-8 string functions.
Jul 29, 2008 V1.10 Added parameter "SetCodePage" to UnicodeToAnsi(), defaults
             to "False". Utf-8 functions adjusted accordingly. Does effect
             compiler post RDS2007 only.
Jun 05, 2008 Utf-8 functions modified to take and return AnsiString rather than
             UTF8String.
Aug 11, 2008 CheckUnicodeToAnsi() added. Changed the DefaultFailChar to "?".
Aug 23, 2008 Utf-8 functions modified RawByteString rather than AnsiString.
Aug 27, 2008 Arno Garrels added WideString functions and other stuff.
Sep 11, 2008 Angus added more widestring functions
             No range checking so they all work (IcsFileGetAttrW in particular)
Sep 20, 2008 V1.16 Angus still adding WideString functions
Sep 21, 2008 V1.17 Link RtlCompareUnicodeString() dynamically at run-time
Sep 27, 2008 V1.18 Arno fixed a bug in StringToUtf8.
Sep 28, 2008 V1.19 A. Garrels Moved IsDigit, IsXDigit, XDigit, htoi2 and htoin
             from OverbyteIcsUrl and added overloads. Fixed a bug in
             ConvertCodepage().
Oct 03, 2008 V1.20 A. Garrels moved some double helper functions to this unit.
             Added symbol USE_INLINE that enables inlining.
Oct 23, 2008 V7.21 A. Garrels added IcsStrNextChar, IcsStrPrevChar and
             IcsStrCharLength, see description below. Useful when converting
             a ANSI character stream with known code page to Unicode in
             chunks. Added a PAnsiChar overload to function AnsiToUnicode.
Nov 13, 2008 v7.22 Arno added CharsetDetect, IsUtf8Valid use CharsetDetect.
Dec 05, 2008 v7.23 Arno added function IcsCalcTickDiff.
Apr 18, 2009 V7.24 Arno added a PWideChar overload to UnicodeToAnsi().
May 02, 2009 V7.25 Arno added IcsNextCharIndex().
May 03, 2009 V7.26 Arno added IsUtf8TrailByte and IsLeadChar.
May 14, 2009 V7.27 Arno changed IcsNextCharIndex() to avoid a compiler
             warning in C++ Builder (assertion moved one line up).
             Removed uneccessary overload directives from IcsCharNextUtf8
             and IcsCharPrevUtf8.
May 17, 2009 V7.28 Arno prefixed argument names of various UTF-8 overloads
             by "Utf8" so that C++Builder user know that UTF-8 encoded
             AnsiStrings are expected.
June 4, 2009 V7.29 Angus added IcsExtractLastDir
Jun 22, 2009 V7.30 Angus avoid D2009 error with IcsExtractLastDir
Sep 24, 2009 V7.31 Arno added TIcsIntegerList and IcsBufferToHex.
             Small fix in ConvertCodepage(). Added check for nil in
             IcsCharNextUtf8(). Added global consts CP_UTF16, CP_UTF16Be,
             CP_UTF32 and CP_UTF32Be. New functions IcsBufferToUnicode,
             IcsGetWideCharCount and IcsGetWideChars see comments in interface
             section. Added fast functions to swap byte order: IcsSwap16,
             IcsSwap16Buf, IcsSwap32, IcsSwap32Buf and IcsSwap64Buf.
Dec 15, 2009 V7.32 Arno added typedef PInt64 for CB 2006 and CB2007.
Mar 06, 2010 V7.33 Arno fixed IcsGetWideCharCount, MultiByteToWideChar() does
             not support flag "MB_ERR_INVALID_CHARS" with all code pages.
             Fixed some ugly bugs in UTF-8 helper functions too. Added
             IsUtf8LeadByte() and IcsUtf8Size().


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsUtils;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$H+}           { Use long strings                    }
{$J+}           { Allow typed constant to be modified }
{$R-}           { no range checking, otherwise DWORD=Integer fails with some Windows APIs }
{$I OverbyteIcsDefs.inc}
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}
{$IFDEF COMPILER12_UP}
    {$WARN IMPLICIT_STRING_CAST       OFF}
    {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
    {$WARN EXPLICIT_STRING_CAST       OFF}
    {$WARN EXPLICIT_STRING_CAST_LOSS  OFF}
{$ENDIF}
{$IFDEF DELPHI6_UP}
    {$WARN SYMBOL_PLATFORM   OFF}
    {$WARN SYMBOL_LIBRARY    OFF}
    {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
{$IFDEF BCB3_UP}
    {$ObjExportAll On}
{$ENDIF}

uses
    Windows,
    Classes,
    SysUtils,
    RtlConsts,
    SysConst,
    OverbyteIcsTypes; // for TBytes

type
{$IFNDEF COMPILER12_UP}
   { Should move to OverbyteIcsTypes.pas }
    UnicodeString = WideString;
    RawByteString = AnsiString;

  (*$HPPEMIT 'namespace System' *)
  (*$HPPEMIT '{' *)
  (*$HPPEMIT '  typedef __int64* PInt64;' *)
  (*$HPPEMIT '}' *)

{$ENDIF}

    EIcsStringConvertError = class(Exception);
    TCharsetDetectResult = (cdrAscii, cdrUtf8, cdrUnknown);

    TIcsSearchRecW = record
        Time        : Integer;
        Size        : Integer;
        Attr        : Integer;
        Name        : UnicodeString;
        ExcludeAttr : Integer;
        FindHandle  : THandle;
        FindData    : TWin32FindDataW;
    end;

    TUnicode_String = record
        Length        : Word;
        MaximumLength : Word;
        Buffer        : PWideChar;
    end;
    PUnicode_String = ^TUnicode_String;

    TRtlCompareUnicodeString = function(String1, String2: PUnicode_String; CaseInSensitive: Boolean): LongInt; stdcall;

    TIcsFileStreamW = class(THandleStream)
    private
        FFileName: UnicodeString;
    public
        constructor Create(const FileName: UnicodeString; Mode: Word); overload;
        constructor Create(const FileName: UnicodeString; Mode: Word; Rights: Cardinal); overload;
        constructor Create(const Utf8FileName: UTF8String; Mode: Word); overload;
        constructor Create(const Utf8FileName: UTF8String; Mode: Word; Rights: Cardinal); overload;
        destructor  Destroy; override;
        property    FileName: UnicodeString read FFileName;
    end;

    function  UnicodeToUsAscii(const Str: UnicodeString; FailCh: AnsiChar): AnsiString; overload;
    function  UnicodeToUsAscii(const Str: UnicodeString): AnsiString; overload;
    function  UsAsciiToUnicode(const Str: RawByteString; FailCh: AnsiChar): UnicodeString; overload;
    function  UsAsciiToUnicode(const Str: RawByteString): UnicodeString; overload;
    function  UnicodeToAnsi(const Str: PWideChar; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString; overload;
    function  UnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString; overload;
    function  UnicodeToAnsi(const Str: UnicodeString): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  AnsiToUnicode(const Str: PAnsiChar; ACodePage: LongWord): UnicodeString; overload;
    function  AnsiToUnicode(const Str: RawByteString; ACodePage: LongWord): UnicodeString; overload;
    function  AnsiToUnicode(const Str: RawByteString): UnicodeString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    { Returns a UnicodeString and the number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsBufferToUnicode(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; out FailedByteCount: Integer): UnicodeString; overload;
    { Returns a UnicodeString and optionally raises an exception if there are any number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsBufferToUnicode(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; RaiseFailedBytes: Boolean = FALSE): UnicodeString; overload;
    { Returns the number of WideChars, and the number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsGetWideCharCount(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; out InvalidEndByteCount: Integer): Integer;
    { Returns a Unicode string, ByteCount and CharCount must match, no length checks are done }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsGetWideChars(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; Chars: PWideChar; CharCount: Integer): Integer;
    function  StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer; ACodePage: LongWord; WriteBOM: Boolean): Integer; overload;
    function  StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer; ACodePage: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString; ACodePage: LongWord; WriteBOM: Boolean): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString; ACodePage: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsUsAscii(const Str: RawByteString): Boolean; overload;
    function  IsUsAscii(const Str: UnicodeString): Boolean; overload;
    procedure IcsAppendStr(var Dest: RawByteString; const Src: RawByteString);
    function  atoi(const Str: RawByteString): Integer; overload;
    function  atoi(const Str: UnicodeString): Integer; overload;
{$IFDEF STREAM64}
    function  atoi64(const Str: RawByteString): Int64; overload;
    function  atoi64(const Str: UnicodeString): Int64; overload;
{$ENDIF}
    function  IcsCalcTickDiff(const StartTick, EndTick: LongWord): LongWord; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  StringToUtf8(const Str: UnicodeString): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StringToUtf8(const Str: RawByteString; ACodePage: LongWord = CP_ACP): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  Utf8ToStringW(const Str: RawByteString): UnicodeString; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  Utf8ToStringA(const Str: RawByteString; ACodePage: LongWord = CP_ACP): AnsiString; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  CheckUnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord = CP_ACP): Boolean;
    { This is a weak check, it does not detect whether it's a valid UTF-8 byte }  
    function  IsUtf8TrailByte(const B: Byte): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IsUtf8LeadByte(const B: Byte): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsUtf8Size(const LeadByte: Byte): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF}
{$IFNDEF COMPILER12_UP}
    function  IsLeadChar(Ch: WideChar): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
{$ENDIF}
    function  IsUtf8Valid(const Str: RawByteString): Boolean; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IsUtf8Valid(const Buf: Pointer; Len: Integer): Boolean; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  CharsetDetect(const Buf: Pointer; Len: Integer): TCharsetDetectResult; overload;
    function  CharsetDetect(const Str: RawByteString): TCharsetDetectResult; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsCharNextUtf8(const Str: PAnsiChar): PAnsiChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsCharPrevUtf8(const Start, Current: PAnsiChar): PAnsiChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  ConvertCodepage(const Str: RawByteString; SrcCodePage: LongWord; DstCodePage: LongWord = CP_ACP): RawByteString;
    function  htoin(Value : PWideChar; Len : Integer) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  htoin(Value : PAnsiChar; Len : Integer) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  htoi2(value : PWideChar): Integer; overload;
    function  htoi2(value : PAnsiChar): Integer; overload;
    function  IcsBufferToHex(const Buf; Size: Integer): String; overload;
    function  IcsBufferToHex(const Buf; Size: Integer; Separator: Char): String; overload;
    function  IsXDigit(Ch : WideChar): Boolean; overload;
    function  IsXDigit(Ch : AnsiChar): Boolean; overload;
    function  XDigit(Ch : WideChar): Integer; overload;
    function  XDigit(Ch : AnsiChar): Integer; overload;
    function  IsCharInSysCharSet(Ch : WideChar; const ASet : TSysCharSet) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCharInSysCharSet(Ch : AnsiChar; const ASet : TSysCharSet) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsDigit(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsDigit(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpace(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpace(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCRLF(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCRLF(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpaceOrCRLF(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpaceOrCRLF(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  XDigit2(S : PChar) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  stpblk(PValue : PWideChar) : PWideChar; overload;
    function  stpblk(PValue : PAnsiChar) : PAnsiChar; overload;
    { Retrieves the pointer to the next character in a string. This function }
    { can handle strings consisting of either single- or multi-byte          }
    { characters. including UTF-8. The return value is a pointer to the next }
    { character in the string, or to the terminating null character if at    }
    { the end of the string.                                                 }
    function  IcsStrNextChar(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
    { Retrieves the pointer to the preceding character in a string. This     }
    { function can handle strings consisting of either single- or multi-byte }
    { characters including UTF-8. The return value is a pointer to the       }
    { preceding character in the string, or to the first character in the    }
    { string if the Current parameter equals the Start parameter.            }
    function  IcsStrPrevChar(const Start, Current: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
    function  IcsStrCharLength(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IcsNextCharIndex(const S: RawByteString; Index: Integer; ACodePage: LongWord = CP_ACP): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IcsGetBomBytes(ACodePage: LongWord): TBytes;
    function  IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer): LongWord;
    function  IcsSwap16(Value: Word): Word;
    procedure IcsSwap16Buf(Src, Dst: PWord; WordCount: Integer);
    function  IcsSwap32(Value: LongWord): LongWord;
    procedure IcsSwap32Buf(Src, Dst: PLongWord; LongWordCount: Integer);
    procedure IcsSwap64Buf(Src, Dst: PInt64; QuadWordCount: Integer);
{ Wide library }
    function IcsFileCreateW(const FileName: UnicodeString): Integer; overload;
    function IcsFileCreateW(const Utf8FileName: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileCreateW(const FileName: UnicodeString; Rights: LongWord): Integer; overload;
    function IcsFileCreateW(const Utf8FileName: UTF8String; Rights: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileOpenW(const FileName: UnicodeString; Mode: LongWord): Integer; overload;
    function IcsFileOpenW(const Utf8FileName: UTF8String; Mode: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsStrScanW(const Str: PWideChar; Ch: WideChar): PWideChar;
    function IcsExtractFilePathW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileDirW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileDriveW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileNameW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileExtW(const FileName: UnicodeString): UnicodeString;
    function IcsExpandFileNameW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractNameOnlyW(FileName: UnicodeString): UnicodeString; // angus
    function IcsChangeFileExtW(const FileName, Extension: UnicodeString): UnicodeString;  // angus
    function IcsStrAllocW(Len: Cardinal): PWideChar;
    function IcsStrLenW(Str: PWideChar): Cardinal;
    function IcsAnsiCompareFileNameW(const S1, S2: UnicodeString): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsAnsiCompareFileNameW(const Utf8S1, Utf8S2: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsStrCompOrdinalW(Str1: PWideChar; Str1Length: Integer; Str2: PWideChar; Str2Length: Integer; IgnoreCase: Boolean): Integer;
    function IcsDirExistsW(const FileName: PWideChar): Boolean; overload;
    function IcsDirExistsW(const FileName: UnicodeString): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsDirExistsW(const Utf8FileName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFindFirstW(const Path: UnicodeString; Attr: Integer; var F: TIcsSearchRecW): Integer; overload;
    function IcsFindFirstW(const Utf8Path: UTF8String; Attr: Integer; var F: TIcsSearchRecW): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    procedure IcsFindCloseW(var F: TIcsSearchRecW);
    function IcsFindNextW(var F: TIcsSearchRecW): Integer;
    function IcsIncludeTrailingPathDelimiterW(const S: UnicodeString): UnicodeString;
    function IcsExcludeTrailingPathDelimiterW(const S: UnicodeString): UnicodeString;
    function IcsExtractLastDir (const Path: RawByteString): RawByteString ; overload;   // angus
    function IcsExtractLastDir (const Path: UnicodeString): UnicodeString ; overload;   // angus
    function IcsFileGetAttrW(const FileName: UnicodeString): Integer; overload;
    function IcsFileGetAttrW(const Utf8FileName: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileSetAttrW(const FileName: UnicodeString; Attr: Integer): Integer; overload;
    function IcsFileSetAttrW(const Utf8FileName: UTF8String; Attr: Integer): Integer;  {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsDeleteFileW(const FileName: UnicodeString): Boolean; overload;
    function IcsDeleteFileW(const Utf8FileName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsRenameFileW(const OldName, NewName: UnicodeString): Boolean; overload;
    function IcsRenameFileW(const Utf8OldName, Utf8NewName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsForceDirectoriesW(Dir: UnicodeString): Boolean; overload;
    function IcsForceDirectoriesW(Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsCreateDirW(const Dir: UnicodeString): Boolean; overload;
    function IcsCreateDirW(const Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsRemoveDirW(const Dir: UnicodeString): Boolean; overload;
    function IcsRemoveDirW(const Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileAgeW(const FileName: UnicodeString): Integer; overload;
    function IcsFileAgeW(const Utf8FileName: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileExistsW(const FileName: UnicodeString): Boolean; overload;
    function IcsFileExistsW(const Utf8FileName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsAnsiLowerCaseW(const S: UnicodeString): UnicodeString;     // angus
    function IcsAnsiUpperCaseW(const S: UnicodeString): UnicodeString;     // angus
    // NT4 and better
    function  RtlCompareUnicodeString(String1 : PUNICODE_STRING;
        String2 : PUNICODE_STRING; CaseInsensitive : BOOLEAN): LongInt; stdcall;

type
    TIcsIntegerList = class(TObject)
    private
        FList     : TList;
        function  GetCount: Integer;
        function  GetFirst: Integer;
        function  GetLast: Integer;
        function  GetItem(Index: Integer): Integer;
        procedure SetItem(Index: Integer; const Value: Integer);
    public
        constructor Create; virtual;
        destructor  Destroy; override;
        function    IndexOf(Item: Integer): Integer;
        function    Add(Item: Integer): Integer; virtual;
        procedure   Assign(Source: TIcsIntegerList); virtual;
        procedure   Clear; virtual;
        procedure   Delete(Index: Integer); virtual;
        property    Count: Integer read GetCount;
        property    First: Integer read GetFirst;
        property    Last : Integer read GetLast;
        property    Items[Index: Integer] : Integer   read  GetItem
                                                      write SetItem; default;
    end;
    
const
    { Unicode code page ID }
    CP_UTF16      = 1200;
    CP_UTF16Be    = 1201;
    CP_UTF32      = 12000;
    CP_UTF32Be    = 12001;

implementation

const
    DefaultFailChar : AnsiChar  = '?';
    {$EXTERNALSYM CP_UTF8}
    CP_UTF8             = Windows.CP_UTF8;
    MAX_UTF8_SIZE       = 4;
    IcsPathDelimW       : WideChar  = '\';
    IcsDriveDelimW      : WideChar  = ':';
    IcsPathDriveDelimW  : PWideChar = '\:';
    IcsPathSepW         : WideChar  = ';';

var
    hNtDll : THandle = 0;
    _RtlCompareUnicodeString : Pointer = nil;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUsAscii(const Str: RawByteString): Boolean;
var
    I : Integer;
begin
    for I := 1 to Length(Str) do
        if Byte(Str[I]) > 127 then begin
            Result := FALSE;
            Exit;
        end;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUsAscii(const Str: UnicodeString): Boolean;
var
    I : Integer;
begin
    for I := 1 to Length(Str) do
        if Ord(Str[I]) > 127 then begin
            Result := FALSE;
            Exit;
        end;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Assumes parameter Str does not contain any 8Bit characters otherwise they   }
{ are replaced by FailCh. When we use plain ASCII payload this could be the   }
{ fastes cast. Sometimes we handle 7 bit strings only.                        }
function UnicodeToUsAscii(const Str: UnicodeString; FailCh: AnsiChar): AnsiString;
var
    I   : Integer;
    Len : Integer;
begin
    Len := Length(Str);
    SetLength(Result, Len);
    for I := 1 to Len do begin
        if Ord(Str[I]) > 127 then
            Result[I] := FailCh
        else
            Result[I] := AnsiChar(Str[I]);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UnicodeToUsAscii(const Str: UnicodeString): AnsiString;
begin
    Result := UnicodeToUsAscii(Str, DefaultFailChar);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to an AnsiString.                                 }
function UnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString;
var
    Len : Integer;
begin
    Len := Length(Str);
    if Len > 0 then begin
        Len := WideCharToMultiByte(ACodePage, 0, Pointer(Str), Len, nil, 0, nil, nil);
        SetLength(Result, Len);
        if Len > 0 then begin
            WideCharToMultiByte(ACodePage, 0, Pointer(Str), Length(Str),
                                Pointer(Result), Len, nil, nil);
        {$IFDEF COMPILER12_UP}
            if SetCodePage and (ACodePage <> CP_ACP) then
                PWord(INT_PTR(Result) - 12)^ := ACodePage;
        {$ENDIF}
        end;
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to an AnsiString using current code page.         }
function UnicodeToAnsi(const Str: UnicodeString): RawByteString;
begin
    Result := UnicodeToAnsi(Str, CP_ACP);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: PAnsiChar; ACodePage: LongWord): UnicodeString;
var
    Len : Integer;
begin
    if (Str <> nil) then begin
        Len := MultiByteToWideChar(ACodePage, 0, Str,
                                   -1, nil, 0);
        if Len > 1 then begin // counts the null-terminator
            SetLength(Result, Len - 1);
            MultiByteToWideChar(ACodePage, 0, Str, -1,
                                Pointer(Result), Len);
        end
        else
            Result := '';
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UnicodeToAnsi(const Str: PWideChar; ACodePage: LongWord;
  SetCodePage: Boolean = False): RawByteString;
var
    Len : Integer;
begin
    if (Str <> nil) then begin
        Len := WideCharToMultibyte(ACodePage, 0, Str, -1,
                                   nil, 0, nil, nil);
        if Len > 1 then begin // counts the null-terminator
            SetLength(Result, Len - 1);
            WideCharToMultibyte(ACodePage, 0, Str, -1,
                                Pointer(Result), Len,
                                nil, nil);
        {$IFDEF COMPILER12_UP}
            if SetCodePage and (ACodePage <> CP_ACP) then
                PWord(INT_PTR(Result) - 12)^ := ACodePage;
        {$ENDIF}
        end
        else
            Result := '';
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: RawByteString; ACodePage: LongWord): UnicodeString;
var
    Len : Integer;
begin
    Len := Length(Str);
    if Len > 0 then begin
        Len := MultiByteToWideChar(ACodePage, 0, Pointer(Str),
                                   Len, nil, 0);
        SetLength(Result, Len);
        if Len > 0 then
            MultiByteToWideChar(ACodePage, 0, Pointer(Str), Length(Str),
                                Pointer(Result), Len);
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: RawByteString): UnicodeString;
begin
    Result := AnsiToUnicode(Str, CP_ACP);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UsAsciiToUnicode(const Str: RawByteString; FailCh: AnsiChar): UnicodeString;
var
    I  : Integer;
    P  : PByte;
begin
    SetLength(Result, Length(Str));
    P := Pointer(Result);
    for I := 1 to Length(Str) do begin
        if Byte(Str[I]) > 127 then
            P^ := Byte(FailCh)
        else
            P^ := Byte(Str[I]);
        Inc(P);
        P^ := 0;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UsAsciiToUnicode(const Str: RawByteString): UnicodeString;
begin
    Result := UsAsciiToUnicode(Str, DefaultFailChar);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSwap16(Value: Word): Word;
{$IFDEF PUREPASCAL}
begin
    Result := (Value shr 8) or (Value shl 8);
{$ELSE}
asm
    XCHG  AL, AH
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap16Buf(Src, Dst: PWord; WordCount: Integer);
{$IFDEF PUREPASCAL}
var
    I : Integer;
begin
    for I := 1 to WordCount do
    begin
        Dst^ := (Src^ shr 8) or (Src^ shl 8);
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
{ Thanks to Jens Dierks for this code }
asm
       PUSH   ESI
       PUSH   EBX
       SUB    EAX,EDX
       SUB    ECX,4
       JS     @@2
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX + 2],BX
       MOV    [EDX + 6],SI
       SHR    EBX, 16
       SHR    ESI, 16
       MOV    [EDX],BX
       MOV    [EDX + 4],SI
       ADD    EDX, 8
       SUB    ECX, 4
       JNS    @@1
@@2:
       ADD    ECX, 2
       JS     @@3
       MOV    EBX,[EAX + EDX]
       BSWAP  EBX
       MOV    [EDX + 2],BX
       SHR    EBX, 16
       MOV    [EDX],BX
       ADD    EDX, 4
       SUB    ECX, 2
@@3:
       INC    ECX
       JNZ    @@4
       MOV    BX,[EAX + EDX]
       XCHG   BL,BH
       MOV    [EDX],BX
@@4:
       POP    EBX
       POP    ESI
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSwap32(Value: LongWord): LongWord;
{$IFDEF PUREPASCAL}
begin
    Result := Word(((Value shr 16) shr 8) or ((Value shr 16) shl 8)) or
              Word((Word(Value) shr 8) or (Word(Value) shl 8)) shl 16;
{$ELSE}
asm
    BSWAP  EAX
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap32Buf(Src, Dst: PLongWord; LongWordCount: Integer);
{$IFDEF PUREPASCAL}
var
    I : Integer;
begin
    for I := 1 to LongWordCount do
    begin
        Dst^ := Word(((Src^ shr 16) shr 8) or ((Src^ shr 16) shl 8)) or
                Word((Word(Src^) shr 8) or (Word(Src^) shl 8)) shl 16;
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
asm
       PUSH   ESI
       PUSH   EBX
       SUB    EAX, EDX
       SUB    ECX, 2
       JS     @@2
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX], EBX
       MOV    [EDX + 4], ESI
       ADD    EDX, 8
       SUB    ECX, 2
       JNS    @@1
@@2:
       INC    ECX
       JS     @Exit
       MOV    EBX,[EAX + EDX]
       BSWAP  EBX
       MOV    [EDX], EBX
@Exit:
       POP    EBX
       POP    ESI
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap64Buf(Src, Dst: PInt64; QuadWordCount: Integer);
{$IFDEF PUREPASCAL}
var
    H, L: LongWord;
    I : Integer;
begin
    for I := 1 to QuadWordCount do
    begin
        H := LongWord(Src^ shr 32);
        L := LongWord(Src^);
        H := Word(((H shr 16) shr 8) or ((H shr 16) shl 8)) or
             Word((Word(H) shr 8) or (Word(H) shl 8)) shl 16;
        L := Word(((L shr 16) shr 8) or ((L shr 16) shl 8)) or
             Word((Word(L) shr 8) or (Word(L) shl 8)) shl 16;
        Dst^ := Int64(H) or Int64(L) shl 32;
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
asm
       PUSH   ESI
       PUSH   EBX
       SUB    EAX, EDX
       DEC    ECX
       JS     @Exit
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX], ESI
       MOV    [EDX + 4], EBX
       ADD    EDX, 8
       DEC    ECX
       JNS    @@1
@Exit:
       POP    EBX
       POP    ESI
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Result is the number of translated WideChars, InvalidEndByteCount returns   }
{ the number of untranslated bytes at the end of the source buffer only       }
{ (if any). If there were invalid byte sequences somewhere else they may be   }
{ translated/counted or not depending on the OS version and code page.        }
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be    }
function IcsGetWideCharCount(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; out InvalidEndByteCount: Integer): Integer;

{$IFNDEF COMPILER12_UP}
const
    MB_ERR_INVALID_CHARS  = $00000008;  // Missing in Windows.pas
{$ENDIF}
    
    function GetMbcsInvalidEndBytes(const EndBuf: PAnsiChar): Integer;
    var
        P : PAnsiChar;
        Utf8Size : Integer;
    begin
        { If last byte equals NULL this function always returns "0"           }
        if INT_PTR(@Buffer) < INT_PTR(EndBuf) then
        begin
            { Try to get a pointer to the last lead byte, see comment in      }
            { IcsStrPrevChar()                                                }
            P := IcsStrPrevChar(@Buffer, EndBuf, BufferCodePage);
            Result := INT_PTR(EndBuf) - INT_PTR(P);
            if (Result > 0) and (BufferCodePage = CP_UTF8) then
            begin
                Utf8Size := IcsUtf8Size(Byte(P^));
                if (Utf8Size > 0) and (Utf8Size < Result) then
                begin { Looks like we got a complete and a trunkated sequence }
                    if (Utf8Size = 1) { should always translate } or
                       (MultiByteToWideChar(BufferCodePage, MB_ERR_INVALID_CHARS,
                                            P, Utf8Size, nil, 0) > 0) then
                    begin
                        Inc(P, Utf8Size);
                        Dec(Result, Utf8Size);
                    end;
                end;
            end;
            if (Result > 0) and
               (MultiByteToWideChar(BufferCodePage, MB_ERR_INVALID_CHARS,
                           P, Result, nil, 0) > 0) then
                Result := 0;
        end
        else
            Result := 0;
    end;

var
    I     : Integer;
    Bytes : PByte;
    LastErr : LongWord;
begin
    Bytes := @Buffer;
    case BufferCodePage of
        CP_UTF16,
        CP_UTF16Be  :
            begin
                Result := BufferSize div SizeOf(WideChar);
                InvalidEndByteCount := BufferSize mod SizeOf(WideChar);
            end;
        CP_UTF32    :
            begin
                Result := BufferSize div SizeOf(UCS4Char);
                InvalidEndByteCount := BufferSize mod SizeOf(UCS4Char);
                for I := 1 to Result do
                begin
                    if PLongWord(Bytes)^ > $10000 then
                        Inc(Result); // Surrogate pair
                    Inc(Bytes, SizeOf(UCS4Char));
                end;
            end;
        CP_UTF32Be  :
            begin
                Result := BufferSize div SizeOf(UCS4Char);
                InvalidEndByteCount := BufferSize mod SizeOf(UCS4Char);
                for I := 1 to Result do
                begin
                    if IcsSwap32(PLongWord(Bytes)^) > $10000 then
                        Inc(Result); // Surrogate pair
                    Inc(Bytes, SizeOf(UCS4Char));
                end;
            end;
        else
            InvalidEndByteCount := 0;
            Result := MultiByteToWideChar(BufferCodePage, MB_ERR_INVALID_CHARS,
                                          PAnsiChar(Bytes), BufferSize, nil, 0);
            { Not every code page supports flag MB_ERR_INVALID_CHARS.         }
            { Depends on the Windows version as well, see SDK-docs.           }
            { However mbtowc's doc is not correct regarding older Windows.    }
            { Some tests with UTF-8 showed that in W2K SP4 and XP SP3 mbtowc  }
            { happily takes this flag and seems to skip invalid source bytes  }
            { silently if they are NOT at the end of the source buffer. If    }
            { they are at the end mbtowc fails as documented. Other MBCS seem }
            { to work as documented (tested 932 only). Windows Vista seems to }
            { work as documented too.                                         }
            if Result = 0 then
            begin
                LastErr := GetLastError;
                if LastErr = ERROR_INVALID_FLAGS then
                    { Try again with flags "0", nothing else can be done      }
                    Result := MultiByteToWideChar(BufferCodePage, 0,
                                          PAnsiChar(Bytes), BufferSize, nil, 0)
                else if LastErr = ERROR_NO_UNICODE_TRANSLATION then
                begin
                    { There's some invalid bytes but we don't know where in  }
                    { the source buffer. Try to get the number of            }
                    { untranslated bytes at the end of the source buffer     }
                    {(if any). It won't work with all code pages correctly.  }
                    { According to Mrs. Kaplan, code pages 932, 936, 949,    }
                    { 950, and 1361 are supported. UTF-8 support is an ICS   }
                    { home-grown routine.                                    }
                    InvalidEndByteCount := GetMbcsInvalidEndBytes(
                                              PAnsiChar(Bytes) + BufferSize);
                    { Then call mbtowc with a shorter source buffer and flag }
                    { "0".                                                   }
                    Result := MultiByteToWideChar(BufferCodePage, 0,
                        PAnsiChar(Bytes), BufferSize - InvalidEndByteCount,
                        nil, 0);
                end;
            end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be }
function IcsGetWideChars(const Buffer; BufferSize: Integer;
   BufferCodePage: LongWord; Chars: PWideChar; CharCount: Integer): Integer;
var
    PUCS4 : PUCS4Char;
    I     : Integer;
    
    procedure UCS4ToU16;
    begin
        I := 0;
        while I < CharCount do begin
            if PUCS4^ > $10000 then
            begin
                { Encode Surrogate pair }
                Inc(I);
                Chars^ := WideChar((((PUCS4^ - $00010000) shr 10) and
                                   $000003FF) or $D800);
                Inc(I);
                Inc(Chars);
                Chars^ := WideChar(((PUCS4^ - $00010000) and $000003FF) or
                                   $DC00);
            end
            else begin
                Inc(I);
                Chars^ := WideChar(PUCS4^);
            end;
            Inc(PUCS4);
            Inc(Chars);
        end;
    end;

begin
    case BufferCodePage of
        CP_UTF16    :
            begin
                Move(Buffer, Chars^, BufferSize);
                Result := CharCount;
            end;
        CP_UTF16Be  :
            begin
                IcsSwap16Buf(@Buffer, Pointer(Chars), CharCount);
                Result := CharCount;
            end;
        CP_UTF32    :
            begin
                PUCS4 := @Buffer;
                UCS4ToU16;
                Result := CharCount;
            end;
        CP_UTF32Be  :
            begin
                IcsSwap32Buf(@Buffer, @Buffer, BufferSize div SizeOf(UCS4Char));
                PUCS4 := @Buffer;
                UCS4ToU16;
                Result := CharCount;
            end;

        else
           Result := MultiByteToWideChar(BufferCodePage, 0, @Buffer,
                                         BufferSize, Chars, CharCount);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be    }
function IcsBufferToUnicode(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; out FailedByteCount: Integer): UnicodeString;
var
    WCharCnt: Integer;
begin
    FailedByteCount := 0;
    if (@Buffer = nil) or (BufferSize <= 0) then
        Result := ''
    else begin
        WCharCnt := IcsGetWideCharCount(Buffer, BufferSize, BufferCodePage,
                                        FailedByteCount);
        SetLength(Result, WCharCnt);
        if WCharCnt > 0 then
            IcsGetWideChars(Buffer, BufferSize - FailedByteCount,
                            BufferCodePage, PWideChar(Result), WCharCnt);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be }
function IcsBufferToUnicode(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; RaiseFailedBytes: Boolean = FALSE): UnicodeString;
var
    FailedBytes : Integer;
begin
    FailedBytes := 0;
    Result := IcsBufferToUnicode(Buffer, BufferSize, BufferCodePage, FailedBytes);
    if RaiseFailedBytes and (FailedBytes > 0) then
        raise EIcsStringConvertError.CreateFmt(
                        'Invalid bytes in source buffer. %d bytes untranslated',
                                                 [FailedBytes]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsAppendStr(var Dest: RawByteString; const Src: RawByteString);
begin
{$IFDEF COMPILER12_UP}
    SetLength(Dest, Length(Dest) + Length(Src));
    Move(Pointer(Src)^, Dest[Length(Dest) - Length(Src) + 1], Length(Src));
{$ELSE}
    Dest := Dest + Src;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetBomBytes(ACodePage: LongWord): TBytes;
begin
    case ACodePage of
        CP_UTF16 :
        begin
            SetLength(Result, 2);
            Result[0] := $FF;
            Result[1] := $FE;
        end;
        CP_UTF16Be :
        begin
            SetLength(Result, 2);
            Result[0] := $FE;
            Result[1] := $FF;
        end;
        CP_UTF8    :
        begin
            SetLength(Result, 3);
            Result[0] := $EF;
            Result[1] := $BB;
            Result[2] := $BF;
        end;
        CP_UTF32   :
        begin
            SetLength(Result, 4);
            Result[0] := $FF;
            Result[1] := $FE;
            Result[2] := $00;
            Result[3] := $00;
        end;
        CP_UTF32Be :
        begin
            SetLength(Result, 4);
            Result[0] := $00;
            Result[1] := $00;
            Result[2] := $FE;
            Result[3] := $FF;
        end;
        else
            SetLength(Result, 0);
    end;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer): LongWord;
begin
    Result := CP_ACP;
    if (Buf = nil) then
        Exit;
    if (ByteCount > 3) and (Buf[0] = #$FF) and (Buf[1] = #$FE) and
       (Buf[2] = #0) and (Buf[3] = #0) then
        Result := CP_UTF32
    else if (ByteCount > 3) and (Buf[0] = #0) and (Buf[1] = #0) and
            (Buf[2] = #$FE) and (Buf[3] = #$FF) then
        Result := CP_UTF32Be
    else if (ByteCount > 2) and (Buf[0] = #$EF) and (Buf[1] = #$BB) and
            (Buf[2] = #$BF)  then
        Result := CP_UTF8
    else if (ByteCount > 1) and (Buf[0] = #$FF) and (Buf[1] = #$FE) then
        Result := CP_UTF16
    else if (ByteCount > 1) and (Buf[0] = #$FE) and (Buf[1] = #$FF) then
        Result := CP_UTF16Be;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Assumes that the string is a Windows, UTF-16 little endian wide string      }
function StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer;
  ACodePage: LongWord; WriteBOM: Boolean): Integer;
var
    SBuf  : array [0..2047] of Byte;
    Len   : Integer;
    HBuf  : PAnsiChar;
    Bom   : TBytes;
    CurCP : Word;
    Swap  : Boolean;
    Dump  : Boolean;
begin
    Result := 0;
    if (Str = nil) or (cLen <= 0) then
        Exit;
    CurCP := CP_UTF16; //PWord(Integer(Str) - 12)^;
    case ACodePage of
        CP_UTF16  :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 2);
                    BOM[0] := $FF;
                    BOM[1] := $FE;
                end;
                Swap := CurCP = CP_UTF16Be;
                Dump := (CurCP = ACodePage) or Swap;
            end;
        CP_UTF16Be :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 2);
                    BOM[0] := $FE;
                    BOM[1] := $FF;
                end;
                Swap := CurCP = CP_UTF16;
                Dump := (CurCP = ACodePage) or Swap;
            end;
        CP_UTF8 :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 3);
                    BOM[0] := $EF;
                    BOM[1] := $BB;
                    BOM[2] := $BF;
                end;
                Dump := FALSE;
                Swap := FALSE;
            end;
        else
            SetLength(BOM, 0);
            Dump := FALSE;
            Swap := FALSE;
    end; // case

    if Dump and not Swap then
    begin // No conversion needed
        if Bom <> nil then
            AStream.Write(Bom[0], Length(Bom));
        Result := AStream.Write(Pointer(Str)^, cLen * 2); //Use const char length 
    end
    else begin
        if Dump and Swap then
        begin // We need to swap bytes and write them to the stream
            if Bom <> nil then
                AStream.Write(Bom[0], Length(Bom));
            IcsSwap16Buf(Pointer(Str), Pointer(Str), cLen);
            Result := Result + AStream.Write(Str^, cLen * 2);
        end
        else begin // Charset conversion
            Len := WideCharToMultibyte(ACodePage, 0, Pointer(Str), cLen,
                                       nil, 0, nil, nil);
            if Len <= SizeOf(SBuf) then begin
                Len := WideCharToMultibyte(ACodePage, 0, Pointer(Str), cLen,
                                           @SBuf, Len, nil, nil);
                if (Len > 0) then begin
                    if Bom <> nil then
                        AStream.Write(Bom[0], Length(Bom));
                    Result := AStream.Write(SBuf[0], Len);
                end;
            end
            else begin
                GetMem(HBuf, Len);
                try
                    Len := WideCharToMultibyte(ACodePage, 0, Pointer(Str), cLen,
                                               HBuf, Len, nil, nil);
                    if (Len > 0) then begin
                        if Bom <> nil then
                            AStream.Write(Bom[0], Length(Bom));
                        Result := AStream.Write(HBuf^, Len);
                    end;
                finally
                    FreeMem(HBuf);
                end;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer;
  ACodePage: LongWord): Integer;
begin
    Result := StreamWriteString(AStream, Str, cLen, ACodePage, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString;
 ACodePage: LongWord; WriteBOM: Boolean): Integer;
begin
    Result := StreamWriteString(AStream, Pointer(Str), Length(Str),
                                ACodePage, WriteBom);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString): Integer;
begin
    Result:= StreamWriteString(AStream, Pointer(Str), Length(Str),
                               CP_ACP, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString;
  ACodePage: LongWord): Integer;
begin
    Result:= StreamWriteString(AStream, Pointer(Str), Length(Str),
                               ACodePage, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*
function atoi(const Str: AnsiString): Integer;
var
    I : Integer;
begin
    Result := 0;
    I := 1;
    while (I <= Length(Str)) and (Str[I] = ' ') do
        I := I + 1;
    while (I <= Length(Str)) and (Str[I] >= '0') and (Str[I] <= '9') do begin
        Result := Result * 10 + Ord(Str[I]) - Ord('0');
        I := I + 1;
    end;
end;
*)

{ This one is around 3-4 times faster } { AG }
function atoi(const Str : RawByteString): Integer;
var
    P : PAnsiChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$20 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Byte(P^) - Byte('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*
function atoi(const Str: UnicodeString): Integer;
var
    I : Integer;
begin
    Result := 0;
    I := 1;
    while (I <= Length(Str)) and (Str[I] = ' ') do
        I := I + 1;
    while (I <= Length(Str)) and (Str[I] >= '0') and (Str[I] <= '9') do begin
        Result := Result * 10 + Ord(Str[I]) - Ord('0');
        I := I + 1;
    end;
end;
*)

{ This one is around 3-4 times faster } { AG }
function atoi(const Str : UnicodeString): Integer;
var
    P : PWideChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$0020 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Ord(P^) - Ord('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF STREAM64}
(*
function atoi64(const Str: AnsiString): Int64;
var
    I : Integer;
begin
    Result := 0;
    I := 1;
    while (I <= Length(Str)) and (Str[I] = ' ') do
        I := I + 1;
    while (I <= Length(Str)) and (Str[I] >= '0') and (Str[I] <= '9') do begin
        Result := Result * 10 + Ord(Str[I]) - Ord('0');
        I := I + 1;
    end;
end;
*)

{ This one is around 3-4 times faster } { AG }
function atoi64(const Str : RawByteString): Int64;
var
    P : PAnsiChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$20 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Byte(P^) - Byte('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*
function atoi64(const Str: UnicodeString): Int64;
var
    I : Integer;
begin
    Result := 0;
    I := 1;
    while (I <= Length(Str)) and (Str[I] = ' ') do
        I := I + 1;
    while (I <= Length(Str)) and (Str[I] >= '0') and (Str[I] <= '9') do begin
        Result := Result * 10 + Ord(Str[I]) - Ord('0');
        I := I + 1;
    end;
end;
*)

{ This one is around 3-4 times faster } { AG }
function atoi64(const Str : UnicodeString): Int64;
var
    P : PWideChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$0020 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Ord(P^) - Ord('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCalcTickDiff(const StartTick, EndTick : LongWord): LongWord;
begin
    if EndTick >= StartTick then
        Result := EndTick - StartTick
    else
        Result := High(LongWord) - StartTick + EndTick;
end;


{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
function StringToUtf8(const Str: UnicodeString): RawByteString;
begin
    Result := UnicodeToAnsi(Str, CP_UTF8, True);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ConvertCodepage(const Str: RawByteString; SrcCodePage: LongWord;
  DstCodePage: LongWord = CP_ACP): RawByteString;
var
    SBuf : array[0..2047] of WideChar;
    P    : PWideChar;
    sLen : Integer;
    dLen : Integer;
    FreeFlag : Boolean;
begin
    sLen := Length(Str);
    if (sLen = 0) or (SrcCodePage = DstCodePage) then
    begin
        Result := Str;
        Exit;
    end;
    dLen := MultibyteToWideChar(SrcCodePage, 0, Pointer(Str), sLen, nil, 0);
    if dLen = 0 then
    begin
        Result := '';
        Exit;
    end;
    if dLen > Length(SBuf) then
    begin
        GetMem(P, dLen * 2);
        FreeFlag := TRUE;
    end
    else begin
        FreeFlag := FALSE;
        P := SBuf;
    end;
    dLen := MultibyteToWideChar(SrcCodePage, 0, Pointer(Str), sLen, P, dLen);
    if dLen > 0 then
    begin
        sLen := WideCharToMultiByte(DstCodePage, 0, P, dLen, nil, 0, nil, nil);
        SetLength(Result, sLen);
        if sLen > 0 then
        begin
            WideCharToMultiByte(DstCodePage, 0, P, dLen, Pointer(Result), sLen, nil, nil);
        {$IFDEF COMPILER12_UP}
            if DstCodePage <> CP_ACP then
                PWord(INT_PTR(Result) - 12)^ := DstCodePage;
        {$ENDIF}
        end;
    end
    else
        Result := '';
    if FreeFlag then FreeMem(P);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StringToUtf8(const Str: RawByteString; ACodePage: LongWord = CP_ACP): RawByteString;
begin
    Result := ConvertCodepage(Str, ACodePage, CP_UTF8);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Utf8ToStringW(const Str: RawByteString): UnicodeString;
begin
    Result := AnsiToUnicode(Str, CP_UTF8);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Utf8ToStringA(const Str: RawByteString; ACodePage: LongWord = CP_ACP): AnsiString;
begin
    Result := ConvertCodepage(Str, CP_UTF8, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CheckUnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord = CP_ACP): Boolean;
var
    Len : Integer;
    B   : Bool;
begin
    Len := Length(Str);
    if Len > 0 then begin
        Len := WideCharToMultiByte(ACodePage, 0, Pointer(Str), Len, nil, 0, nil, @B);
        { MS-docs: For the CP_UTF7 and CP_UTF8 settings for CodePage, parameter }
        { lpUsedDefaultChar must be set to NULL. Otherwise, the function fails  }
        { with ERROR_INVALID_PARAMETER.                                         }
        if (Len = 0) and (GetLastError = ERROR_INVALID_PARAMETER) then
            Result := WideCharToMultiByte(ACodePage, 0, Pointer(Str),
                                          Len, nil, 0, nil, nil) > 0
        else
            Result := (not B) and (Len > 0);
    end
    else
        Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Returns size of a UTF-8 byte sequence calculated from the UTF-8 lead byte   }
{ Returns "0" if LeadByte is not valid UTF-8 lead byte.                       }
function IcsUtf8Size(const LeadByte: Byte): Integer;
begin
    case LeadByte of
        $00..$7F : Result := 1;
        $C2..$DF : Result := 2;
        $E0..$EF : Result := 3;
        $F0..$F4 : Result := 4;
    else
        Result := 0; // Invalid lead byte
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8LeadByte(const B: Byte): Boolean;
begin
    Result := (B < $80) or (B in [$C2..$F4]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8TrailByte(const B: Byte): Boolean;
begin
    Result := B in [$80..$BF];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF COMPILER12_UP}
function IsLeadChar(Ch: WideChar): Boolean;
begin
    Result := (Ch >= #$D800) and (Ch <= #$DFFF);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CharsetDetect(const Buf: Pointer; Len: Integer): TCharsetDetectResult;
var
    PEndBuf   : PByte;
    PBuf      : PByte;
    Byte2Mask : Byte;
    Ch        : Byte;
    Trailing  : Integer; // trailing (continuation) bytes to follow
begin
    PBuf        := Buf;
    PEndBuf     := Pointer(INT_PTR(Buf) + Len);
    Byte2Mask   := $00;
    Trailing    := 0;
    Result      := cdrAscii;
    while (PBuf <> PEndBuf) do
    begin
        Ch := PBuf^;
        Inc(INT_PTR(PBuf));
        if Trailing <> 0 then
        begin
            if Ch and $C0 = $80 then // Does trailing byte follow UTF-8 format?
            begin
                if (Byte2Mask <> 0) then // Need to check 2nd byte for proper range?
                    if Ch and Byte2Mask <> 0 then // Are appropriate bits set?
                        Byte2Mask := 0
                    else begin
                        Result := cdrUnknown;
                        Exit;
                    end;
                Dec(Trailing);
                Result := cdrUtf8;
            end
            else begin
                Result := cdrUnknown;
                Exit;
            end;
        end
        else begin
            if Ch and $80 = 0 then
                Continue                      // valid 1 byte UTF-8
            else if Ch and $E0 = $C0 then     // valid 2 byte UTF-8
            begin
                if Ch and $1E <> 0 then       // Is UTF-8 byte in proper range?
                    Trailing := 1
                else begin
                    Result := cdrUnknown;
                    Exit;
                end;
            end
            else if Ch and $F0 = $E0 then     // valid 3 byte UTF-8
            begin
                if Ch and $0F = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $20;         // If not set mask to check next byte
                Trailing := 2;
            end
            else if Ch and $F8 = $F0 then     // valid 4 byte UTF-8
            begin
                if Ch and $07 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $30;         // If not set mask to check next byte
                Trailing := 3;
            end
          { 4 byte is the maximum today, see ISO 10646, so let's break here }
          { else if Ch and $FC = $F8 then     // valid 5 byte UTF-8
            begin
                if Ch and $03 = 0 then        // Is UTF-8 byte in  proper range?
                    Byte2Mask := $38;         // If not set mask to check next byte
                Trailing := 4;
            end
            else if Ch and $FE = $FC then     // valid 6 byte UTF-8
            begin
                if ch and $01 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $3C;         // If not set mask to check next byte
                Trailing := 5;
            end}
            else begin
                Result := cdrUnknown;
                Exit;
            end;
        end;
    end;// while

    case Result of
      cdrUtf8, cdrAscii : if Trailing <> 0 then Result := cdrUnknown;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CharsetDetect(const Str: RawByteString): TCharsetDetectResult;
begin
    Result := CharsetDetect(Pointer(Str), Length(Str));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8Valid(const Str: RawByteString): Boolean;
begin
    //Result := IsUtf8Valid(Pointer(Str), Length(Str));
    Result := CharSetDetect(Pointer(Str), Length(Str)) <> cdrUnknown;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8Valid(const Buf: Pointer; Len: Integer): Boolean;
{var
    PEndBuf   : PByte;
    PBuf      : PByte;
    Byte2Mask : Byte;
    Ch        : Byte;
    Trailing  : Integer; // trailing (continuation) bytes to follow }
begin
    Result := CharSetDetect(Buf, Len) <> cdrUnknown;
   (* PBuf        := Buf;
    PEndBuf     := Pointer(INT_PTR(Buf) + Len);
    Byte2Mask   := $00;
    Trailing    := 0;
    while (PBuf <> PEndBuf) do
    begin
        Ch := PBuf^;
        Inc(INT_PTR(PBuf));
        if Trailing <> 0 then
        begin
            if Ch and $C0 = $80 then // Does trailing byte follow UTF-8 format?
            begin
                if (Byte2Mask <> 0) then // Need to check 2nd byte for proper range?
                    if Ch and Byte2Mask <> 0 then // Are appropriate bits set?
                        Byte2Mask := 0
                    else begin
                        Result := False;
                        Exit;
                    end;
                Dec(Trailing);
            end
            else begin
                Result := False;
                Exit;
            end;
        end
        else begin
            if Ch and $80 = 0 then
                Continue                      // valid 1 byte UTF-8
            else if Ch and $E0 = $C0 then     // valid 2 byte UTF-8
            begin
                if Ch and $1E <> 0 then       // Is UTF-8 byte in proper range?
                    Trailing := 1
                else begin
                    Result := False;
                    Exit;
                end;
            end
            else if Ch and $F0 = $E0 then     // valid 3 byte UTF-8
            begin
                if Ch and $0F = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $20;         // If not set mask to check next byte
                Trailing := 2;
            end
            else if Ch and $F8 = $F0 then     // valid 4 byte UTF-8
            begin
                if Ch and $07 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $30;         // If not set mask to check next byte
                Trailing := 3;
            end
          { 4 byte is the maximum today, see ISO 10646, so let's break here }
          { else if Ch and $FC = $F8 then     // valid 5 byte UTF-8
            begin
                if Ch and $03 = 0 then        // Is UTF-8 byte in  proper range?
                    Byte2Mask := $38;         // If not set mask to check next byte
                Trailing := 4;
            end
            else if Ch and $FE = $FC then     // valid 6 byte UTF-8
            begin
                if ch and $01 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $3C;         // If not set mask to check next byte
                Trailing := 5;
            end}
            else begin
                Result := False;
                Exit;
            end;
        end;
    end;// while
    Result := Trailing = 0; *)
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ The return value is a pointer to the preceding character in the string,   }
{ or to the first character in the string if the Current parameter equals   }
{ the Start parameter.                                                      }
function IcsCharPrevUtf8(const Start, Current: PAnsiChar): PAnsiChar;
var
    Cnt : Integer;
begin
    Cnt := 0;
    Result := Current;
    while (INT_PTR(Result) > INT_PTR(Start)) and (Cnt < MAX_UTF8_SIZE) do
    begin
        Dec(Result);
        if IsUtf8LeadByte(Byte(Result^)) then
            Break;
        Inc(Cnt);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCharNextUtf8(const Str: PAnsiChar): PAnsiChar;
var
    Cnt : Integer;
begin
    Result := Str;
    if (Result = nil) or (Result^ = #0) then
        Exit;
    for Cnt := 1 to MAX_UTF8_SIZE do
    begin
        Inc(Result);
        if (Result^ = #0) or IsUtf8LeadByte(Byte(Result^)) then
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrNextChar(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
begin
    if ACodePage = CP_UTF8 then
        Result := IcsCharNextUtf8(Str)
    else
        Result := CharNextExA(Word(ACodePage), Str, 0);
        { From Mitch Kaplan's blog                                        }
        { http://blogs.msdn.com/michkap/archive/2007/04/19/2190207.aspx): }
        { Neither CharNextExA nor CharPrevExA are broken in any version   }
        { of Windows, but neither one was designed with UTF-8 in mind.    }
        {...                                                              }
        { It is completely dependent on the behavior of IsDBCSLeadByteEx, }
        { which is an NLS function that is (for obvious reasons) only     }
        { dealing with East Asian, DBCS code page.                        }

        { Comment: Poor design isn't it? IsDBCSLeadByteEx validates lead  }
        { byte values only in code pages 932, 936, 949, 950, and 1361.    }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrPrevChar(const Start, Current: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
begin
    if ACodePage = CP_UTF8 then
        Result := IcsCharPrevUtf8(Start, Current)
    else
        Result := CharPrevExA(Word(ACodePage), Start, Current, 0);
        { Read comment in IcsStrNextChar                                  }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrCharLength(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): Integer;
begin
    Result := INT_PTR(IcsStrNextChar(Str, ACodePage)) - INT_PTR(Str);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsNextCharIndex(const S: RawByteString; Index: Integer; ACodePage: LongWord = CP_ACP): Integer;
begin
    Assert((Index > 0) and (Index <= Length(S)));
    Result := Index + 1;
    if (ACodePage = CP_ACP) and not (S[Index] in LeadBytes) then
        Exit;
    Result := Index + IcsStrCharLength(PAnsiChar(S) + Index - 1, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit(Ch : WideChar) : Integer;
begin
    case Ch of
        '0'..'9' : Result := Ord(Ch) - Ord('0');
    else
        Result := (Ord(Ch) and 15) + 9;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit(Ch : AnsiChar) : Integer;
begin
    case Ch of
        '0'..'9' : Result := Ord(Ch) - Ord('0');
    else
        Result := (Ord(Ch) and 15) + 9;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit2(S : PChar) : Integer;
begin
    Result := 16 * XDigit(S[0]) + XDigit(S[1]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsXDigit(Ch : WideChar) : Boolean;
begin
    Result := ((Ch >= '0') and (Ch <= '9')) or
              ((Ch >= 'a') and (Ch <= 'f')) or
              ((Ch >= 'A') and (Ch <= 'F'));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsXDigit(Ch : AnsiChar) : Boolean;
begin
    Result := ((Ch >= '0') and (Ch <= '9')) or
              ((Ch >= 'a') and (Ch <= 'f')) or
              ((Ch >= 'A') and (Ch <= 'F'));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoin(Value : PWideChar; Len : Integer) : Integer;
var
    I : Integer;
begin
    Result := 0;
    I      := 0;
    while (I < Len) and (Value[I] = ' ') do
        I := I + 1;
    while (I < len) and (IsXDigit(Value[I])) do begin
        Result := Result * 16 + XDigit(Value[I]);
        I := I + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoin(Value : PAnsiChar; Len : Integer) : Integer;
var
    I : Integer;
begin
    Result := 0;
    I      := 0;
    while (I < Len) and (Value[I] = ' ') do
        I := I + 1;
    while (I < len) and (IsXDigit(Value[I])) do begin
        Result := Result * 16 + XDigit(Value[I]);
        I := I + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoi2(Value : PWideChar) : Integer;
begin
    Result := htoin(Value, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoi2(Value : PAnsiChar) : Integer;
begin
    Result := htoin(Value, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
const
    HexTable : array[0..15] of Char =
    ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

function IcsBufferToHex(const Buf; Size: Integer; Separator: Char): String;
const
    Fact = 3;
var
    I : Integer;
    P : PChar;
    B : PAnsiChar;
begin
    if Size <= 0 then
        Result := ''
    else begin
        SetLength(Result, (Fact * Size) - 1);
        P := PChar(Result);
        B := @Buf;
        for I := 0 to Size -1 do begin
            P[I * Fact]     := HexTable[(Ord(B[I]) shr 4) and 15];
            P[I * Fact + 1] := HexTable[Ord(B[I]) and 15];
            if (I < Size -1) then
                P[I * Fact + 2] := Separator;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsBufferToHex(const Buf; Size: Integer): String;
const
    Fact = 2;
var
    I : Integer;
    P : PChar;
    B : PAnsiChar;
begin
    if Size <= 0 then
        Result := ''
    else begin
        SetLength(Result, (Fact * Size));
        P := PChar(Result);
        B := @Buf;
        for I := 0 to Size -1 do begin
            P[I * Fact]     := HexTable[(Ord(B[I]) shr 4) and 15];
            P[I * Fact + 1] := HexTable[Ord(B[I]) and 15];
        end;
    end;    
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCharInSysCharSet(Ch : WideChar; const ASet : TSysCharSet) : Boolean;
begin
    Result := (Ord(Ch) < 256) and (AnsiChar(Ch) in ASet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCharInSysCharSet(Ch : AnsiChar; const ASet : TSysCharSet) : Boolean;
begin
    Result := Ch in ASet;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : WideChar) : Boolean;
begin
    Result := (Ch >= '0') and (Ch <= '9');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : AnsiChar) : Boolean;
begin
    Result := Ch in ['0'..'9'];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpace(Ch : WideChar) : Boolean;
begin
    Result := (Ch = ' ') or (Ch = #9);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpace(Ch : AnsiChar) : Boolean;
begin
    Result := Ch in [' ', #9];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCRLF(Ch : WideChar) : Boolean;
begin
    Result := (Ch = #10) or (Ch = #13);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCRLF(Ch : AnsiChar) : Boolean;
begin
    Result := Ch in [#10, #13];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpaceOrCRLF(Ch : WideChar) : Boolean;
begin
    Result := (Ch = ' ') or (Ch = #9) or (Ch = #10) or (Ch = #13);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpaceOrCRLF(Ch : AnsiChar) : Boolean;
begin
    Result := Ch in [' ', #9, #10, #13];

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function stpblk(PValue : PWideChar) : PWideChar;
begin
    Result := PValue;
    while IsSpaceOrCRLF(Result^) do
        Inc(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function stpblk(PValue : PAnsiChar) : PAnsiChar;
begin
    Result := PValue;
    while IsSpaceOrCRLF(Result^) do
        Inc(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsFindCloseW(var F: TIcsSearchRecW);
begin
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
        Windows.FindClose(F.FindHandle);
        F.FindHandle := INVALID_HANDLE_VALUE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindMatchingFileW(var F: TIcsSearchRecW): Integer;
var
    LocalFileTime : TFileTime;
begin
    with F do
    begin
        while FindData.dwFileAttributes and ExcludeAttr <> 0 do
            if not FindNextFileW(FindHandle, FindData) then
        begin
            Result := GetLastError;
            Exit;
        end;
        FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
        FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
        LongRec(Time).Lo);
        Size := FindData.nFileSizeLow;
        Attr := FindData.dwFileAttributes;
        Name := FindData.cFileName;
    end;
    Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindFirstW(const Path: UnicodeString; Attr: Integer;
  var  F: TIcsSearchRecW): Integer;
const
    faSpecial = faHidden or faSysFile or faDirectory;
begin
    F.ExcludeAttr := not Attr and faSpecial;
    F.FindHandle := FindFirstFileW(PWideChar(Path), F.FindData);
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
        Result := IcsFindMatchingFileW(F);
        if Result <> 0 then IcsFindCloseW(F);
    end else
        Result := GetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindFirstW(const Utf8Path: UTF8String; Attr: Integer;
  var  F: TIcsSearchRecW): Integer;
begin
    Result := IcsFindFirstW(AnsiToUnicode(Utf8Path, CP_UTF8), Attr, F);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindNextW(var F: TIcsSearchRecW): Integer;
begin
    if FindNextFileW(F.FindHandle, F.FindData) then
        Result := IcsFindMatchingFileW(F)
    else
        Result := GetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCreateDirW(const Dir: UnicodeString): Boolean;
begin
    Result := CreateDirectoryW(PWideChar(Dir), nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCreateDirW(const Utf8Dir: UTF8String): Boolean; overload;
begin
    Result := CreateDirectoryW(PWideChar(AnsiToUnicode(Utf8Dir, CP_UTF8)), nil);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsForceDirectoriesW(Dir: UnicodeString): Boolean;
var
    E: EInOutError;
begin
    Result := True;
    if Length(Dir) = 0 then
    begin
        E := EInOutError.CreateRes(@SCannotCreateDir);
        E.ErrorCode := 3;
        raise E;
    end;
    Dir := IcsExcludeTrailingPathDelimiterW(Dir);
    if (Length(Dir) < 3) or IcsDirExistsW(Dir)
        or (IcsExtractFilePathW(Dir) = Dir) then Exit;
  Result := IcsForceDirectoriesW(IcsExtractFilePathW(Dir)) and IcsCreateDirW(Dir);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsForceDirectoriesW(Utf8Dir: UTF8String): Boolean;
begin
    Result := IcsForceDirectoriesW(AnsiToUnicode(Utf8Dir, CP_UTF8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const FileName: PWideChar): Boolean;
var
    Res : DWord;
begin
    Res := GetFileAttributesW(FileName);
    Result := (Res <> INVALID_HANDLE_VALUE) and
              ((Res and FILE_ATTRIBUTE_DIRECTORY) <> 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const FileName: UnicodeString): Boolean;
begin
    Result := IcsDirExistsW(PWideChar(FileName));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const Utf8FileName: UTF8String): Boolean; overload;
begin
    Result := IcsDirExistsW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RtlCompareUnicodeString(String1, String2: PUnicode_String;
  CaseInSensitive: Boolean): LongInt; stdcall;
begin
    { Supported OS: NT4 and better! }
    if _RtlCompareUnicodeString = nil then
    begin
        if hNtDll = 0 then
        begin
            hNtDll := GetModuleHandle('ntdll.dll');
            if hNtDll = 0 then
                RaiseLastOsError;
        end;
        _RtlCompareUnicodeString := GetProcAddress(hNtDll, 'RtlCompareUnicodeString');
        if _RtlCompareUnicodeString = nil then
            RaiseLastOsError;
    end;
    Result := TRtlCompareUnicodeString(_RtlCompareUnicodeString)(
                                        String1, String2, CaseInsensitive);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Borrowed from Jordan Russell }
function IcsStrCompOrdinalW(Str1: PWideChar; Str1Length: Integer;
  Str2: PWideChar; Str2Length: Integer; IgnoreCase: Boolean): Integer;
var
    S1, S2: TUnicode_String;
    Len: Integer;
begin
    S1.Buffer := Str1;
    S2.Buffer := Str2;
    while True do
    begin
        if Str1Length <= Str2Length then
            Len := Str1Length
        else
            Len := Str2Length;
        if Len <= 0 then
            Break;
        // Can only process 32K characters at a time
        if Len > $7FF0 then
            Len := $7FF0;

        S1.Length        := Len * 2;   // Length is in bytes
        S1.MaximumLength := S1.Length;
        S2.Length        := S1.Length;
        S2.MaximumLength := S1.Length;
        Result := RtlCompareUnicodeString(@S1, @S2, IgnoreCase);
        if Result <> 0 then
            Exit;

        Dec(Str1Length, Len);
        Dec(Str2Length, Len);
        Inc(S1.Buffer, Len);
        Inc(S2.Buffer, Len);
    end;
    Result := Str1Length - Str2Length;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAnsiCompareFileNameW(const S1, S2: UnicodeString): Integer;
begin
    Result := IcsStrCompOrdinalW(PWideChar(S1), Length(S1), PWideChar(S2),
                             Length(S2), True);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAnsiCompareFileNameW(const Utf8S1, Utf8S2: UTF8String): Integer;
begin
    Result := IcsAnsiCompareFileNameW(AnsiToUnicode(Utf8S1, CP_UTF8),
                                      AnsiToUnicode(Utf8S2, CP_UTF8))
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrAllocW(Len: Cardinal): PWideChar;
begin
    Len := (Len * 2) + 4;
    GetMem(Result, Len);
    FillChar(Result^, Len, #0);
    Cardinal(Pointer(Result)^) := Len;
    Inc(Result, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrScanW(const Str: PWideChar; Ch: WideChar): PWideChar;
begin
    Result := Str;
    while Result^ <> Ch do
    begin
        if Result^ = #0 then
        begin
            Result := nil;
            Exit;
        end;
        Inc(Result);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsDelimiterW(const Delimiters: PWideChar;
  S : UnicodeString; Index: Integer): Boolean;
begin
    Result := False;
    if (Index <= 0) or (Index > Length(S)) then
        Exit;
    Result := IcsStrScanW(Delimiters, S[Index]) <> nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsLastDelimiterW(const Delimiters: PWideChar;
  S: UnicodeString): Integer;
begin
    Result := Length(S);
    while Result >= 0 do
    begin
        if (S[Result] <> #0) and (IcsStrScanW(Delimiters, S[Result]) <> nil) then
            Exit;
        Dec(Result);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFilePathW(const FileName: UnicodeString): UnicodeString;
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, FileName);
    Result := Copy(FileName, 1, I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileDirW(const FileName: UnicodeString): UnicodeString;
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, Filename);
    if (I > 1) and (FileName[I] = IcsPathDelimW) and
    (not IcsIsDelimiterW(IcsPathDriveDelimW, FileName, I - 1)) then
      Dec(I);
    Result :=Copy(FileName, 1, I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileDriveW(const FileName: UnicodeString): UnicodeString;
var
    I, J: Integer;
    Len : Integer;
begin
    Len := Length(FileName);
    if (Len >= 2) and (FileName[2] = DriveDelim) then
        Result := Copy(FileName, 1, 2)
    else if (Len >= 2) and (FileName[1] = PathDelim) and
            (FileName[2] = PathDelim) then
    begin
        J := 0;
        I := 3;
        while (I < Len) and (J < 2) do
        begin
            if FileName[I] = PathDelim then
                Inc(J);
            if J < 2 then
                Inc(I);
        end;
        if FileName[I] = PathDelim then
            Dec(I);
        Result := Copy(FileName, 1, I);
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileNameW(const FileName: UnicodeString): UnicodeString;
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, FileName);
    Result := Copy(FileName, I + 1, MaxInt);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileExtW(const FileName: UnicodeString): UnicodeString;
const
    Delim : PWideChar = '.\:';
var
    I: Integer;
begin
    I := IcsLastDelimiterW(Delim, FileName);
    if (I > 0) and (FileName[I] = '.') then
        Result := Copy(FileName, I, MaxInt)
    else
        Result := '';
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractNameOnlyW(FileName: UnicodeString): UnicodeString; // angus
var
  I: Integer;

  function IsPathSep (Ch: WideChar): Boolean;
  begin
    Result := (Ch = IcsPathDelimW) or (Ch = IcsDriveDelimW) or (Ch = '.');
  end;

begin
  FileName := IcsExtractFileNameW (FileName);  // remove path
  I := Length(FileName);
  while (I > 0) and not (IsPathSep (FileName[I])) do Dec(I);  // find .
  if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
  Result := Copy(FileName, 1, I - 1) ;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsChangeFileExtW(const FileName, Extension: UnicodeString): UnicodeString;  // angus
const
    Delim : PWideChar = '.\:';
var
  I: Integer;
begin
  I := IcsLastDelimiterW(Delim, Filename);
  if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrLenW(Str: PWideChar): Cardinal;
var
    BeginP : Pointer;
begin
    Result := 0;
    if Str <> nil then
    begin
        BeginP := Str;
        while Str^ <> #0 do
            Inc(Str);
        Result := (INT_PTR(Str) - INT_PTR(BeginP)) div 2;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExpandFileNameW(const FileName: UnicodeString): UnicodeString;
var
    Name: PWideChar;
    Buf: array[0..MAX_PATH - 1] of WideChar;
begin
    if GetFullPathNameW(PWideChar(FileName), Length(Buf), @Buf[0], Name) > 0 then
    begin
        SetLength(Result, IcsStrLenW(Buf));
        Move(Buf, Result[1], IcsStrLenW(Buf) * 2);
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIncludeTrailingPathDelimiterW(const S : UnicodeString): UnicodeString;
begin
    if (Length(S) > 0) and (S[Length(S)] <> IcsPathDelimW) then
        Result := S + IcsPathDelimW
    else
        Result := S;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExcludeTrailingPathDelimiterW(const S : UnicodeString): UnicodeString;
begin
   Result := S;
   if (Length(S) > 0) and (S[Length(S)] = IcsPathDelimW) then
        SetLength(Result, Length(Result) -1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDeleteFileW(const FileName: UnicodeString): Boolean;
begin
    Result := Windows.DeleteFileW(PWideChar(FileName));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractLastDir (const Path: RawByteString): RawByteString ;    // angus
var
    I, Len: integer;
begin
    Len := Length (Path);
    if Path [Len] = '\' then Dec (Len) ;
    for I := Len downto 1 do begin
        if Path [I] = '\' then begin
            Result := Copy (Path, I + 1, Len - I);
            exit;
        end;
    end;
    Result := Copy (Path, 1, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractLastDir (const Path: UnicodeString): UnicodeString ;     // angus
var
    I, Len: integer;
begin
    Len := Length (Path);
    if Path [Len] = '\' then Dec (Len) ;
    for I := Len downto 1 do begin
        if Path [I] = '\' then begin
            Result := Copy (Path, I + 1, Len - I);
            exit;
        end;
    end;
    Result := Copy (Path, 1, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDeleteFileW(const Utf8FileName: UTF8String): Boolean;
begin
    Result := Windows.DeleteFileW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileGetAttrW(const FileName: UnicodeString): Integer;
begin
    Result := GetFileAttributesW(PWideChar(FileName));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileGetAttrW(const Utf8FileName: UTF8String): Integer;
begin
    Result := GetFileAttributesW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileSetAttrW(const FileName: UnicodeString; Attr: Integer): Integer;
begin
    Result := 0;
    if not SetFileAttributesW(PWideChar(FileName), Attr) then
        Result := GetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileSetAttrW(const Utf8FileName: UTF8String; Attr: Integer): Integer;
begin
    Result := 0;
    if not SetFileAttributesW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)), Attr) then
        Result := GetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const FileName: UnicodeString): Integer;
begin
    Result := Integer(CreateFileW(PWideChar(FileName),
                                  GENERIC_READ or GENERIC_WRITE,
                                  0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const Utf8FileName: UTF8String): Integer;
begin
    Result := IcsFileCreateW(AnsiToUnicode(Utf8FileName, CP_UTF8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const FileName: UnicodeString; Rights: LongWord): Integer;
begin
    Result := IcsFileCreateW(FileName);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const Utf8FileName: UTF8String; Rights: LongWord): Integer;
begin
    Result := IcsFileCreateW(AnsiToUnicode(Utf8FileName, CP_UTF8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileOpenW(const FileName: UnicodeString; Mode: LongWord): Integer;
const
    AccessMode: array[0..2] of LongWord = (
                                            GENERIC_READ,
                                            GENERIC_WRITE,
                                            GENERIC_READ or GENERIC_WRITE);
    ShareMode: array[0..4] of LongWord = (
                                            0,
                                            0,
                                            FILE_SHARE_READ,
                                            FILE_SHARE_WRITE,
                                            FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
    Result := -1;
    if ((Mode and 3) <= fmOpenReadWrite) and
       ((Mode and $F0) <= fmShareDenyNone) then
    Result := Integer(CreateFileW(PWideChar(FileName),
                      AccessMode[Mode and 3],
                      ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL, 0));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

function IcsFileOpenW(const Utf8FileName: UTF8String; Mode: LongWord): Integer;
begin
    Result := IcsFileOpenW(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRemoveDirW(const Dir: UnicodeString): Boolean;
begin
    Result := RemoveDirectoryW(PWideChar(Dir));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRemoveDirW(const Utf8Dir: UTF8String): Boolean;
begin
    Result := RemoveDirectoryW(PWideChar(AnsiToUnicode(Utf8Dir, CP_UTF8)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRenameFileW(const OldName, NewName: UnicodeString): Boolean;
begin
    Result := MoveFileW(PWideChar(OldName), PWideChar(NewName));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRenameFileW(const Utf8OldName, Utf8NewName: UTF8String): Boolean;
begin
    Result := MoveFileW(PWideChar(AnsiToUnicode(Utf8OldName, CP_UTF8)),
                        PWideChar(AnsiToUnicode(Utf8NewName, CP_UTF8)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileAgeW(const FileName: UnicodeString): Integer;
var
    Handle        : THandle;
    FindData      : TWin32FindDataW;
    LocalFileTime : TFileTime;
begin
    Handle := FindFirstFileW(PWideChar(FileName), FindData);
    if Handle <> INVALID_HANDLE_VALUE then
    begin
        Windows.FindClose(Handle);
        if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
            FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
            if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
                LongRec(Result).Lo) then Exit;
        end;
    end;
    Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileAgeW(const Utf8FileName: UTF8String): Integer;
begin
    Result := IcsFileAgeW(AnsiToUnicode(Utf8FileName, CP_UTF8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileExistsW(const FileName: UnicodeString): Boolean;
begin
    Result := IcsFileAgeW(FileName) <> -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileExistsW(const Utf8FileName: UTF8String): Boolean;
begin
    Result := IcsFileAgeW(Utf8FileName) <> -1;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Note: despite the name, this is a full Unicode function changing non-ANSI characters }
function IcsAnsiLowerCaseW(const S: UnicodeString): UnicodeString;
var
  Len: Integer;
begin
    Len := Length(S);
    SetString(Result, PWideChar(S), Len);
    if Len > 0 then CharLowerBuffW(Pointer(Result), Len);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Note: despite the name, this is a full Unicode function changing non-ANSI characters }
function IcsAnsiUpperCaseW(const S: UnicodeString): UnicodeString;
var
  Len: Integer;
begin
    Len := Length(S);
    SetString(Result, PWideChar(S), Len);
    if Len > 0 then CharUpperBuffW(Pointer(Result), Len);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ TIcsFileStreamW }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const FileName: UnicodeString; Mode: Word);
begin
    Create(Filename, Mode, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const FileName: UnicodeString; Mode: Word;
  Rights: Cardinal);
begin
    if Mode = fmCreate then
    begin
        inherited Create(IcsFileCreateW(FileName));
        if Cardinal(FHandle) = INVALID_HANDLE_VALUE then
        {$IFDEF COMPILER12_UP}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [ExpandFileName(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ELSE}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [IcsExpandFileNameW(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ENDIF}

    end
    else begin
        inherited Create(IcsFileOpenW(FileName, Mode));
        if Cardinal(FHandle) = INVALID_HANDLE_VALUE then
        {$IFDEF COMPILER12_UP}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [ExpandFileName(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ELSE}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [IcsExpandFileNameW(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ENDIF}
    end;
    FFileName := FileName;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const Utf8FileName: UTF8String;
  Mode: Word);
begin
    Create(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const Utf8FileName: UTF8String; Mode: Word;
  Rights: Cardinal);
begin
    Create(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode, Rights);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsFileStreamW.Destroy;
begin
    if Integer(FHandle) >= 0 then
        FileClose(FHandle);
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TIcsIntegerList }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.Add(Item: Integer): Integer;
begin
    Result := FList.Add(Pointer(Item));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Clear;
begin
    FList.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsIntegerList.Create;
begin
    FList := TList.Create;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Delete(Index: Integer);
begin
    FList.Delete(Index);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsIntegerList.Destroy;
begin
    FreeAndNil(FList);
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetCount: Integer;
begin
    Result := FList.Count;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetFirst: Integer;
begin
    Result := Integer(FList.First);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetLast: Integer;
begin
    Result := Integer(FList.Last);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetItem(Index: Integer): Integer;
begin
    Result := Integer(FList[Index]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.SetItem(Index: Integer; const Value: Integer);
begin
    FList[Index] := Pointer(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.IndexOf(Item: Integer): Integer;
var
    I : Integer;
begin
    for I := 0 to FList.Count -1 do
    begin
        if Integer(FList[I]) = Item then
        begin
            Result := I;
            Exit;
        end;
    end;
    Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Assign(Source: TIcsIntegerList);
var
    I: Integer;
begin
    Clear;
    if Assigned(Source) then
        for I := 0 to Source.Count -1 do
            Add(Source[I]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.
