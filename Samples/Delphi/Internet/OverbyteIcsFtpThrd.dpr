program OverbyteIcsFtpThrd;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsFtpThrd1 in 'OverbyteIcsFtpThrd1.pas' {ThrdFtpForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TThrdFtpForm, ThrdFtpForm);
  Application.Run;
end.
