program OverbyteIcsSnmpCliTst;

uses
  Forms,
  OverbyteIcsIniFiles in '..\..\..\Source\OverbyteIcsIniFiles.pas',
  OverbyteIcsSnmpCliTst1 in 'OverbyteIcsSnmpCliTst1.pas' {SnmpClientTestForm},
  OverbyteIcsAsn1Utils in '..\..\..\Source\OverbyteIcsAsn1Utils.pas',
  OverbyteIcsSnmpMsgs in '..\..\..\Source\OverbyteIcsSnmpMsgs.pas',
  OverbyteIcsSnmpCli in '..\..\..\Source\OverbyteIcsSnmpCli.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSnmpClientTestForm, SnmpClientTestForm);
  Application.Run;
end.
