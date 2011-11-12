program IcsFtpServ;

uses
  FMX.Forms,
  FMX.Types,
  IcsFtpServ1 in 'IcsFtpServ1.pas' {FtpServerForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := TRUE;
  Application.CreateForm(TFtpServerForm, FtpServerForm);
  Application.Run;
end.
