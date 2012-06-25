program OverbyteIcsFtpServ;

{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsFtpServ1 in 'OverbyteIcsFtpServ1.pas' {FtpServerForm};

{$R *.RES}

begin
  Application.CreateForm(TFtpServerForm, FtpServerForm);
  Application.Run;
end.
