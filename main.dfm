inherited fmain: Tfmain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = #1044#1088#1072#1081#1074#1077#1088' '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 316
  ClientWidth = 592
  DoubleBuffered = True
  Font.Name = 'Tahoma'
  PopupMenu = PopupMenu1
  ExplicitWidth = 608
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl [0]
    Left = 0
    Top = 0
    Width = 592
    Height = 297
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet4: TTabSheet
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      ImageIndex = 3
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 584
        Height = 269
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 5
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 584
        Height = 269
        Align = alClient
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goThumbTracking]
        Strings.Strings = (
          '')
        TabOrder = 0
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          210
          368)
      end
    end
  end
  object StatusBar1: TStatusBar [1]
    Left = 0
    Top = 297
    Width = 592
    Height = 19
    Panels = <
      item
        Text = #1057#1090#1072#1088#1090
        Width = 200
      end>
  end
  inherited InitTimer: TTimer
    Left = 346
    Top = 84
  end
  inherited TimerVisible: TTimer
    Left = 300
    Top = 84
  end
  inherited TimerStop: TTimer
    Left = 252
    Top = 84
  end
  object RefreshTimer: TTimer
    Interval = 100
    OnTimer = RefreshTimerTimer
    Left = 184
    Top = 84
  end
  object PopupMenu1: TPopupMenu
    Left = 124
    Top = 84
    object N1: TMenuItem
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1090#1077#1089#1090#1086#1074#1086#1077' KSB '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N_Stop: TMenuItem
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1082#1091' '#1057#1080#1075#1084#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      OnClick = N_StopClick
    end
    object N_One: TMenuItem
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1077#1077' '#1057#1080#1075#1084#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      OnClick = N_OneClick
    end
    object N_All: TMenuItem
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1074#1089#1077' '#1057#1080#1075#1084#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
      OnClick = N_AllClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1063#1090#1077#1085#1080#1077' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080
      OnClick = N3Click
    end
  end
  object UpdateConfigTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = UpdateConfigTimerTimer
    Left = 188
    Top = 128
  end
end
