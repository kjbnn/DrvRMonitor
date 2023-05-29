inherited fmain: Tfmain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = #1044#1088#1072#1081#1074#1077#1088' '#1056#1091#1073#1077#1078'-'#1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 382
  ClientWidth = 459
  DoubleBuffered = True
  Font.Name = 'Tahoma'
  ExplicitWidth = 475
  ExplicitHeight = 420
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl [0]
    Left = 0
    Top = 0
    Width = 459
    Height = 382
    ActivePage = TabSheet5
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 469
    ExplicitHeight = 392
    object TabSheet0: TTabSheet
      Caption = '0'
      ImageIndex = 4
      ExplicitWidth = 461
      ExplicitHeight = 364
      object DBGrid0: TDBGrid
        Left = 0
        Top = 0
        Width = 451
        Height = 354
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
      ExplicitWidth = 461
      ExplicitHeight = 364
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 451
        Height = 354
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
      ExplicitWidth = 461
      ExplicitHeight = 364
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 451
        Height = 354
        Align = alClient
        DataSource = dmSigma.dsUsr
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
      ExplicitWidth = 461
      ExplicitHeight = 364
      object DBGrid3: TDBGrid
        Left = 0
        Top = 0
        Width = 451
        Height = 354
        Align = alClient
        DataSource = dmSigma.dsPodraz
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
      ExplicitWidth = 461
      ExplicitHeight = 364
      object btUpdate: TButton
        Left = 14
        Top = 13
        Width = 75
        Height = 25
        Caption = 'Update'
        TabOrder = 0
        OnClick = btUpdateClick
      end
      object Memo1: TMemo
        Left = 113
        Top = 0
        Width = 338
        Height = 354
        Align = alRight
        TabOrder = 1
        ExplicitLeft = 120
        ExplicitTop = 3
        ExplicitHeight = 358
      end
      object Button1: TButton
        Left = 14
        Top = 44
        Width = 75
        Height = 25
        Caption = 'sent test'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'm'
      ImageIndex = 5
      ExplicitWidth = 461
      ExplicitHeight = 364
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 451
        Height = 335
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
        ColWidths = (
          210
          235)
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 335
        Width = 451
        Height = 19
        Panels = <
          item
            Text = #1057#1090#1072#1088#1090
            Width = 200
          end>
        ExplicitTop = 345
        ExplicitWidth = 461
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
  object RefreshTimer: TTimer
    Interval = 50
    OnTimer = RefreshTimerTimer
    Left = 364
    Top = 104
  end
end
