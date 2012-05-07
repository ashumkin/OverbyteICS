program OverbyteIcsNewsReader;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsNewsReader1 in 'OverbyteIcsNewsReader1.pas' {NNTPForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNNTPForm, NNTPForm);
  Application.Run;
end.
