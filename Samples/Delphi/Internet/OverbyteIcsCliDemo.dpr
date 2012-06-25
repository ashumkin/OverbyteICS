program OverbyteIcsCliDemo;

{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsCliDemo1 in 'OverbyteIcsCliDemo1.pas' {ClientForm};

{$R *.RES}

begin
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
