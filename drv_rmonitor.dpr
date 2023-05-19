program drv_rmonitor;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  main in 'main.pas' {fmain},
  dm in 'dm.pas' {fdm: TDataModule},
  cAppKsb in 'KSBLib\cAppKsb.pas',
  cBuilderAppKsb in 'KSBLib\cBuilderAppKsb.pas',
  cComm in 'KSBLib\cComm.pas',
  cMainKsb in 'KSBLib\cMainKsb.pas' {aMainKsb},
  connection in 'KSBLib\connection.pas',
  constants in 'KSBLib\constants.pas',
  cRights in 'KSBLib\cRights.pas',
  KSBParam in 'KSBLib\KSBParam.pas',
  NetService in 'KSBLib\NetService.pas',
  SharedBuffer in 'KSBLib\SharedBuffer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(Tfmain, fmain);
  Application.CreateForm(Tfdm, fdm);
  Application.Run;
end.
