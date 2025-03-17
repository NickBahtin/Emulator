inherited frmBalance: TfrmBalance
  inherited gvTable: TGridView
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 110
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
      end>
    Header.Sections = <
      item
        Alignment = taCenter
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 110
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
          end>
      end>
    Rows.Count = 5
    OnGetCellColors = gvTableGetCellColors
    OnGetCellText = gvTableGetCellText
    OnGetEditText = gvTableGetEditText
    OnSetEditText = gvTableSetEditText
  end
end
