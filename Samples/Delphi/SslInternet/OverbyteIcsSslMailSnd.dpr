program OverbyteIcsSslMailSnd;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSslMailSnd1 in 'OverbyteIcsSslMailSnd1.pas' {SslSmtpTestForm};

{$R *.RES}

begin
  Application.CreateForm(TSslSmtpTestForm, SslSmtpTestForm);
  Application.Run;
end.
