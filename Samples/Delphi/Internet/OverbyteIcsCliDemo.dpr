program OverbyteIcsCliDemo;

{$R 'OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R 'OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsCliDemo1 in 'OverbyteIcsCliDemo1.pas' {ClientForm};

{$R *.RES}

begin
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
