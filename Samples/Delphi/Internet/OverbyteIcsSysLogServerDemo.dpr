program OverbyteIcsSysLogServerDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSysLogServerDemo1 in 'OverbyteIcsSysLogServerDemo1.pas' {SysLogServerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSysLogServerForm, SysLogServerForm);
  Application.Run;
end.
