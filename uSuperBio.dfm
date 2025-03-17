inherited frmSuperBio: TfrmSuperBio
  inherited gvTable: TGridView
    Height = 213
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
      end
      item
        Alignment = taCenter
      end
      item
        Alignment = taCenter
      end
      item
        Alignment = taCenter
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
          end
          item
            Alignment = taCenter
            Caption = '9'
          end
          item
            Alignment = taCenter
            Caption = '10'
          end
          item
            Alignment = taCenter
            Caption = '11'
          end
          item
            Alignment = taCenter
            Caption = '12'
          end
          item
            Alignment = taCenter
            Caption = '13'
          end>
      end>
    OnDblClick = gvTableDblClick
    OnGetCellColors = gvTableGetCellColors
    OnGetCellText = gvTableGetCellText
    OnGetEditText = gvTableGetEditText
    OnSetEditText = gvTableSetEditText
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 232
    Width = 435
    Height = 33
    Align = alBottom
    TabOrder = 1
    object cbInputDublicateState: TCheckBox
      Left = 8
      Top = 5
      Width = 177
      Height = 17
      Alignment = taLeftJustify
      Caption = #1042#1093#1086#1076#1099' '#1076#1091#1073#1083#1080#1088#1091#1102#1090' '#1074#1099#1093#1086#1076#1099
      TabOrder = 0
    end
  end
  inherited sbIO: TStatusBar
    Top = 213
  end
end
