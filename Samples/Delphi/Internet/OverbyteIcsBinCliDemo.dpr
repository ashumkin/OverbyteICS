program OverbyteIcsBinCliDemo;

{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsBinCliDemo1 in 'OverbyteIcsBinCliDemo1.pas' {BinClientForm};

{$R *.RES}

begin
  Application.CreateForm(TBinClientForm, BinClientForm);
  Application.Run;
end.
