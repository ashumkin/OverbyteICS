program OverbyteIcsSocksTst;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSocksTst1 in 'OverbyteIcsSocksTst1.pas' {SocksTestForm};

{$R *.RES}

begin
  Application.CreateForm(TSocksTestForm, SocksTestForm);
  Application.Run;
end.
