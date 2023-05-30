inherited fmain: Tfmain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = #1044#1088#1072#1081#1074#1077#1088' '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 434
  ClientWidth = 611
  DoubleBuffered = True
  Font.Name = 'Tahoma'
  ExplicitWidth = 627
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl [0]
    Left = 0
    Top = 0
    Width = 611
    Height = 415
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 810
    ExplicitHeight = 385
    object TabSheet4: TTabSheet
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      ImageIndex = 3
      ExplicitWidth = 802
      ExplicitHeight = 357
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 603
        Height = 387
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 802
        ExplicitHeight = 357
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 5
      ExplicitWidth = 802
      ExplicitHeight = 357
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 603
        Height = 387
        Align = alClient
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
        Strings.Strings = (
          'IP '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088'=localhost'
          #1041#1072#1079#1072' Techbase=localhost/3051:d:\Database\Techbase.gdb'
          #1041#1072#1079#1072' Passbase=localhost/3051:d:\Database\Passbase.gdb'
          'NetDevice=1'
          'BigDevice=1'
          #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1087#1086#1089#1077#1090#1080#1090#1077#1083#1100'=0'
          #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'=0'
          #1057#1086#1073#1099#1090#1080#1077'=0'
          #1055#1088#1072#1074#1080#1083#1086' '#1085#1091#1084#1077#1088#1072#1094#1080#1080' '#1086#1073#1098#1077#1082#1090#1086#1074'='
          #1060#1086#1088#1084#1072#1090' '#1080#1084#1077#1085#1080' '#1079#1086#1085#1099'='
          #1060#1086#1088#1084#1072#1090' '#1080#1084#1077#1085#1080' '#1058#1057'='
          ''
          ''
          '')
        TabOrder = 0
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ExplicitWidth = 608
        ExplicitHeight = 392
        ColWidths = (
          210
          387)
      end
    end
  end
  object StatusBar1: TStatusBar [1]
    Left = 0
    Top = 415
    Width = 611
    Height = 19
    Panels = <
      item
        Text = #1057#1090#1072#1088#1090
        Width = 200
      end>
    ExplicitTop = 385
    ExplicitWidth = 810
  end
  inherited InitTimer: TTimer
    Left = 416
    Top = 344
  end
  inherited TimerVisible: TTimer
    Left = 390
    Top = 344
  end
  inherited TimerStop: TTimer
    Left = 362
    Top = 344
  end
  object RefreshTimer: TTimer
    Interval = 100
    OnTimer = RefreshTimerTimer
    Left = 294
    Top = 344
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 344
    object N1: TMenuItem
      Caption = #1058#1077#1089#1090#1086#1074#1086#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      OnClick = N1Click
    end
  end
end
