program OverbyteIcsClient5;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsCli5 in 'OverbyteIcsCli5.pas' {ClientForm};

{$R *.RES}

begin
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
