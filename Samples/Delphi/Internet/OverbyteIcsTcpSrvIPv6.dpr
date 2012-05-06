program OverbyteIcsTcpSrvIPv6;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsTcpSrv1IPv6 in 'OverbyteIcsTcpSrv1IPv6.pas' {TcpSrvForm};

{$R *.RES}

begin
  Application.CreateForm(TTcpSrvForm, TcpSrvForm);
  Application.Run;
end.
