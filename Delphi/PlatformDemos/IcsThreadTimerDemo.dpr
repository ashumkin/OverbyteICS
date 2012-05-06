program IcsThreadTimerDemo;

uses
  FMX.Forms,
  FMX.Types,
  IcsThreadTimerDemo1 in 'IcsThreadTimerDemo1.pas' {IcsTimerDemoForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := TRUE;
  Application.CreateForm(TIcsTimerDemoForm, IcsTimerDemoForm);
  Application.Run;
end.
