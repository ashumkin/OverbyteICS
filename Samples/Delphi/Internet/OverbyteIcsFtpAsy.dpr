program OverbyteIcsFtpAsy;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsFtpAsy1 in 'OverbyteIcsFtpAsy1.pas' {FtpAsyncForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFtpAsyncForm, FtpAsyncForm);
  Application.Run;
end.
