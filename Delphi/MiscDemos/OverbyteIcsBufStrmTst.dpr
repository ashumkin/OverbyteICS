program OverbyteIcsBufStrmTst;

uses
  Forms,
  OverbyteIcsBufStrmTst1 in 'OverbyteIcsBufStrmTst1.pas' {BufStrmForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBufStrmForm, BufStrmForm);
  Application.Run;
end.
