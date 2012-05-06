program OverbyteIcsHttpAsp;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpAsp1 in 'OverbyteIcsHttpAsp1.pas' {HttpTestForm};

{$R *.RES}

begin
  Application.CreateForm(THttpTestForm, HttpTestForm);
  Application.Run;
end.
