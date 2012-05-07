program IcsWebAppServ;

uses
  FMX.Forms,
  OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  Fmx.Types,
  IcsWebAppServerMain in 'IcsWebAppServerMain.pas' {WebAppSrvForm},
  OverbyteIcsWebAppServerConfig in '..\Internet\OverbyteIcsWebAppServerConfig.pas',
  OverbyteIcsWebAppServerCounterView in '..\Internet\OverbyteIcsWebAppServerCounterView.pas',
  OverbyteIcsWebAppServerDataModule in '..\Internet\OverbyteIcsWebAppServerDataModule.pas' {WebAppSrvDataModule: TDataModule},
  OverbyteIcsWebAppServerHead in '..\Internet\OverbyteIcsWebAppServerHead.pas',
  OverbyteIcsWebAppServerHelloWorld in '..\Internet\OverbyteIcsWebAppServerHelloWorld.pas',
  OverbyteIcsWebAppServerHomePage in '..\Internet\OverbyteIcsWebAppServerHomePage.pas',
  OverbyteIcsWebAppServerHttpHandlerBase in '..\Internet\OverbyteIcsWebAppServerHttpHandlerBase.pas',
  OverbyteIcsWebAppServerLogin in '..\Internet\OverbyteIcsWebAppServerLogin.pas',
  OverbyteIcsWebAppServerSessionData in '..\Internet\OverbyteIcsWebAppServerSessionData.pas',
  OverbyteIcsWebAppServerUrlDefs in '..\Internet\OverbyteIcsWebAppServerUrlDefs.pas',
  Ics.Fmx.OverbyteIcsWebAppServerCounter in '..\Internet\Ics.Fmx.OverbyteIcsWebAppServerCounter.pas',
  Ics.Fmx.OverbyteIcsWebAppServerMailer in '..\Internet\Ics.Fmx.OverbyteIcsWebAppServerMailer.pas',
  OverbyteIcsFormDataDecoder in '..\..\..\Source\OverbyteIcsFormDataDecoder.pas';

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := TRUE;
  Application.CreateForm(TWebAppSrvForm, WebAppSrvForm);
  Application.CreateForm(TWebAppSrvDataModule, WebAppSrvDataModule);
  Application.Run;
end.
