program OverbyteIcsMimeDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsMimeDemo1 in 'OverbyteIcsMimeDemo1.pas' {MimeDecodeForm};

{$R *.RES}

begin
  Application.CreateForm(TMimeDecodeForm, MimeDecodeForm);
  Application.Run;
end.
