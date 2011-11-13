program IcsCliDemo;

uses
  FMX.Forms,
  FMX.Types,
  IcsCliDemo1 in 'IcsCliDemo1.pas' {ClientForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := TRUE;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
