unit OverbyteIcsRestJsonClientDemo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  // ICS components for HTTP access
  OverbyteIcsWndControl,
  OverbyteIcsHttpProt,
  OverbyteIcsUrl,
  // OpenSource JASON parser by Henri Gourvest.
  // Download from http://www.progdigy.com/?page_id=6
  SuperObject, Grids;

type
  TGoogleSearchJsonClientForm = class(TForm)
    HttpCli1: THttpCli;
    ToolsPanel: TPanel;
    DisplayMemo: TMemo;
    GoogleGetButton: TButton;
    GSearch: TEdit;
    Splitter1: TSplitter;
    ResultStringGrid: TStringGrid;
    procedure GoogleGetButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Display(Msg: String);
  end;

var
  GoogleSearchJsonClientForm: TGoogleSearchJsonClientForm;

implementation

{$R *.dfm}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TGoogleSearchJsonClientForm.FormCreate(Sender: TObject);
begin
    ResultStringGrid.ColCount    := 2;
    ResultStringGrid.RowCount    := 2;
    ResultStringGrid.Cells[0, 0] := 'visibleUrl';
    ResultStringGrid.Cells[1, 0] := 'unescapedUrl';
    ResultStringGrid.ColWidths[0] := 150;
    ResultStringGrid.ColWidths[1] := 600;
    DisplayMemo.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TGoogleSearchJsonClientForm.Display(Msg : String);
begin
    DisplayMemo.Lines.BeginUpdate;
    try
        if DisplayMemo.Lines.Count > 2000 then begin
            while DisplayMemo.Lines.Count > 2000 do
                DisplayMemo.Lines.Delete(0);
        end;
        DisplayMemo.Lines.Add(Msg);
    finally
        DisplayMemo.Lines.EndUpdate;
        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TGoogleSearchJsonClientForm.GoogleGetButtonClick(Sender: TObject);
const
    Zero : byte = 0;
var
    DataStream   : TMemoryStream;
    O            : ISuperObject;
    Item         : ISuperObject;
    Results      : ISuperObject;
    N            : Integer;
begin
    DisplayMemo.Clear;
    ResultStringGrid.RowCount := 2;
    GoogleGetButton.Enabled   := FALSE;
    DataStream                := TMemoryStream.Create;
    try
        DataStream.Clear;
        Display('Searching');
        // Google documentation is here: http://code.google.com/intl/en/apis/ajaxsearch/documentation/reference.html#_intro_fonje
        HttpCli1.URL := 'http://ajax.googleapis.com/ajax/services/search/web' +
                        '?rsz=large' +
                        '&v=1.0' +
                        '&q='+ UrlEncode(GSearch.Text);
        HttpCli1.RcvdStream := DataStream;
        try
            HttpCli1.Get;
        except
            on E:Exception do
                Display('Failed. ' + E.ClassName + ': ' + E.Message);
        end;
        if HttpCli1.StatusCode <> 200 then begin
            Display('  => Failed ' + IntToStr(HttpCli1.StatusCode) + ' ' +
                    HttpCli1.ReasonPhrase);
        end
        else begin
            O := TSuperObject.ParseStream(DataStream, TRUE);
// O.SaveTo('json.formatted.txt', TRUE, TRUE);
// O := TSuperObject.ParseFile('jason.data.txt', TRUE);
            if O.I['responseStatus'] <> 200 then
                Display('  => Failed ' +
                        O.S['responseStatus'] + ' ' +
                        O.S['responseDetails'])
            else begin
                Results := O['responseData.results'];
                if Results = nil then
                    Display('No result available')
                else begin
                    N := 1;
                    for Item in Results do begin
                        if ResultStringGrid.RowCount < N then
                            ResultStringGrid.RowCount := N + 1;
                        ResultStringGrid.Cells[0, N] := Item.S['visibleUrl'];
                        ResultStringGrid.Cells[1, N] := Item.S['unescapedUrl'];
                        Inc(N);
                    end;
                end;
            end;
        end;
    finally
        FreeAndNil(DataStream);
        GoogleGetButton.Enabled := TRUE;
        Display('Done');
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
