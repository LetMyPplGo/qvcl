require "vcl"
require "lfm"

testlfm = [[
object Form1: TForm1
  Left = 379
  Height = 393
  Top = 183
  Width = 495
  Caption = 'Form1'
  ClientHeight = 393
  ClientWidth = 495
  LCLVersion = '0.9.28.2'
  object Label1: TLabel
    Left = 16
    Height = 14
    Top = 18
    Width = 32
    Caption = 'Label1'
    ParentColor = False
  end
  object Shape1: TShape
    Left = 16
    Height = 65
    Top = 160
    Width = 65
  end
  object Shape2: TShape
    Left = 88
    Height = 65
    Top = 160
    Width = 65
    Shape = stCircle
  end
  object Edit1: TEdit
    Left = 56
    Height = 21
    Top = 16
    Width = 97
    TabOrder = 0
    Text = 'Edit1'
  end
  object GroupBox1: TGroupBox
    Left = 16
    Height = 96
    Top = 48
    Width = 137
    Caption = 'GroupBox1'
    ClientHeight = 78
    ClientWidth = 133
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 17
      Height = 17
      Top = 9
      Width = 83
      Caption = 'RadioButton1'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 17
      Height = 17
      Top = 34
      Width = 83
      Caption = 'RadioButton2'
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 168
    Height = 126
    Top = 18
    Width = 314
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    ClientHeight = 126
    ClientWidth = 314
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 280
      Height = 22
      Top = 14
      Width = 23
      Color = clBtnFace
      NumGlyphs = 0
    end
    object Button1: TButton
      Left = 16
      Height = 25
      Top = 14
      Width = 91
      Caption = 'Button1'
      TabOrder = 0
    end
    object ToggleBox1: TToggleBox
      Left = 16
      Height = 23
      Top = 56
      Width = 90
      Caption = 'ToggleBox1'
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 16
      Height = 30
      Top = 90
      Width = 91
      Caption = 'BitBtn1'
      TabOrder = 2
    end
    object ComboBox1: TComboBox
      Left = 134
      Height = 21
      Top = 16
      Width = 132
      ItemHeight = 13
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3'
        'Item 4'
      )
      TabOrder = 3
      Text = 'ComboBox1'
    end
    object ListBox1: TListBox
      Left = 192
      Height = 61
      Top = 54
      Width = 108
      Items.Strings = (
        'Item 1'
        'Item 2'
        'Item 3'
        'Item 4'
        'Item 5'
        'Item 6'
      )
      ItemHeight = 13
      TabOrder = 4
    end
  end
  object TrackBar1: TTrackBar
    Left = 286
    Height = 25
    Top = 200
    Width = 194
    Position = 0
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 286
    Height = 20
    Top = 163
    Width = 194
    Position = 50
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Height = 23
    Top = 370
    Width = 495
    Panels = <    
      item
        Width = 50
      end    
      item
        Width = 50
      end    
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Memo1: TMemo
    Left = 264
    Height = 119
    Top = 240
    Width = 216
    Lines.Strings = (
      'The licenses for most software are '
      'designed to take away your'
      'freedom to share and change it.  By '
      'contrast, the GNU General Public'
      'License is intended to guarantee your '
      'freedom to share and change free'
      'software--to make sure the software '
      'is '
      'free for all its users.  This'
      'General Public License applies to most '
      'of '
      'the Free Software'
      'Foundation''s software and to any '
      'other '
      'program whose authors commit to'
      'using it.  (Some other Free Software '
      'Foundation software is covered by'
      'the GNU Library General Public License '
      'instead.)  You can apply it to'
      'your programs, too.'
    )
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object EditButton1: TEditButton
    Left = 16
    Height = 21
    Top = 240
    Width = 216
    ButtonWidth = 23
    NumGlyphs = 1
    TabOrder = 7
    Text = 'EditButton'
  end
  object FileNameEdit1: TFileNameEdit
    Left = 16
    Height = 21
    Top = 272
    Width = 216
    DialogOptions = []
    FilterIndex = 0
    HideDirectories = False
    ButtonWidth = 23
    NumGlyphs = 0
    TabOrder = 8
  end
  object DirectoryEdit1: TDirectoryEdit
    Left = 16
    Height = 21
    Top = 304
    Width = 216
    ShowHidden = False
    ButtonWidth = 23
    NumGlyphs = 0
    TabOrder = 9
  end
  object DateEdit1: TDateEdit
    Left = 15
    Height = 21
    Top = 336
    Width = 217
    CalendarDisplaySettings = [dsShowHeadings, dsShowDayNames]
    OKCaption = 'OK'
    CancelCaption = 'Cancel'
    DateOrder = doNone
    ButtonWidth = 23
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000064000000640000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D69E
      72C4D3996EF4D19668FFCE9263FFCB8E5EFFC98A5BFFC78756FFC38452FFC384
      52FFC38452FFC38452FFC38452FFC38452FFBB7742B0FFFFFF00FFFFFF00D7A1
      75FFF8F2EDFFF7F0EAFFF6EDE6FFF4EAE2FFF3E7DEFFF1E4DBFFF0E2D8FFEAD6
      C8FFF2E5DCFFFAF4F1FFF9F3F0FFFAF5F2FFC58A5DFDFFFFFF00FFFFFF00D9A4
      7AFFF9F3EEFFEBD2BEFFFFFFFFFFEBD3BFFFFFFFFFFFEBD3C0FFFFFFFFFFEAC7
      ADFFECD9CDFFF1E4DBFFF9F3F0FFF9F2EFFFC68C5FFFFFFFFF00FFFFFF00DDA8
      7EFFF9F3EFFFEBD0BAFFEBD0BBFF75B57AFF75B57AFF75B57AFFEBD1BDFFEACD
      B5FFFAF4F0FFEBD9CCFFF1E4DBFFFAF4F1FFC68A5CFFFFFFFF00FFFFFF00DFAA
      82FFF9F3EFFFEACEB7FFFFFFFFFF75B57AFF94D49BFF74B579FFFFFFFFFFEACF
      BAFFFBF6F2FFFAF3F0FFEBD8CBFFF2E6DDFFC88D5FFFFFFFFF00FFFFFF00E1AE
      87FFFAF4F0FFEACBB2FFEACCB3FF75B57AFF74B579FF73B478FFEACEB7FF70B3
      75FF6FB274FF6EB172FFE8C8AEFFEAD7C9FFC48654FFFFFFFF00FFFFFF00E3B1
      8CFFFAF6F1FFEAC9AEFFFFFFFFFFEAC9B0FFFFFFFFFFE9CBB3FFFFFFFFFF6FB1
      73FF8ED295FF6BAF6FFFFFFFFFFFF1E5DBFFC68655FFFFFFFF00FFFFFF00E5B4
      8FFFFAF6F2FFE9C6AAFFE9C6ACFFEAC7ACFFE9C7ADFFE9C9AEFFE9C9B0FF6CB0
      71FF6AAF6EFF68AD6DFFE8CCB5FFF2E7DEFFC88A59FFFFFFFF00FFFFFF00E7B7
      94FFFBF7F4FFE9C3A6FFFFFFFFFFE8C4A9FFFFFFFFFFE9C6AAFFFFFFFFFFE8C7
      ACFFFFFFFFFFE8C8B0FFFFFFFFFFF7F1EBFFCB8F5FFFFFFFFF00FFFFFF00E9BA
      98FFFBF7F4FF65A4FFFF64A3FFFF62A2FFFF61A1FFFF5F9FFFFF5C9DFFFF5A9A
      FFFF5798FFFF5495FFFF5294FFFFFBF7F4FFCE9364FFFFFFFF00FFFFFF00EBBD
      9BFFFBF7F4FF64A4FFFF79BDFFFF75BBFFFF71B9FFFF6DB8FFFF68B3FFFF61B0
      FFFF5AABFFFF54A7FFFF3B7DFFFFFBF7F4FFD1976AFFFFFFFF00FFFFFF00ECBF
      9EFFFBF7F4FF65A4FFFF64A3FFFF60A0FFFF5D9EFFFF5899FFFF5496FFFF4D90
      FFFF478BFFFF4284FFFF3D7FFFFFFBF7F4FFD49B6FFFFFFFFF00FFFFFF00EEC1
      A1EBFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7
      F4FFFBF7F4FFFBF7F4FFFBF7F4FFFBF7F4FFD7A074F8FFFFFF00FFFFFF00EFC2
      A37EEFC1A2E3EDC09FFFEBBE9DFFEBBC9AFFE9BA96FFE7B793FFE6B590FFE4B2
      8CFFE2AF88FFE0AC84FFDDA980FFDCA57DFFDAA37ACAFFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    NumGlyphs = 0
    TabOrder = 10
  end
end
]]


-- parses and executes a lazarus form
loadstring("require \"vcl\"\n"..lfm.tolua(testlfm).."Form1:ShowModal()")()
