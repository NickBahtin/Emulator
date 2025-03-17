inherited frmCounterX: TfrmCounterX
  inherited gvTable: TGridView
    Top = 33
    Height = 213
    Columns = <
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        DefWidth = 300
      end
      item
        Alignment = taCenter
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end
      item
        DefWidth = 100
      end>
    Header.Sections = <
      item
        Alignment = taCenter
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 300
      end
      item
        Alignment = taCenter
        Caption = #1047#1085#1072#1095#1077#1085#1080#1103
        Sections = <
          item
            Alignment = taCenter
            Caption = '1'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '2'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '3'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '4'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '5'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '6'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '7'
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = '8'
            Width = 100
          end>
      end>
    Rows.Count = 23
    OnCellClick = nil
    OnGetCellText = gvTableGetCellText
    OnGetEditText = gvTableGetCellText
    OnSetEditText = gvTableSetEditText
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 435
    Height = 33
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 112
      Top = 10
      Width = 86
      Height = 13
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1095#1077#1090#1072
    end
    object LED1: TLED
      Left = 208
      Top = 9
      Width = 18
      Height = 18
      HelpContext = 0
      LEDColor = LedGreen
      Lighted = False
      ToggleSet = []
      FlashTime = 0
      AutoToggle = True
      OnClick = LED1Click
    end
    object Label2: TLabel
      Left = 400
      Top = 10
      Width = 109
      Height = 13
      Caption = #1064#1091#1084'                         '#1043#1094
    end
    object cbHEX: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = #1042#1089#1077' '#1074' HEX'
      TabOrder = 0
    end
    object seNoise: TSpinEdit
      Left = 430
      Top = 6
      Width = 64
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
  object tmrStartStop: TTimer
    Enabled = False
    OnTimer = tmrStartStopTimer
    Left = 376
    Top = 56
  end
end
