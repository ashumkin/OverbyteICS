program OverbyteIcsSysLogClientDemo;

uses
  Forms,
  OverbyteIcsSysLogClientDemo1 in 'OverbyteIcsSysLogClientDemo1.pas' {SysLogClientForm},
  OverbyteIcsSysLogClient in '..\Vc32\OverbyteIcsSysLogClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSysLogClientForm, SysLogClientForm);
  Application.Run;
end.
