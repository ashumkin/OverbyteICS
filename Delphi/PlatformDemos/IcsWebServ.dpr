program IcsWebServ;

uses
  FMX.Forms,
  FMX.Types,
  IcsWebServ1 in 'IcsWebServ1.pas' {WebServForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := True;
  Application.CreateForm(TWebServForm, WebServForm);
  Application.Run;
end.
