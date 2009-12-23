program OverbyteIcsDemoTemplate;

uses
  Forms,
  OverbyteIcsDemoTemplate1 in 'OverbyteIcsDemoTemplate1.pas' {TemplateForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTemplateForm, TemplateForm);
  Application.Run;
end.
