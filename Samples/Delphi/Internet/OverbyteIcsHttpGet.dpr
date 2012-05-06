program OverbyteIcsHttpGet;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpGet1 in 'OverbyteIcsHttpGet1.pas' {HttpGetForm};

{$R *.RES}

begin
  Application.CreateForm(THttpGetForm, HttpGetForm);
  Application.Run;
end.
