program OverbyteIcsSslFtpServ;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSslFtpServ1 in 'OverbyteIcsSslFtpServ1.pas' {SslFtpServerForm};

{$R *.RES}

begin
  Application.CreateForm(TSslFtpServerForm, SslFtpServerForm);
  Application.Run;
end.
