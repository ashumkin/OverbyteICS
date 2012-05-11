program OverbyteIcsSysLogServerDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSysLogServer in '..\..\..\Source\OverbyteIcsSysLogServer.pas',
  OverbyteIcsSysLogServerDemo1 in 'OverbyteIcsSysLogServerDemo1.pas' {SysLogServerForm},
  OverbyteIcsSysLogDefs in '..\..\..\Source\OverbyteIcsSysLogDefs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSysLogServerForm, SysLogServerForm);
  Application.Run;
end.
