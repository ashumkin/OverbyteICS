program OverbyteIcsFtpMultipartDownload;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsFtpMultipartDownload1 in 'OverbyteIcsFtpMultipartDownload1.pas' {MultipartFtpDownloadForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMultipartFtpDownloadForm, MultipartFtpDownloadForm);
  Application.Run;
end.
