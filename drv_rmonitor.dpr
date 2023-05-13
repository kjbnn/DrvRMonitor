program drv_rmonitor;

uses
  Vcl.Forms,
  main in 'main.pas' {fmain},
  dm in 'dm.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfmain, fmain);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
