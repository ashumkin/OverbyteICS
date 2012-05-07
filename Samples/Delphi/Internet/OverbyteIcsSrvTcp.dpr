program OverbyteIcsSrvTcp;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSrvTcp1 in 'OverbyteIcsSrvTcp1.pas' {GetGroupsForm},
  OverbyteIcsTcpCmd in 'OverbyteIcsTcpCmd.pas';

{$R *.RES}

begin
{$IFNDEF VER80}
  Application.Initialize;
{$ENDIF}
  Application.CreateForm(TGetGroupsForm, GetGroupsForm);
  Application.Run;
end.
