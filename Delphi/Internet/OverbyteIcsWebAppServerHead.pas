{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels
Creation:     June 22, 2010
Description:  This source is part of WebAppServer demo application.
              The purpose is to make a HTTP/HTTPS HEAD request to some
              IPv4/IPv6 server and return the response. Includes a very simple
              'anti-robots' feature.
Version:      1.00
EMail:        francois.piette@overbyte.be    http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2009 by François PIETTE
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
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsWebAppServerHead;

interface

uses
    Windows, Classes, SysUtils, Math,
    OverbyteIcsHttpAppServer,
    OverbyteIcsWebAppServerUrlDefs,
    OverbyteIcsWebAppServerHttpHandlerBase,
    OverbyteIcsHttpSrv,
    OverbyteIcsHttpProt,
    OverbyteIcsWSocket;

type
    THeadOperator = (opAdd, opMinus);
    TUrlHandlerHead = class(TUrlHandlerBase)
    private
        FN1, FN2: Integer;
        FOp: THeadOperator;
        function GenerateMath: string;
        function VerifyMath(const S: string): Boolean;
    public
        procedure Execute; override;
    end;    

implementation

const
    sDefaultUrl         = 'http://ipv6.google.com';
    sDoCalc             = 'Please try to calculate the correct value';
    sHeadUrl            = 'HeadUrl';
    sEquals             = 'Equals';
    sResponse           = 'Response';
    sAnswerThisQuestion = 'Please answer this question: <br>';

procedure TUrlHandlerHead.Execute;
var
    Url, Equals, Response, s: string;
    { Make sure "USE_SSL" is defined in the project options.        }
    { If you still get a "unknown symbol" here Rebuild the project! }
    Cli : TSslHttpCli; { We want support for HTTP and HTTPS.        }
    I : Integer;
    ButtonPressed, AllHdrs: Boolean;
begin
    if NotLogged then  // Frees this object if not logged in.
        Exit;
    try
        Response := '';
        ExtractURLEncodedValue(Params, sHeadUrl, Url);
        ExtractURLEncodedValue(Params, sEquals, Equals);
        ExtractURLEncodedValue(Params, 'Submit', s);
        ButtonPressed := s <> '';
        ExtractURLEncodedValue(Params, 'AllHeaders', s);
        AllHdrs := s <> '';
        if Url = '' then
            Url := sDefaultUrl;
        if (SessionData.TempVar >= 0) and ButtonPressed and
           (Equals <> '') then begin
            if not VerifyMath(Equals) then begin
                AnswerPage('', NO_CACHE, UrlHeadForm, nil,
                          [sHeadUrl, Url,
                          sEquals, GenerateMath,
                          sResponse, sDoCalc]);
            end
            else begin
                Cli := TSslHttpCli.Create(Self);
                Cli.SslContext := TSslContext.Create(Cli);
                try
                    try
                        try
                            { Not neccessarily required, anyway }
                            if Pos('https', LowerCase(URL)) = 1 then
                                Cli.SslContext.InitContext;
                        except
                            { Make sure the OpenSSL libraries are in the path }
                            Response := 'HTTPS is currently not supported.';
                            AnswerPage('', NO_CACHE, UrlHeadForm, nil,
                                      [sHeadUrl, sDefaultUrl,
                                      sEquals, GenerateMath,
                                      sResponse, Response]);
                            Exit;
                        end;
                        Response         := 'Response for URL "' + Url + '":<br>';
                        Cli.Timeout      := 1000 * 10;
                        { IPv6 and IPv4, prefer IPv4 }
                        Cli.SocketFamily := sfAnyIPv4;
                        Cli.RequestVer   := '1.1';
                        Cli.URL          := Url;
                        Cli.Head; { Sync method, calls the message pump! }
                        if Cli.RcvdHeader.Count > 0 then begin
                            if not AllHdrs then
                                Response := Response + Cli.RcvdHeader[0]
                            else
                                for I := 0 to Cli.RcvdHeader.Count - 1 do
                                    Response := Response +
                                                Cli.RcvdHeader[I] + '<br>';
                        end
                        else
                            Response := Response + IntToStr(Cli.StatusCode) +
                                        ' ' +  Cli.ReasonPhrase;
                    except
                        Response := Response + IntToStr(Cli.StatusCode) + ' ' +
                                    Cli.ReasonPhrase;
                    end;
              finally
                  Cli.Free;
              end;

              { The Client might have gone, method Cli.Head processed messages }
              if not Assigned(Client) then
                  Exit;
              AnswerPage('', NO_CACHE, UrlHeadForm, nil,
                        [sHeadUrl, sDefaultUrl,
                        sEquals, GenerateMath,
                        sResponse, Response]);
            end;
        end
        else begin
            if ButtonPressed and (Equals = '') then
                Response := sDoCalc;
            AnswerPage('', NO_CACHE, UrlHeadForm, nil,
                      [sHeadUrl, Url,
                      sEquals, GenerateMath,
                      sResponse, Response]);
        end;
    finally
        Finish; { Make sure this object is freed }
    end;    
end;

function TUrlHandlerHead.GenerateMath: string;
begin
    FN1 := Random(10);
    FN2 := Random(10);
    FOp := THeadOperator(Random(2));
    if FOp = opAdd then begin
        Result := sAnswerThisQuestion +
                  IntToStr(FN1) + ' + ' + IntToStr(FN2) + ' equals ?';
        SessionData.TempVar := FN1 + FN2;
    end
    else begin
        Result := sAnswerThisQuestion +
                  IntToStr(Max(FN1, FN2)) + ' - ' +
                  IntToStr(Min(FN1,FN2)) + ' equals ?';
        SessionData.TempVar := Max(FN1, FN2) - Min(FN1, FN2);
    end;
end;

function TUrlHandlerHead.VerifyMath(const S: string): Boolean;
begin
    Result := StrToIntDef(S, 0) = SessionData.TempVar;
end;

end.

