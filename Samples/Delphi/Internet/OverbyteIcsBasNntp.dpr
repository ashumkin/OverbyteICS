program OverbyteIcsBasNntp;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsBasNntp1 in 'OverbyteIcsBasNntp1.pas' {BasicNntpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBasicNntpForm, BasicNntpForm);
  Application.Run;
end.
