program OverbyteIcsHttpDmo;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpDmo1 in 'OverbyteIcsHttpDmo1.pas' {HttpToMemoForm};

{$R *.RES}

begin
  Application.CreateForm(THttpToMemoForm, HttpToMemoForm);
  Application.Run;
end.
