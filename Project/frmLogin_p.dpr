program frmLogin_p;

uses
  Vcl.Forms,
  frmLogin_u in 'frmLogin_u.pas' {frmLogin},
  dm_u in 'dm_u.pas' {dm: TDataModule},
  frmClients_u in 'frmClients_u.pas' {frmClients},
  frmProperties_u in 'frmProperties_u.pas' {frmProperties},
  frmMenu_u in 'frmMenu_u.pas' {frmMenu},
  frmStats_u in 'frmStats_u.pas' {frmStats},
  frmAgents_u in 'frmAgents_u.pas' {frmAgents},
  clsProperty in 'clsProperty.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmClients, frmClients);
  Application.CreateForm(TfrmProperties, frmProperties);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmStats, frmStats);
  Application.CreateForm(TfrmAgents, frmAgents);
  Application.Run;
end.
