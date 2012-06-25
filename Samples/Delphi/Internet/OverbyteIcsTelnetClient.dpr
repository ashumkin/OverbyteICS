program OverbyteIcsTelnetClient;

{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsTelnetClient1 in 'OverbyteIcsTelnetClient1.pas' {TelnetForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTelnetForm, TelnetForm);
  Application.Run;
end.
