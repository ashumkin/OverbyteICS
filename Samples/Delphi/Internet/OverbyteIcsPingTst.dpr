program OverbyteIcsPingTst;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsPingTst1 in 'OverbyteIcsPingTst1.pas' {PingTstForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPingTstForm, PingTstForm);
  Application.Run;
end.
