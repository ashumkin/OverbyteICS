program OverbyteIcsNsLookup;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsNsLookup1 in 'OverbyteIcsNsLookup1.pas' {NsLookupForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNsLookupForm, NsLookupForm);
  Application.Run;
end.
