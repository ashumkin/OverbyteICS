program IcsWebServ;

uses
  FMX.Forms,
  OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  FMX.Types,
  IcsWebServ1 in 'IcsWebServ1.pas' {WebServForm},
  OverbyteIcsFormDataDecoder in '..\..\..\Source\OverbyteIcsFormDataDecoder.pas';

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := True;
  Application.CreateForm(TWebServForm, WebServForm);
  Application.Run;
end.
