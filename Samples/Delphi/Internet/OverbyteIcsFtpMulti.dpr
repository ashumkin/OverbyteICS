program OverbyteIcsFtpMulti;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsFtpMulti1 in 'OverbyteIcsFtpMulti1.pas' {FtpMultiForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFtpMultiForm, FtpMultiForm);
  Application.Run;
end.
