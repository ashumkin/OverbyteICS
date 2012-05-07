program OverbyteIcsDynCli;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsDynCli1 in 'OverbyteIcsDynCli1.pas' {DynCliForm};

{$R *.RES}

begin
  Application.CreateForm(TDynCliForm, DynCliForm);
  Application.Run;
end.
