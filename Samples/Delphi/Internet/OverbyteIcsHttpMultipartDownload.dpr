program OverbyteIcsHttpMultipartDownload;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpMultipartDownload1 in 'OverbyteIcsHttpMultipartDownload1.pas' {MultipartHttpDownloadForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMultipartHttpDownloadForm, MultipartHttpDownloadForm);
  Application.Run;
end.
