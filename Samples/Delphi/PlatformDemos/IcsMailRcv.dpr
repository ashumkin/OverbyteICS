program IcsMailRcv;

uses
  FMX.Forms, OverbyteIcsIniFiles in '..\..\OverbyteIcsIniFiles.pas',
  FMX.Types,
  IcsMailRcv1 in 'IcsMailRcv1.pas' {POP3ExcercizerForm},
  IcsMailRcv2 in 'IcsMailRcv2.pas' {MessageForm};

{$R *.res}

begin
  Application.Initialize;
  GlobalDisableFocusEffect := True;
  Application.CreateForm(TPOP3ExcercizerForm, POP3ExcercizerForm);
  Application.CreateForm(TMessageForm, MessageForm);
  Application.Run;
end.
