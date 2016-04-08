{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


Author:       Shumkin Alexey
Object:       TSslSmtpNTLMCli class adds full NTLM support to TSslSmtpCli
Creation:     08 April 2016
Version:      1.0.1
EMail:        http://github.com/ashumkin        Alex.Crezoff@gmail.com
Support:
Legal issues: Copyright (C) 2016 by Shumkin Alexey
              <Alex.Crezoff@gmail.com>

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
Feb 23, 2016 - Added TNtlmAuthSession2 and TSslSmtpNTLMCli classes

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF ICS_INCLUDE_MODE}
unit OverbyteIcsSmtpNTLMProt;
{$ENDIF}

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$H+}           { Use long strings                    }
{$J+}           { Allow typed constant to be modified }
{$I Include\OverbyteIcsDefs.inc}
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}
{$IFNDEF COMPILER7_UP}
    Bomb = 'No support for ancient compiler';
{$ENDIF}
{$IFDEF COMPILER12_UP}
    { These are usefull for debugging !}
    {$WARN IMPLICIT_STRING_CAST       ON}
    {$WARN IMPLICIT_STRING_CAST_LOSS  ON}
    {$WARN EXPLICIT_STRING_CAST       OFF}
    {$WARN EXPLICIT_STRING_CAST_LOSS  OFF}
{$ENDIF}
{$WARN SYMBOL_PLATFORM   OFF}
{$WARN SYMBOL_LIBRARY    OFF}
{$WARN SYMBOL_DEPRECATED OFF}
{$DEFINE USE_BUFFERED_STREAM}
{$IFDEF BCB}
    {$ObjExportAll On}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
    {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
    {$IFDEF RTL_NAMESPACES}Winapi.Messages{$ELSE}Messages{$ENDIF},
{$ENDIF}
    {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF},
    OverbyteIcsNtlmMsgs,
    OverbyteIcsNtlmSsp,
    OverbyteIcsSmtpProt;

type
  TNtlmAuthSession2 = class(TNtlmAuthSession)
  protected
    FOwner: TSslSmtpCli;
    function NtlmGenMessage1(const AHost, ADomain: string;
      ALmCompatLevel: Integer): Boolean;
    function NtlmGenMessage3(const AMessageType2, ADomain, AHost, AUsername, APassword: string;
      NtlmMsg2Info : TNTLM_Msg2_Info;
      ACodePage: Integer;
      ALmCompatLevel: Integer): Boolean;
  public
    procedure AfterConstruction; override;
  end;

  TSslSmtpNTLMCli = class(TSslSmtpCli) // define USE_SSL if not found TSslSmtpCli
  protected
    FNtlmAuth: TNtlmAuthSession2;
    procedure AuthNextNtlm; override;
    procedure DoAuthNtlm; override;
    function NtlmGetMessage1(const AHost, ADomain: string;
      ALmCompatLevel: Integer = 0): string;
    function NtlmGetMessage3(const AMessageType2, ADomain, AHost, AUsername, APassword: string;
      NtlmMsg2Info : TNTLM_Msg2_Info;
      ACodePage: Integer;
      ALmCompatLevel: Integer = 0): string;
  public
    constructor Create(AOwner : TComponent); override;
    procedure BeforeDestruction; override;
  end;

implementation

uses
  OverbyteIcsMimeUtils,
  OverbyteIcsSspi;

{ TNtlmAuthSession2 }

procedure TNtlmAuthSession2.AfterConstruction;
begin
  inherited;
  FOwner := nil;
end;

function TNtlmAuthSession2.NtlmGenMessage1(const AHost, ADomain: string;
  ALmCompatLevel: Integer): Boolean;
var
  Sec                 : TSecurityStatus;
  Lifetime            : LARGE_INTEGER;
  OutBuffDesc         : TSecBufferDesc;
  OutSecBuff          : TSecBuffer;
  ContextAttr         : Cardinal;
begin
  try
    CleanupLogonSession;

{$IFNDEF UNICODE}
    Sec := FPSFT^.AcquireCredentialsHandleA(nil,
                                           NTLMSP_NAME_A,
                                           SECPKG_CRED_OUTBOUND,
                                           nil,
                                           nil,
                                           nil,
                                           nil,
                                           FHCred,
                                           Lifetime);
{$ELSE}
    Sec := FPSFT^.AcquireCredentialsHandleW(nil,
                                           NTLMSP_NAME,
                                           SECPKG_CRED_OUTBOUND,
                                           nil,
                                           nil,
                                           nil,
                                           nil,
                                           FHCred,
                                           Lifetime);
{$ENDIF}
    if Sec < 0 then
    begin
      FAuthError := Sec;
  {$IFDEF DEBUG_EXCEPTIONS}
      raise Exception.CreateFmt('AcquireCredentials failed 0x%x', [Sec]);
  {$ELSE}
      Result := False;
      FState := lsDoneErr;
      Exit;
    {$ENDIF}
    end;
    FHaveCredHandle := TRUE;

    // prepare output buffer
    OutBuffDesc.ulVersion := SECBUFFER_VERSION;
    OutBuffDesc.cBuffers  := 1;
    OutBuffDesc.pBuffers  := @OutSecBuff;

    OutSecBuff.cbBuffer   := OverbyteIcsNtlmSsp.cbMaxMessage;
    OutSecBuff.BufferType := SECBUFFER_TOKEN;
    OutSecBuff.pvBuffer   := nil;

    Sec := FPSFT^.InitializeSecurityContextA(@FHCred,
                                       nil,
                                       '',
                                       0,
                                       0, SECURITY_NATIVE_DREP,
                                       nil,
                                       0,
                                       @FHCtx,
                                       @OutBuffDesc,
                                       ContextAttr,
                                       Lifetime);
    if Sec < 0 then
    begin
      FAuthError := Sec;
    {$IFDEF DEBUG_EXCEPTIONS}
      raise Exception.CreateFmt('Init context failed: 0x%x (%0:d)', [Sec]);
    {$ELSE}
      Result := False;
      FState := lsDoneErr;
      Exit;
    {$ENDIF}
    end;

    FHaveCtxHandle := TRUE;
    if(Sec = SEC_I_COMPLETE_NEEDED)
        or (Sec = SEC_I_COMPLETE_AND_CONTINUE) then
    begin
      if Assigned(FPSFT^.CompleteAuthToken) then
      begin
        Sec := FPSFT^.CompleteAuthToken(@FHCtx, @OutBuffDesc);
        if Sec < 0 then
        begin
          FAuthError := Sec;
        {$IFDEF DEBUG_EXCEPTIONS}
          raise Exception.CreateFmt('Complete failed: 0x%x', [Sec]);
        {$ELSE}
          Result := False;
          FState := lsDoneErr;
          Exit;
        {$ENDIF}
        end;
      end
      else
      begin
      {$IFDEF DEBUG_EXCEPTIONS}
        raise Exception.Create('CompleteAuthToken not supported.');
      {$ELSE}
        Result := False;
        FState := lsDoneErr;
        Exit;
      {$ENDIF}
      end;
    end;

    if (Sec <> SEC_I_CONTINUE_NEEDED)
        and (Sec <> SEC_I_COMPLETE_AND_CONTINUE) then
      FState := lsDoneOK
    else
    begin
      FState := lsInAuth;
      SetLength(FNtlmMessage, OutSecBuff.cbBuffer);
      System.Move(OutSecBuff.pvBuffer^, FNtlmMessage[1], OutSecBuff.cbBuffer);
      FNtlmMessage := Base64Encode(FNtlmMessage);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      FState := lsDoneErr;
      Result := False;
      FOwner.OnResponse(FOwner, Format('Error: %s: %s', [E.Message, AuthErrorDesc]));
    end;
  end
end;

function TNtlmAuthSession2.NtlmGenMessage3(const AMessageType2, ADomain, AHost, AUsername, APassword: string;
  NtlmMsg2Info : TNTLM_Msg2_Info;
  ACodePage: Integer;
  ALmCompatLevel: Integer): Boolean;
var
  Sec                 : TSecurityStatus;
  Lifetime            : LARGE_INTEGER;
  InBuffDesc          : TSecBufferDesc;
  OutBuffDesc         : TSecBufferDesc;
  InSecBuff           : TSecBuffer;
  OutSecBuff          : TSecBuffer;
  ContextAttr         : Cardinal;
  pHCtx               : PCtxtHandle;
begin
  try
    Result := False;
    if not FHaveCredHandle
        and not FHaveCtxHandle
        and (FState <> lsInAuth) then
    begin
      FOwner.OnResponse(FOwner, Format('FHaveCredHandle: %d; %FHaveCtxHandle: %d; FState: %d',
        [Ord(FHaveCredHandle), Ord(FHaveCtxHandle), Ord(FState)]));
      Exit;
    end;

    pHCtx := @FHCtx;
    InBuffDesc.ulVersion := SECBUFFER_VERSION;
    InBuffDesc.cBuffers := 1;
    InBuffDesc.pBuffers := @InSecBuff;
    InSecBuff.cbBuffer   := OverbyteIcsNtlmSsp.cbMaxMessage;
    InSecBuff.BufferType := SECBUFFER_TOKEN;
    InSecBuff.pvBuffer   := PChar(AMessageType2);

    OutBuffDesc.ulVersion := SECBUFFER_VERSION;
    OutBuffDesc.cBuffers := 1;
    OutBuffDesc.pBuffers := @OutSecBuff;
    OutSecBuff.cbBuffer   := OverbyteIcsNtlmSsp.cbMaxMessage;
    OutSecBuff.BufferType := SECBUFFER_TOKEN;
    OutSecBuff.pvBuffer   := nil;

    Sec := FPSFT^.InitializeSecurityContextA(@FHCred,
                                       pHCtx,
                                       '',
                                       0,
                                       0,
                                       SECURITY_NATIVE_DREP,
                                       @InBuffDesc,
                                       0,
                                       @FHCtx,
                                       @OutBuffDesc,
                                       ContextAttr,
                                       Lifetime);
    if Sec < 0 then begin
        FAuthError := Sec;
    {$IFDEF DEBUG_EXCEPTIONS}
        raise Exception.CreateFmt('Init context failed: 0x%x', [Sec]);
    {$ELSE}
        FState := lsDoneErr;
        Exit;
    {$ENDIF}
    end;

    FHaveCtxHandle := TRUE;
    if(Sec = SEC_I_COMPLETE_NEEDED) or
      (Sec = SEC_I_COMPLETE_AND_CONTINUE) then begin
        if Assigned(FPSFT^.CompleteAuthToken) then begin
            Sec := FPSFT^.CompleteAuthToken(@FHCtx, @OutBuffDesc);
            if Sec < 0 then begin
                FAuthError := Sec;
            {$IFDEF DEBUG_EXCEPTIONS}
                raise Exception.CreateFmt('Complete failed: 0x%x', [Sec]);
            {$ELSE}
                FState := lsDoneErr;
                Exit;
            {$ENDIF}
            end;
        end
        else begin
        {$IFDEF DEBUG_EXCEPTIONS}
            raise Exception.Create('CompleteAuthToken not supported.');
        {$ELSE}
            FState := lsDoneErr;
            Exit;
        {$ENDIF}
        end;
    end;

    FState := lsDoneOK;

    SetLength(FNtlmMessage, OutSecBuff.cbBuffer);
    System.Move(OutSecBuff.pvBuffer^, FNtlmMessage[1], OutSecBuff.cbBuffer);
    FNtlmMessage := Base64Encode(FNtlmMessage);
    Result := True;
  except
    on E: Exception do
    begin
      FState := lsDoneErr;
      Result := False;
      FOwner.OnResponse(FOwner, Format('Error: %s: %s', [E.Message, AuthErrorDesc]));
    end;
  end
end;

{ TSslSmtpNTLMCli }

procedure TSslSmtpNTLMCli.AuthNextNtlm;
var
  NtlmMsg2Info : TNTLM_Msg2_Info;
  NtlmMsg3     : String;
  LDomain, LUsername: string;
begin
  if FRequestResult <> 0 then begin
      if (FAuthType = smtpAuthAutoSelect) then begin
         { We fall back to AUTH CRAM-MD5 and see whether we succeed.   }
         if FRequestResult = 504 then begin
             FState := smtpInternalReady;
             ExecAsync(smtpAuth, 'AUTH CRAM-MD5', [334], AuthNextCramMD5);
         end
         else begin
             FErrorMessage  := '500 Authentication Type could not be determined.';
             TriggerRequestDone(FRequestResult);
         end;
      end
      else
          TriggerRequestDone(FRequestResult);
      Exit;
  end;

  if (Length(FLastResponse) < 5) then begin
      FLastResponse := '500 Malformed NtlmMsg2: ' + FLastResponse;
      SetErrorMessage;
      TriggerRequestDone(500);
      Exit;
  end;

  NtlmMsg2Info := NtlmGetMessage2(Copy(FLastResponse, 5, MaxInt));
  NtlmParseUserCode(FUsername, LDomain, LUsername);
  NtlmMsg3 := Self.NtlmGetMessage3(Copy(FLastResponse, 5, MaxInt), LDomain,
                              '',  // the Host param seems to be ignored
                              LUsername, FPassword,
                              NtlmMsg2Info,     { V7.39 }
                              CP_ACP,
                              FLmCompatLevel);  { V7.39 }
  FState := smtpInternalReady;
  ExecAsync(smtpAuth, NtlmMsg3, [235], nil);
end;

procedure TSslSmtpNTLMCli.BeforeDestruction;
begin
  FreeAndNil(FNtlmAuth);
  inherited;
end;

constructor TSslSmtpNTLMCli.Create(AOwner: TComponent);
begin
  inherited;
  FNtlmAuth := nil;
end;

procedure TSslSmtpNTLMCli.DoAuthNtlm;
begin
  ExecAsync(smtpAuth, 'AUTH NTLM ' + Self.NtlmGetMessage1('', '', FLmCompatLevel),
            [334], AuthNextNtlm); { V7.39 }
end;

function TSslSmtpNTLMCli.NtlmGetMessage1(const AHost, ADomain: string;
  ALmCompatLevel: Integer): string;
begin
  Result := EmptyStr;
  if not Assigned(FNtlmAuth) then
  begin
    FNtlmAuth := TNtlmAuthSession2.Create;
    FNtlmAuth.FOwner := Self;
  end;
  TriggerResponse('FNtlmAuth.NtlmGenMessage1');
  if FNtlmAuth.NtlmGenMessage1(AHost, ADomain, ALmCompatLevel) then
    Result := FNtlmAuth.NtlmMessage
  else
    TriggerResponse('FNtlmAuth.NtlmGenMessage1: NO!');
end;

function TSslSmtpNTLMCli.NtlmGetMessage3(const AMessageType2, ADomain, AHost,
  AUsername, APassword: string; NtlmMsg2Info: TNTLM_Msg2_Info; ACodePage,
  ALmCompatLevel: Integer): string;
begin
  Result := EmptyStr;
  Assert(Assigned(FNtlmAuth));
  TriggerResponse('FNtlmAuth.NtlmGenMessage3');
  if FNtlmAuth.NtlmGenMessage3(Base64Decode(AMessageType2), ADomain, AHost, AUsername, APassword,
      NtlmMsg2Info, ACodePage, ALmCompatLevel) then
    Result := FNtlmAuth.NtlmMessage
  else
    TriggerResponse('FNtlmAuth.NtlmGenMessage3: NO!');
end;

end.

