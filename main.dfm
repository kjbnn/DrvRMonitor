inherited fmain: Tfmain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = #1044#1088#1072#1081#1074#1077#1088' '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 392
  ClientWidth = 469
  DoubleBuffered = True
  Font.Name = 'Tahoma'
  ExplicitWidth = 485
  ExplicitHeight = 430
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl [0]
    Left = 0
    Top = 0
    Width = 469
    Height = 392
    ActivePage = TabSheet5
    Align = alClient
    TabOrder = 0
    object TabSheet0: TTabSheet
      Caption = '0'
      ImageIndex = 4
      object DBGrid0: TDBGrid
        Left = 0
        Top = 0
        Width = 461
        Height = 364
        Align = alClient
        DataSource = dmSigma.dsTable1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheet1: TTabSheet
      Caption = '1'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 461
        Height = 364
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EVENTTIME'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BCP'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EVENT'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OBJ'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IDSOURCE'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ZONE'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAMEEVT'
            Title.Alignment = taCenter
            Width = 191
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAMEOBJ'
            Title.Alignment = taCenter
            Width = 224
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAMESOURCE'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAMEZON'
            Title.Alignment = taCenter
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OBJTYPE'
            Title.Alignment = taCenter
            Width = 39
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TCOTYPE'
            Title.Alignment = taCenter
            Width = 45
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TSOURCE'
            Title.Alignment = taCenter
            Width = 48
            Visible = True
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = '2'
      ImageIndex = 1
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 461
        Height = 364
        Align = alClient
        DataSource = dmSigma.DataSource2
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheet3: TTabSheet
      Caption = '3'
      ImageIndex = 2
      object DBGrid3: TDBGrid
        Left = 0
        Top = 0
        Width = 461
        Height = 364
        Align = alClient
        DataSource = dmSigma.DataSource3
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheet4: TTabSheet
      Caption = '4'
      ImageIndex = 3
      object Button3: TButton
        Left = 24
        Top = 208
        Width = 75
        Height = 25
        Caption = '1'
        TabOrder = 0
      end
      object Button4: TButton
        Left = 24
        Top = 239
        Width = 75
        Height = 25
        Caption = '2'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 24
        Top = 270
        Width = 75
        Height = 25
        Caption = '3'
        TabOrder = 2
        OnClick = Button5Click
      end
      object Button7: TButton
        Left = 24
        Top = 177
        Width = 75
        Height = 25
        Caption = '0'
        TabOrder = 3
        OnClick = Button7Click
      end
      object Memo1: TMemo
        Left = 120
        Top = 3
        Width = 338
        Height = 358
        TabOrder = 4
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'm'
      ImageIndex = 5
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 461
        Height = 345
        Align = alClient
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
        Strings.Strings = (
          'IP '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088'=localhost'
          #1041#1072#1079#1072' Techbase=localhost/3051:d:\Database\Techbase.gdb'
          #1041#1072#1079#1072' Passbase=localhost/3051:d:\Database\Passbase.gdb'
          'NetDevice=1'
          'BigDevice=1'
          #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1101#1083#1077#1084#1077#1085#1090'=0'
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
        ExplicitLeft = 3
        ExplicitTop = 50
        ColWidths = (
          210
          245)
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 345
        Width = 461
        Height = 19
        Panels = <
          item
            Text = #1057#1090#1072#1088#1090
            Width = 200
          end>
      end
    end
  end
  inherited InitTimer: TTimer
    Left = 296
    Top = 264
  end
  inherited TimerVisible: TTimer
    Left = 270
    Top = 264
  end
  inherited TimerStop: TTimer
    Left = 242
    Top = 264
  end
  object DBTimer: TTimer
    OnTimer = DBTimerTimer
    Left = 334
    Top = 264
  end
  object Table1Timer: TTimer
    Interval = 50
    OnTimer = Table1TimerTimer
    Left = 364
    Top = 104
  end
end
