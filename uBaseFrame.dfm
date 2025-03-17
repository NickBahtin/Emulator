object BaseFrame: TBaseFrame
  Left = 0
  Top = 0
  Width = 435
  Height = 265
  Align = alClient
  TabOrder = 0
  object gvTable: TGridView
    Left = 0
    Top = 19
    Width = 435
    Height = 246
    Align = alClient
    AllowEdit = True
    Color = 16776176
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 70
      end
      item
        Alignment = taCenter
        DefWidth = 40
      end>
    Fixed.Count = 1
    Fixed.Font.Charset = DEFAULT_CHARSET
    Fixed.Font.Color = clNavy
    Fixed.Font.Height = -11
    Fixed.Font.Name = 'Tahoma'
    Fixed.Font.Style = []
    Fixed.GridFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    GridColor = clBlack
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
          end>
      end>
    Header.Synchronized = True
    ImageHighlight = False
    ParentFont = False
    Rows.Count = 3
    ShowCellTips = False
    TabOrder = 0
    OnCellClick = gvTableCellClick
  end
  object sbIO: TStatusBar
    Left = 0
    Top = 0
    Width = 435
    Height = 19
    Align = alTop
    Color = clMoneyGreen
    Panels = <
      item
        Text = #1042#1088#1077#1084#1103
        Width = 100
      end
      item
        Text = #1047#1072#1087#1088#1086#1089
        Width = 100
      end
      item
        Text = #1054#1090#1074#1077#1090
        Width = 300
      end>
  end
end
