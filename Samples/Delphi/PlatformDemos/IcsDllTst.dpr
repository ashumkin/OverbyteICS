program IcsDllTst;

uses
  FMX.Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  FMX.Types,
  IcsDllTst1 in 'IcsDllTst1.pas' {DllTestForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := True;
  Application.CreateForm(TDllTestForm, DllTestForm);
  Application.Run;
end.
