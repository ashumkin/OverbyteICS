program OverbyteIcsBinCliDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsBinCliDemo1 in 'OverbyteIcsBinCliDemo1.pas' {BinClientForm};

{$R *.RES}

begin
  Application.CreateForm(TBinClientForm, BinClientForm);
  Application.Run;
end.
