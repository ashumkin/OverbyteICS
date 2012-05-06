program OverbyteIcsBatchDnsLookup;

{$R 'OverbyteIcsCommonVersion.res' '..\Vc32\OverbyteIcsCommonVersion.rc'}
{$R 'OverbyteIcsXpManifest.res' '..\Vc32\OverbyteIcsXpManifest.rc'}

uses
  Forms,
  OverbyteIcsBatchDnsLookup1 in 'OverbyteIcsBatchDnsLookup1.pas' {BatchDnsLookupForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBatchDnsLookupForm, BatchDnsLookupForm);
  Application.Run;
end.
