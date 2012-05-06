program OverByteIcsDnsResolver;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsDnsResolver1 in 'OverbyteIcsDnsResolver1.pas' {DnsResolverForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDnsResolverForm, DnsResolverForm);
  Application.Run;
end.
