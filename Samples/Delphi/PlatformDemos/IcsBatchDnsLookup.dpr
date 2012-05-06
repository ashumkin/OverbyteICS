program IcsBatchDnsLookup;

uses
  FMX.Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  IcsBatchDnsLookup1 in 'IcsBatchDnsLookup1.pas' {BatchDnsLookupForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBatchDnsLookupForm, BatchDnsLookupForm);
  Application.Run;
end.
