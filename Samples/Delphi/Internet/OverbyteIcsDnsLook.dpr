program OverbyteIcsDnsLook;


{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsDnsLook1 in 'OverbyteIcsDnsLook1.pas' {DnsLookupForm};

{$R *.RES}

begin
  Application.CreateForm(TDnsLookupForm, DnsLookupForm);
  Application.Run;
end.
