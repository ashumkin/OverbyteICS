program OverbyteIcsSysLogClientDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSysLogClientDemo1 in 'OverbyteIcsSysLogClientDemo1.pas' {SysLogClientForm},
  OverbyteIcsSysLogDefs in '..\..\..\Source\OverbyteIcsSysLogDefs.pas',
  OverbyteIcsSysLogClient in '..\..\..\Source\OverbyteIcsSysLogClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSysLogClientForm, SysLogClientForm);
  Application.Run;
end.
