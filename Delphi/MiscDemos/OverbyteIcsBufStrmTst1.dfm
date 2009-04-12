object BufStrmForm: TBufStrmForm
  Left = 318
  Top = 140
  Caption = 'TBufferedFileStream Performance Test'
  ClientHeight = 276
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 54
    Top = 40
    Width = 58
    Height = 13
    Caption = 'WriteLoops:'
  end
  object Label4: TLabel
    Left = 6
    Top = 14
    Width = 105
    Height = 13
    Caption = 'Read/Write BlockSize:'
  end
  object Label5: TLabel
    Left = 198
    Top = 14
    Width = 47
    Height = 13
    Caption = 'FileName:'
  end
  object Label6: TLabel
    Left = 198
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Label6'
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 66
    Width = 185
    Height = 189
    Caption = 'BufferedStream'
    TabOrder = 3
    DesignSize = (
      185
      189)
    object Label1: TLabel
      Left = 12
      Top = 80
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label7: TLabel
      Left = 12
      Top = 28
      Width = 53
      Height = 13
      Caption = 'BufferSize:'
    end
    object ButtonBufRead: TButton
      Left = 14
      Top = 148
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Read'
      TabOrder = 1
      OnClick = ButtonBufReadClick
    end
    object EditBufSize: TEdit
      Left = 68
      Top = 24
      Width = 53
      Height = 21
      TabOrder = 0
      Text = '4096'
    end
    object ButtonBufWrite: TButton
      Left = 96
      Top = 148
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Write'
      TabOrder = 2
      OnClick = ButtonBufWriteClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 198
    Top = 66
    Width = 185
    Height = 189
    Caption = 'Stream'
    TabOrder = 4
    DesignSize = (
      185
      189)
    object Label2: TLabel
      Left = 10
      Top = 78
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object ButtonRead: TButton
      Left = 14
      Top = 146
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Read'
      TabOrder = 0
      OnClick = ButtonReadClick
    end
    object ButtonWrite: TButton
      Left = 96
      Top = 146
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Write'
      TabOrder = 1
      OnClick = ButtonWriteClick
    end
  end
  object EditBlockSize: TEdit
    Left = 116
    Top = 10
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '1024'
    OnChange = EditBlockSizeChange
  end
  object EditFileName: TEdit
    Left = 248
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'xtestfile.txt'
  end
  object EditLoops: TEdit
    Left = 116
    Top = 36
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '9000'
    OnChange = EditBlockSizeChange
  end
end
