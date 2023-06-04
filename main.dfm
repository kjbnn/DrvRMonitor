inherited fmain: Tfmain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = #1044#1088#1072#1081#1074#1077#1088' '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 401
  ClientWidth = 554
  DoubleBuffered = True
  Font.Name = 'Tahoma'
  ExplicitWidth = 570
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl [0]
    Left = 0
    Top = 0
    Width = 554
    Height = 382
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet4: TTabSheet
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      ImageIndex = 3
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 546
        Height = 354
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 561
      ExplicitHeight = 0
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 546
        Height = 354
        Align = alClient
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
        Strings.Strings = (
          '')
        TabOrder = 0
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ExplicitWidth = 550
        ColWidths = (
          210
          330)
      end
    end
  end
  object StatusBar1: TStatusBar [1]
    Left = 0
    Top = 382
    Width = 554
    Height = 19
    Panels = <
      item
        Text = #1057#1090#1072#1088#1090
        Width = 200
      end>
  end
  inherited InitTimer: TTimer
    Left = 476
    Top = 274
  end
  inherited TimerVisible: TTimer
    Left = 450
    Top = 274
  end
  inherited TimerStop: TTimer
    Left = 422
    Top = 274
  end
  object RefreshTimer: TTimer
    Interval = 100
    OnTimer = RefreshTimerTimer
    Left = 354
    Top = 274
  end
  object PopupMenu1: TPopupMenu
    Left = 284
    Top = 274
    object N1: TMenuItem
      Caption = #1058#1077#1089#1090#1086#1074#1086#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      OnClick = N1Click
    end
  end
end
