program IcsUdpLstn;

uses
  FMX.Forms,
  IcsUdpLstn1 in 'IcsUdpLstn1.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
