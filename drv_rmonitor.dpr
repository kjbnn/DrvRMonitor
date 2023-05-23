program drv_rmonitor;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  main in 'main.pas' {fmain},
  Rostek in 'rostek.pas' {dmRostek: TDataModule},
  cAppKsb in 'KSBLib\cAppKsb.pas',
  cBuilderAppKsb in 'KSBLib\cBuilderAppKsb.pas',
  cComm in 'KSBLib\cComm.pas',
  cMainKsb in 'KSBLib\cMainKsb.pas' {aMainKsb},
  connection in 'KSBLib\connection.pas',
  constants in 'KSBLib\constants.pas',
  cRights in 'KSBLib\cRights.pas',
  KSBParam in 'KSBLib\KSBParam.pas',
  NetService in 'KSBLib\NetService.pas',
  SharedBuffer in 'KSBLib\SharedBuffer.pas',
  Sigma in 'Sigma.pas' {dmSigma: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TdmSigma, dmSigma);
  Application.CreateForm(TdmRostek, dmRostek);
  Application.CreateForm(Tfmain, fmain);
  Application.Run;
end.
