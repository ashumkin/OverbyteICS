program OverbyteIcsMsVerify;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsMsVerify1 in 'OverbyteIcsMsVerify1.pas' {MsVerifyForm},
  OverbyteIcsMsSslUtils in 'OverbyteIcsMsSslUtils.pas',
  WinCrypt in 'WinCrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMsVerifyForm, MsVerifyForm);
  Application.Run;
end.
