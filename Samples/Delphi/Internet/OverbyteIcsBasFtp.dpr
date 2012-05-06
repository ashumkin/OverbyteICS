program OverbyteIcsBasFtp;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsBasFtp1 in 'OverbyteIcsBasFtp1.pas' {BasicFtpClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBasicFtpClientForm, BasicFtpClientForm);
  Application.Run;
end.
