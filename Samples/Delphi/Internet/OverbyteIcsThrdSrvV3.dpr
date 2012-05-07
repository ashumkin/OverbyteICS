program OverbyteIcsThrdSrvV3;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsThrdSrvV3_1 in 'OverbyteIcsThrdSrvV3_1.pas' {ThrdSrvForm};

{$R *.RES}

begin
  Application.CreateForm(TThrdSrvForm, ThrdSrvForm);
  Application.Run;
end.
