program OverbyteIcsSnmpCliTst;

uses
  Forms, OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSnmpCliTst1 in 'OverbyteIcsSnmpCliTst1.pas' {SnmpClientTestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSnmpClientTestForm, SnmpClientTestForm);
  Application.Run;
end.
