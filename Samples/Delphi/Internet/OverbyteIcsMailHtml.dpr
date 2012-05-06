program OverbyteIcsMailHtml;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsMailHtm1 in 'OverbyteIcsMailHtm1.pas' {HtmlMailForm};

{$R *.res}

begin
  {$IFNDEF VER80}Application.Initialize;{$ENDIF}
  Application.CreateForm(THtmlMailForm, HtmlMailForm);
  Application.Run;
end.

