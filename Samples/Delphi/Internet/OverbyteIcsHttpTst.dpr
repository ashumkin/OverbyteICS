program OverbyteIcsHttpTst;

{$R '..\..\..\Source\OverbyteIcsXpManifest.res' '..\..\..\Source\OverbyteIcsXpManifest.rc'}
{$R '..\..\..\Source\OverbyteIcsCommonVersion.res' '..\..\..\Source\OverbyteIcsCommonVersion.rc'}

uses
  Forms,
  OverbyteIcsHttpTst1 in 'OverbyteIcsHttpTst1.pas' {HttpTestForm};

{$R *.RES}

begin
{$IFNDEF VER80}
  Application.CreateForm(THttpTestForm, HttpTestForm);
  {$ENDIF}
  Application.Run;
end.
