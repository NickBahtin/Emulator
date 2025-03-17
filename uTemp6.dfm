inherited frmTemp6: TfrmTemp6
  inherited gvTable: TGridView
    Height = 205
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 70
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end
      item
        DefWidth = 40
      end
      item
        DefWidth = 40
      end>
    Header.Sections = <
      item
        Alignment = taCenter
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 70
      end
      item
        Alignment = taCenter
        Caption = #1047#1085#1072#1095#1077#1085#1080#1103
        Sections = <
          item
            Alignment = taCenter
            Caption = '1'
            Width = 40
          end
          item
            Caption = '2'
            Width = 40
          end
          item
            Caption = '3'
            Width = 40
          end
          item
            Caption = '4'
            Width = 40
          end
          item
            Caption = '5'
            Width = 40
          end
          item
            Caption = '6'
            Width = 40
          end
          item
            Caption = '7'
            Width = 40
          end
          item
            Caption = '8'
            Width = 40
          end>
      end>
    OnGetCellColors = gvTemperatureGetCellColors
    OnGetCellText = gvTemperatureGetCellText
    OnGetEditText = gvTemperatureGetEditText
    OnSetEditText = gvTemperatureSetEditText
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 224
    Width = 435
    Height = 41
    Align = alBottom
    TabOrder = 1
    object lbl1: TLabel
      Left = 144
      Top = 16
      Width = 77
      Height = 13
      Caption = #1060#1086#1088#1084#1072#1090' '#1086#1090#1074#1077#1090#1072
    end
    object lbl2: TLabel
      Left = 9
      Top = 16
      Width = 43
      Height = 13
      Caption = #1050#1072#1085#1072#1083#1086#1074
    end
    object edtAnswerFormat: TEdit
      Left = 225
      Top = 11
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '000.00'
    end
    object seChannelCount: TSpinEdit
      Left = 72
      Top = 11
      Width = 53
      Height = 22
      MaxValue = 8
      MinValue = 4
      TabOrder = 1
      Value = 6
      OnChange = seChannelCountChange
    end
    object cbPreambula: TComboBox
      Left = 384
      Top = 10
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '>'
      Items.Strings = (
        '>'
        '!%2.2X')
    end
  end
  inherited sbIO: TStatusBar
    Top = 205
  end
end
