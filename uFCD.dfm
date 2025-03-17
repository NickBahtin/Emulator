inherited frmFCD: TfrmFCD
  inherited gvTable: TGridView
    Height = 213
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 200
      end
      item
        Alignment = taCenter
        DefWidth = 120
      end>
    Header.Sections = <
      item
        Alignment = taCenter
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 200
      end
      item
        Alignment = taCenter
        Caption = #1047#1085#1072#1095#1077#1085#1080#1103
        Width = 120
      end>
    Rows.Count = 10
    OnGetCellText = gvTableGetCellText
    OnGetEditText = gvTableGetCellText
    OnSetEditText = gvTableSetEditText
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 232
    Width = 435
    Height = 33
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 94
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1082#1072#1085#1072#1083#1072' '#1059#1055#1055
    end
    object seUPPNum: TSpinEdit
      Left = 107
      Top = 4
      Width = 54
      Height = 22
      MaxValue = 3
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = seUPPNumChange
    end
  end
  inherited sbIO: TStatusBar
    Top = 213
  end
  object tmrSwitchWithTime: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrSwitchWithTimeTimer
    Left = 384
    Top = 24
  end
end
