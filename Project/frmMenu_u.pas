unit frmMenu_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  frmStats_u, frmAgents_u, frmClients_u, frmProperties_u;

type
  TfrmMenu = class(TForm)
    Label1: TLabel;
    btnAgents: TButton;
    btnClients: TButton;
    btnProperties: TButton;
    btnHelp: TBitBtn;
    btnClose: TBitBtn;
    btnStats: TButton;
    procedure btnAgentsClick(Sender: TObject);
    procedure btnClientsClick(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure btnStatsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bAdmin : boolean;
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

procedure TfrmMenu.btnAgentsClick(Sender: TObject);
begin
   frmAgents.ShowModal;
end;

procedure TfrmMenu.btnClientsClick(Sender: TObject);
begin
  frmClients.ShowModal;
end;

procedure TfrmMenu.btnCloseClick(Sender: TObject);
begin
  bAdmin := false;
end;

procedure TfrmMenu.btnPropertiesClick(Sender: TObject);
begin
  frmProperties.ShowModal;
end;

procedure TfrmMenu.btnStatsClick(Sender: TObject);
begin
  frmStats.ShowModal;
end;

procedure TfrmMenu.FormActivate(Sender: TObject);
begin
  if (bAdmin = true) then
  begin
    btnStats.Enabled := true;
  end;
end;

end.
