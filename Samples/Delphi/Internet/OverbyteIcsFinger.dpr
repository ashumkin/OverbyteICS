program OverbyteIcsFinger;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsFinger1 in 'OverbyteIcsFinger1.pas' {FingerDemoForm};

{$R *.RES}

begin
  Application.CreateForm(TFingerDemoForm, FingerDemoForm);
  Application.Run;
end.
