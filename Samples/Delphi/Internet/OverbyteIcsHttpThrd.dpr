program OverbyteIcsHttpThrd;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpThr1 in 'OverbyteIcsHttpThr1.pas' {HttpThreadForm},
  OverbyteIcsHttpThr2 in 'OverbyteIcsHttpThr2.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THttpThreadForm, HttpThreadForm);
  Application.Run;
end.
