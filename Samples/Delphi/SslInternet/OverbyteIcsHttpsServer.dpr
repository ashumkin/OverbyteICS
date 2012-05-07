program OverbyteIcsHttpsServer;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsHttpsServer1 in 'OverbyteIcsHttpsServer1.pas' {HttpsSrvForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THttpsSrvForm, HttpsSrvForm);
  Application.Run;
end.
