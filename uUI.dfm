inherited frmUI: TfrmUI
  inherited gvTable: TGridView
    Height = 221
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 70
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
        DefWidth = 60
      end
      item
        Alignment = taCenter
      end
      item
        Alignment = taCenter
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
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '2'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '3'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '4'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '5'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '6'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = '7'
          end
          item
            Alignment = taCenter
            Caption = '8'
          end>
      end>
    OnGetCellColors = gvTableGetCellColors
    OnGetCellText = gvTableGetCellText
    OnGetEditText = gvTableGetEditText
    OnSetEditText = gvTableSetEditText
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 240
    Width = 435
    Height = 25
    Align = alBottom
    TabOrder = 1
    object cbOldFormat: TCheckBox
      Left = 5
      Top = 3
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = #1057#1090#1072#1088#1099#1081' '#1092#1086#1088#1084#1072#1090
      TabOrder = 0
    end
  end
  inherited sbIO: TStatusBar
    Top = 221
  end
end
