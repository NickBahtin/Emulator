object MDIChild: TMDIChild
  Left = 673
  Top = 312
  Width = 882
  Height = 595
  Caption = 'MDI Child'
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 866
    Height = 556
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088
      object pcControllers: TPageControl
        Left = 0
        Top = 36
        Width = 858
        Height = 492
        ActivePage = tsBIO
        Align = alClient
        TabOrder = 0
        object tsCounter: TTabSheet
          Caption = #1057#1095#1077#1090#1095#1080#1082#1080' ('#1043#1080#1076#1088#1086#1076#1080#1085#1072#1084#1080#1082#1072')'
          inline fCounter: TfrmCounter
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 412
            end
            inherited Panel1: TPanel
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsCounterEx: TTabSheet
          Caption = #1057#1095#1077#1090#1095#1080#1082#1080' ('#1051#1086#1075#1086#1084#1072#1089#1089')'
          ImageIndex = 1
          inline fCounterEx: TfrmCounterX
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 412
            end
            inherited Panel1: TPanel
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsFCD2: TTabSheet
          Caption = #1059#1055#1055
          ImageIndex = 3
          inline fFCD: TfrmFCD
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 412
            end
            inherited Panel1: TPanel
              Top = 431
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsScales: TTabSheet
          Caption = #1042#1077#1089#1086#1074#1086#1077' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1086
          ImageIndex = 3
          inline fScales: TfrmBalance
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 445
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsSuperBIO: TTabSheet
          Caption = #1044#1080#1089#1082#1088#1077#1090#1085#1099#1081' '#1074#1074#1086#1076' '#1074#1099#1074#1086#1076' ('#1043#1080#1076#1088#1086#1076#1080#1085#1072#1084#1080#1082#1072')'
          ImageIndex = 4
          inline fSuperBio: TfrmSuperBio
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 412
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
                  Alignment = taCenter
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
                      Alignment = taCenter
                      Caption = '2'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '3'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '4'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '5'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '6'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '7'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '8'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '9'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '10'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '11'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '12'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '13'
                      Width = 40
                    end>
                end>
            end
            inherited Panel1: TPanel
              Top = 431
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsTemp6: TTabSheet
          Caption = #1048#1079#1084#1077#1088#1077#1085#1080#1077' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1099' (6 '#1082#1072#1085#1072#1083#1086#1074')'
          ImageIndex = 5
          inline fTemp6: TfrmTemp6
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 404
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
                      Alignment = taCenter
                      Caption = '2'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '3'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '4'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '5'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '6'
                      Width = 40
                    end>
                end
                item
                  Width = 40
                end
                item
                  Width = 40
                end>
            end
            inherited pnl1: TPanel
              Top = 423
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsUI: TTabSheet
          Caption = #1058#1086#1082' / '#1053#1072#1087#1088#1103#1078#1077#1085#1080#1077
          ImageIndex = 6
          inline fUI: TfrmUI
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 420
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
                  Alignment = taCenter
                  DefWidth = 40
                end
                item
                  Alignment = taCenter
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
                      Alignment = taCenter
                      Caption = '2'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '3'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '4'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '5'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '6'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '7'
                      Width = 40
                    end
                    item
                      Alignment = taCenter
                      Caption = '8'
                      Width = 40
                    end>
                end>
            end
            inherited Panel1: TPanel
              Top = 439
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsValve: TTabSheet
          Caption = #1069#1083#1077#1082#1090#1088#1086#1079#1072#1076#1074#1080#1078#1082#1080
          ImageIndex = 7
          inline fValve: TfrmValve
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 445
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsVLT600: TTabSheet
          Caption = #1063#1072#1089#1090#1086#1090#1085#1080#1082' VLT'
          ImageIndex = 8
          inline fVLT6000: TfVLT6000
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 445
            end
            inherited sbIO: TStatusBar
              Width = 850
            end
          end
        end
        object tsIVTM: TTabSheet
          Caption = #1048#1042#1058#1052
          ImageIndex = 9
        end
        object tsKM5: TTabSheet
          Caption = 'KM5 ('#1058#1041#1053' '#1069#1085#1077#1088#1075#1086#1089#1077#1088#1074#1080#1089')'
          ImageIndex = 10
        end
        object tsRT2: TTabSheet
          Caption = #1056#1058'2/'#1056#1058'2'#1052' ('#1058#1041#1053' '#1069#1085#1077#1088#1075#1086#1089#1077#1088#1074#1080#1089')'
          ImageIndex = 11
        end
        object tsBIO: TTabSheet
          Caption = 'BIO'
          ImageIndex = 12
          inline fBIO: TfrmBio
            Left = 0
            Top = 0
            Width = 850
            Height = 464
            Align = alClient
            TabOrder = 0
            inherited gvTable: TGridView
              Width = 850
              Height = 412
            end
            inherited Panel1: TPanel
              Top = 431
              Width = 850
            end
            inherited sbIO: TStatusBar
              Width = 850
              Color = 16776176
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 858
        Height = 36
        Align = alTop
        TabOrder = 1
        object Label2: TLabel
          Left = 81
          Top = -2
          Width = 87
          Height = 13
          Caption = #1058#1080#1087' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088#1072
        end
        object Label1: TLabel
          Left = 1
          Top = -2
          Width = 31
          Height = 13
          Caption = #1040#1076#1088#1077#1089
        end
        object cbTypeOfController: TComboBox
          Left = 79
          Top = 12
          Width = 254
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088#1072
          OnChange = cbTypeOfControllerChange
          Items.Strings = (
            #1057#1095#1077#1090#1095#1080#1082#1080
            #1053#1086#1074#1099#1077' '#1089#1095#1077#1090#1095#1080#1082#1080
            #1059#1055#1055
            #1042#1077#1089#1099
            #1044#1080#1089#1082#1088#1077#1090#1085#1099#1077' '#1074#1093#1086#1076#1099' '#1074#1099#1093#1086#1076#1099
            #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1074#1093#1086#1076#1099' (Temp6)'
            #1040#1085#1072#1083#1086#1075#1086#1074#1099#1077' '#1074#1093#1086#1076#1099' ('#1058#1086#1082'/'#1053#1072#1087#1088#1103#1078#1077#1085#1080#1077')'
            #1069#1083#1077#1082#1090#1088#1086#1079#1072#1076#1074#1080#1078#1082#1080
            #1063#1072#1089#1090#1086#1090#1085#1080#1082' '#1044#1072#1085#1092#1086#1089#1089' VLT '#1089#1077#1088#1080#1080
            #1048#1042#1058#1052
            #1050#1052'5'
            #1056#1058'2/'#1056#1058'2'#1052
            #1044#1080#1089#1082#1088#1077#1090#1085#1099#1077' '#1074#1093#1086#1076#1099' '#1074#1099#1093#1086#1076#1099' (BIO)')
        end
        object seNetAddr: THexEdit
          Left = 0
          Top = 12
          Width = 75
          Height = 21
          NumBase = ebHex
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Validate = True
          Value = 0
          OnChange = seNetAddrChange
          AllowUnitedBase = True
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1058#1077#1088#1084#1080#1085#1072#1083
      ImageIndex = 1
      object sMacros: TSplitter
        Left = 732
        Top = 30
        Height = 448
        Align = alRight
        Visible = False
        OnCanResize = sMacrosCanResize
      end
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 858
        Height = 30
        BorderWidth = 1
        ButtonHeight = 23
        Color = clBtnFace
        Images = MainForm.ImageList1
        Indent = 5
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Wrapable = False
        object tbCleatLog: TToolButton
          Left = 5
          Top = 2
          Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1078#1091#1088#1085#1072#1083
          Caption = 'tbCleatLog'
          ImageIndex = 6
          OnClick = tbCleatLogClick
        end
        object tbSaveLog: TToolButton
          Left = 28
          Top = 2
          Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1078#1091#1088#1085#1072#1083
          ImageIndex = 8
          OnClick = tbSaveLogClick
        end
        object ToolButton3: TToolButton
          Left = 51
          Top = 2
          Width = 8
          Caption = 'ToolButton3'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object tbOpenPort: TToolButton
          Left = 59
          Top = 2
          ImageIndex = 18
          OnClick = tbOpenPortClick
        end
        object tbClosePort: TToolButton
          Left = 82
          Top = 2
          Enabled = False
          ImageIndex = 19
          OnClick = tbClosePortClick
        end
        object tbSetupPort: TToolButton
          Left = 105
          Top = 2
          ImageIndex = 10
          OnClick = tbSetupPortClick
        end
        object ToolButton1: TToolButton
          Left = 128
          Top = 2
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 11
          Style = tbsSeparator
        end
        object tbSUMM: TToolButton
          Left = 136
          Top = 2
          Caption = 'tbSUMM'
          ImageIndex = 30
          OnClick = tbSUMMClick
        end
        object tbSUMM16: TToolButton
          Left = 159
          Top = 2
          Caption = 'tbSUMM16'
          Enabled = False
          ImageIndex = 28
          Visible = False
        end
        object tbSUMMKM: TToolButton
          Left = 182
          Top = 2
          Caption = 'tbSUMMKM'
          Enabled = False
          ImageIndex = 29
          Visible = False
        end
        object tbSummMB: TToolButton
          Left = 205
          Top = 2
          Caption = 'tbSummMB'
          Enabled = False
          ImageIndex = 31
          Visible = False
        end
        object ToolButton2: TToolButton
          Left = 228
          Top = 2
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 32
          Style = tbsSeparator
        end
        object HEXBtn: TToolButton
          Left = 236
          Top = 2
          Hint = #1055#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1074' '#1089#1090#1088#1086#1082#1077' '#1086#1090#1087#1088#1072#1074#1082#1080
          Caption = 'HEX'
          ImageIndex = 36
          Style = tbsCheck
          OnClick = HexBtnClick
        end
        object ScrollBtn: TToolButton
          Left = 259
          Top = 2
          Caption = 'ScrollBtn'
          ImageIndex = 23
          Style = tbsCheck
        end
        object DopInfoBtn: TToolButton
          Left = 282
          Top = 2
          Caption = 'DopInfoBtn'
          ImageIndex = 27
          Style = tbsCheck
        end
      end
      object pnlSend: TPanel
        Left = 0
        Top = 478
        Width = 858
        Height = 31
        Align = alBottom
        TabOrder = 1
        Visible = False
        DesignSize = (
          858
          31)
        object CRBtn: TSpeedButton
          Left = 792
          Top = 5
          Width = 28
          Height = 23
          Hint = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1089#1080#1084#1074#1086#1083' '#13#10#1074#1086#1079#1074#1088#1072#1090#1072' '#1082#1072#1088#1090#1077#1090#1082#1080' (0x0D)'
          AllowAllUp = True
          Anchors = [akRight]
          GroupIndex = 1
          Caption = 'CR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOlive
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LFBtn: TSpeedButton
          Left = 822
          Top = 5
          Width = 28
          Height = 23
          Hint = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1089#1080#1084#1074#1086#1083' '#13#10#1087#1077#1088#1077#1074#1086#1076#1072' '#1089#1090#1088#1086#1082#1080' (0x0A) '
          AllowAllUp = True
          Anchors = [akRight]
          GroupIndex = 2
          Caption = 'LF'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOlive
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtSend: TEdit
          Left = 1
          Top = 5
          Width = 705
          Height = 21
          Hint = #1057#1090#1088#1086#1082#1072' '#1086#1090#1087#1088#1072#1074#1082#1080
          Anchors = [akLeft, akRight]
          PopupMenu = PopupMenu1
          TabOrder = 0
        end
        object btnSend: TButton
          Left = 716
          Top = 4
          Width = 74
          Height = 25
          Anchors = [akRight]
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnSendClick
        end
      end
      object ComTerminal: TRxRichEdit
        Left = 0
        Top = 30
        Width = 732
        Height = 448
        DrawEndPage = False
        Align = alClient
        Color = clGray
        TabOrder = 2
      end
      object gbMacros: TGroupBox
        Left = 735
        Top = 30
        Width = 123
        Height = 448
        Align = alRight
        Caption = #1052#1072#1082#1088#1086#1089#1099
        TabOrder = 3
        Visible = False
        object lbMacros: TListBox
          Left = 2
          Top = 15
          Width = 119
          Height = 431
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
          OnDblClick = lbMacrosDblClick
          OnKeyDown = lbMacrosKeyDown
          OnKeyUp = lbMacrosKeyUp
        end
        object edtMacros: TEdit
          Left = 6
          Top = 18
          Width = 114
          Height = 15
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          TabOrder = 1
          Visible = False
          OnExit = edtMacrosExit
          OnKeyDown = edtMacrosKeyDown
          OnKeyUp = edtMacrosKeyUp
        end
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 509
        Width = 858
        Height = 19
        Panels = <>
        Visible = False
      end
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadInterval = 500
    OnAfterOpen = ComPort1AfterOpen
    OnAfterClose = ComPort1AfterClose
    OnRxChar = ComPort1RxChar
    OnError = ComPort1Error
    Left = 448
    Top = 88
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.rtf'
    FileName = 'project'
    Filter = 'Log (*.txt)|*.txt|Colored Log (*.rtf)|*.rtf'
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1078#1091#1088#1085#1072#1083
    Left = 368
    Top = 80
  end
  object PopupMenu1: TPopupMenu
    Left = 604
    Top = 256
    object N1: TMenuItem
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      ShortCut = 13
      OnClick = btnSendClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1084#1072#1082#1088#1086#1089#1099
      ShortCut = 16397
      OnClick = N3Click
    end
  end
end
