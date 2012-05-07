program OverbyteIcsSrvDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSrvDemo1 in 'OverbyteIcsSrvDemo1.pas' {SrvForm},
  OverbyteIcsSrvDemo2 in 'OverbyteIcsSrvDemo2.pas' {CliForm};

{$R *.RES}

begin
  Application.CreateForm(TSrvForm, SrvForm);
  Application.Run;
end.
