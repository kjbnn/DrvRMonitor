program drv_rmonitor;

uses
  Vcl.Forms,
  main in 'main.pas' {fmain},
  dm in 'dm.pas' {fdm: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.Title := 'кекекеке';
  Application.CreateForm(Tfmain, fmain);
  Application.CreateForm(Tfdm, fdm);
  //  Application.Title:= 'erererer';
  Application.Run;
end.
