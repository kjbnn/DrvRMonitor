object fmain: Tfmain
  Left = 0
  Top = 0
  ClientHeight = 476
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 424
    Height = 476
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet0: TTabSheet
      Caption = '0'
      ImageIndex = 4
      object DBGrid0: TDBGrid
        Left = 0
        Top = 0
        Width = 416
        Height = 448
        Align = alClient
        DataSource = fdm.DataSource4
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
        Width = 416
        Height = 448
        Align = alClient
        DataSource = fdm.DataSource1
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
        Width = 416
        Height = 448
        Align = alClient
        DataSource = fdm.DataSource2
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
        Width = 416
        Height = 448
        Align = alClient
        DataSource = fdm.DataSource3
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
      object RemoteHost: TEdit
        Left = 24
        Top = 30
        Width = 137
        Height = 21
        TabOrder = 0
        Text = 'localhost'
      end
      object Button1: TButton
        Left = 24
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Bk_p'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 24
        Top = 128
        Width = 75
        Height = 25
        Caption = 'Bk_w'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 24
        Top = 208
        Width = 75
        Height = 25
        Caption = '1'
        TabOrder = 3
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 24
        Top = 239
        Width = 75
        Height = 25
        Caption = '2'
        TabOrder = 4
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 24
        Top = 270
        Width = 75
        Height = 25
        Caption = '3'
        TabOrder = 5
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 167
        Top = 28
        Width = 75
        Height = 25
        Caption = 'Update'
        TabOrder = 6
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 24
        Top = 177
        Width = 75
        Height = 25
        Caption = '0'
        TabOrder = 7
        OnClick = Button7Click
      end
      object Button9: TButton
        Left = 24
        Top = 340
        Width = 75
        Height = 25
        Caption = 'GetConfig'
        TabOrder = 8
        OnClick = Button9Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'm'
      ImageIndex = 5
      object ValueListEditor1: TValueListEditor
        Left = 0
        Top = 0
        Width = 416
        Height = 201
        Align = alTop
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        Strings.Strings = (
          'IP '#1056#1091#1073#1077#1078' '#1052#1086#1085#1080#1090#1086#1088'=localhost'
          #1041#1072#1079#1072' Techbase=localhost:c:\Database\Techbase.gdb'
          #1041#1072#1079#1072' Passbase=localhost:c:\Database\Passbase.gdb'
          'Id '#1080#1084#1087#1086#1088#1090#1072' '#1101#1083#1077#1084#1077#1085#1090#1086#1074'=0'
          'NetDevice=1'
          'BigDevice=1'
          '=')
        TabOrder = 0
        TitleCaptions.Strings = (
          #1055#1072#1088#1072#1084#1077#1090#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          144
          266)
      end
      object Button8: TButton
        Left = 3
        Top = 207
        Width = 75
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072
        TabOrder = 1
        OnClick = Button8Click
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 429
        Width = 416
        Height = 19
        Panels = <
          item
            Text = #1057#1090#1072#1088#1090
            Width = 200
          end>
      end
      object Memo1: TMemo
        Left = 0
        Top = 147
        Width = 416
        Height = 282
        Align = alBottom
        TabOrder = 3
      end
    end
  end
end
