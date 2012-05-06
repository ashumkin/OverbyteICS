program OverbyteIcsSslWebServ;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSslWebServ1 in 'OverbyteIcsSslWebServ1.pas' {SslWebServForm};

{$R *.RES}

begin
  Application.CreateForm(TSslWebServForm, SslWebServForm);
  Application.Run;
end.
