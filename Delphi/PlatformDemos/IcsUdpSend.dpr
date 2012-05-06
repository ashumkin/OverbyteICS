program IcsUdpSend;

uses
  FMX.Forms,
  IcsUdpSend1 in 'IcsUdpSend1.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
