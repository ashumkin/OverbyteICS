program OverbyteIcsHttpChk;

{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpChk1 in 'OverbyteIcsHttpChk1.pas' {CheckUrlForm};

{$R *.RES}

begin
  Application.CreateForm(TCheckUrlForm, CheckUrlForm);
  Application.Run;
end.
