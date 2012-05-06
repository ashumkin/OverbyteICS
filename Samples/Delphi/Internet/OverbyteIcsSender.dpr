program OverbyteIcsSender;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSender1 in 'OverbyteIcsSender1.pas' {SenderForm};

{$R *.RES}

begin
  Application.CreateForm(TSenderForm, SenderForm);
  Application.Run;
end.
