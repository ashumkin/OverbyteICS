program OverbyteIcsDemoTemplate;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsDemoTemplate1 in 'OverbyteIcsDemoTemplate1.pas' {TemplateForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTemplateForm, TemplateForm);
  Application.Run;
end.
