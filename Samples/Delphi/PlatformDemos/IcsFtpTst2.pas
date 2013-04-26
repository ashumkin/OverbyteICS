unit IcsFtpTst2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, 
{$IF COMPILERVERSION >= 25}  
  FMX.StdCtrls,
{$IFEND}
  FMX.Forms, FMX.Layouts, FMX.ListBox;

type
  TDirectoryForm = class(TForm)
    DirListBox: TListBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DirectoryForm: TDirectoryForm;

implementation

{$R *.FMX}

end.
