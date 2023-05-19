object aMainKsb: TaMainKsb
  Left = 457
  Top = 244
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' ...'
  ClientHeight = 37
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object InitTimer: TTimer
    Enabled = False
    OnTimer = InitTimerTimer
    Left = 236
    Top = 4
  end
  object TimerVisible: TTimer
    Interval = 300
    OnTimer = TimerVisibleTimer
    Left = 264
    Top = 4
  end
  object TimerStop: TTimer
    Enabled = False
    OnTimer = TimerStopTimer
    Left = 292
    Top = 4
  end
end
