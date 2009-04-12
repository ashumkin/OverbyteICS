{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels <arno.garrels@gmx.de>
Creation:     March 2009
Description:  Test of TBufferedFileStream class Delphi 7 and better.
Version:      1.00
EMail:        francois.piette@overbyte.be    http://www.overbyte.be
Support:      Unsupported code.
Legal issues: Copyright (C) 2009 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to François PIETTE. Use a nice stamp and mention your name,
                 street address, EMail address and any comment you like to say.

History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
 
unit OverbyteIcsBufStrmTst1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  OverbyteIcsTypes,
  OverbyteIcsStreams;

type
  TBufStrmForm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ButtonBufRead: TButton;
    ButtonRead: TButton;
    ButtonBufWrite: TButton;
    ButtonWrite: TButton;
    EditBufSize: TEdit;
    EditBlockSize: TEdit;
    EditFileName: TEdit;
    EditLoops: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure ButtonBufReadClick(Sender: TObject);
    procedure ButtonReadClick(Sender: TObject);
    procedure ButtonBufWriteClick(Sender: TObject);
    procedure ButtonWriteClick(Sender: TObject);
    procedure EditBlockSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBuf  : TBytes;
  public
  
  end;

var
  BufStrmForm: TBufStrmForm;

implementation

{$R *.dfm}

const
    DefaultBlockSize   = 1024;
    DefaultBufferSize  = 4096;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.ButtonBufReadClick(Sender: TObject);
var
    Strm : TBufferedFileStream;
    BlockSize : Integer;
    A, B, C : Int64;
begin
    Label1.Caption := '...';
    Label1.Update;
    BlockSize := StrToIntDef(EditBlockSize.Text, DefaultBlockSize);
    SetLength(FBuf, BlockSize);

    QueryPerformanceFrequency(A);
    QueryPerformanceCounter(B);

    Strm := TBufferedFileStream.Create(EditFileName.Text,
                                       fmOpenRead or fmShareDenyWrite,
                                       StrToIntDef(EditBufSize.Text,
                                       DefaultBufferSize));
    try
        while Strm.Read(FBuf[0], BlockSize) = BlockSize do;
    finally
        Strm.Free;
    end;

    QueryPerformanceCounter(C);
    Label1.Caption := 'Duration: ' + IntToStr((C - B) * 1000 div A);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.ButtonReadClick(Sender: TObject);
var
    Strm : TFileStream;
    BlockSize : Integer;
    A, B, C : Int64;
begin
    Label2.Caption := '...';
    Label2.Update;
    BlockSize := StrToIntDef(EditBlockSize.Text, DefaultBlockSize);
    SetLength(FBuf, BlockSize);

    QueryPerformanceFrequency(A);
    QueryPerformanceCounter(B);

    Strm := TFileStream.Create(EditFileName.Text, fmOpenRead or fmShareDenyWrite);
    try
        while Strm.Read(FBuf[0], BlockSize) = BlockSize do;
    finally
        Strm.Free;
    end;

    QueryPerformanceCounter(C);
    Label2.Caption := 'Duration: ' + IntToStr((C - B) * 1000 div A);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.ButtonBufWriteClick(Sender: TObject);
var
    Strm : TBufferedFileStream;
    BlockSize : Integer;
    A, B, C : Int64;
    I : Integer;
begin
    Label1.Caption := '...';
    Label1.Update;
    BlockSize := StrToIntDef(EditBlockSize.Text, DefaultBlockSize);
    SetLength(FBuf, BlockSize);
    FillChar(FBuf[0], BlockSize, 'A');

    QueryPerformanceFrequency(A);
    QueryPerformanceCounter(B);

    Strm := TBufferedFileStream.Create(EditFileName.Text, fmCreate,
                                       StrToIntDef(EditBufSize.Text,
                                       DefaultBufferSize));
    try
        for I := 1 to StrToIntDef(EditLoops.Text, 0) do
            Strm.Write(FBuf[0], BlockSize);
    finally
        Strm.Free;
    end;

    QueryPerformanceCounter(C);
    Label1.Caption := 'Duration: ' + IntToStr((C - B) * 1000 div A);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.ButtonWriteClick(Sender: TObject);
var
    Strm : TFileStream;
    BlockSize : Integer;
    A, B, C : Int64;
    I : Integer;
begin
    Label2.Caption := '...';
    Label2.Update;
    BlockSize := StrToIntDef(EditBlockSize.Text, DefaultBlockSize);
    SetLength(FBuf, BlockSize);
    FillChar(FBuf[0], BlockSize, 'A');

    QueryPerformanceFrequency(A);
    QueryPerformanceCounter(B);

    Strm := TFileStream.Create(EditFileName.Text, fmCreate);
    try
        for I := 1 to StrToIntDef(EditLoops.Text, 0) do
            Strm.Write(FBuf[0], BlockSize);
    finally
        Strm.Free;
    end;

    QueryPerformanceCounter(C);
    Label2.Caption := 'Duration: ' + IntToStr((C - B) * 1000 div A);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.EditBlockSizeChange(Sender: TObject);
var
    Size: Integer;
begin
    Size := StrToIntDef(EditBlockSize.Text, 0) * StrToIntDef(EditLoops.Text, 0);
    Label6.Caption := 'Write FileSize: ' + IntToStr(Size);
    Label6.Update;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBufStrmForm.FormCreate(Sender: TObject);
begin
    EditBlockSizeChange(nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.
