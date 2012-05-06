program OverbyteIcsRecv;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsRecv1 in 'OverbyteIcsRecv1.pas' {RecvForm};

{$R *.RES}

begin
  Application.CreateForm(TRecvForm, RecvForm);
  Application.Run;
end.
