program OverbyteIcsFtpMultipartDownload;

{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms,
  OverbyteIcsFtpMultipartDownload1 in 'OverbyteIcsFtpMultipartDownload1.pas' {MultipartFtpDownloadForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMultipartFtpDownloadForm, MultipartFtpDownloadForm);
  Application.Run;
end.
