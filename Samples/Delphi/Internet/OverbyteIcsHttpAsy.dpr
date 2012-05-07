program OverbyteIcsHttpAsy;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpAsy1 in 'OverbyteIcsHttpAsy1.pas' {HttpAsyForm};

{$R *.RES}

begin
  Application.CreateForm(THttpAsyForm, HttpAsyForm);
  Application.Run;
end.
