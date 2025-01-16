unit frmStats_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, dm_u;

type
  TfrmStats = class(TForm)
    rEdit: TRichEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cmbClientID: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    cmbPropertyID: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure cmbClientIDChange(Sender: TObject);
    procedure cmbPropertyIDChange(Sender: TObject);
  private
    { Private declarations }
    procedure populateClientCombo;
    procedure populatePropertyCombo;
  public
    { Public declarations }
  end;

var
  frmStats: TfrmStats;

implementation

{$R *.dfm}

{ TfrmStats }

procedure TfrmStats.cmbClientIDChange(Sender: TObject);
var
  i, iClientID : integer;
  sum : real;
begin
  i := 0;
  sum := 0;
  iClientID := StrToInt(cmbClientID.Items[cmbClientID.ItemIndex]);
  for i := 1 to High(dm.arrProperties) do
  begin
    if (iClientID = dm.arrProperties[i].getClientFK) then
    begin
      sum := sum + dm.arrProperties[i].getValue;
    end;
  end;
  rEdit.Lines.Clear;
  rEdit.Lines.Add('Value sum of Client ID [' + IntToStr(iClientID) + ']: ' + FloatToStrF(sum, ffCurrency, 6, 2));
end;

procedure TfrmStats.cmbPropertyIDChange(Sender: TObject);
var
  found : boolean;
  i : integer;
begin
  found := false;
  i := 0;
  while ((not dm.tblProperties.Eof) AND (found <> true)) do
  begin
    if (dm.tblProperties['PropertyID'] = StrToInt(cmbPropertyID.Items[cmbPropertyID.ItemIndex])) then
    begin
      if (dm.tblProperties['PropertyValue'] > dm.arrProperties[i].estimateMarketValue) then
      begin
        rEdit.Lines.Clear;
        rEdit.Lines.Add('Property [ID: ' + cmbPropertyID.Items[cmbPropertyID.ItemIndex] + '] is above estimated market value.');
      end
      else
      begin
        rEdit.Lines.Clear;
        rEdit.Lines.Add('Property [ID: ' + cmbPropertyID.Items[cmbPropertyID.ItemIndex] + '] is below estimated market value.');
      end;
      found := true;
    end;
    i := i + 1;
    dm.tblProperties.Next;
  end;
end;

procedure TfrmStats.FormActivate(Sender: TObject);
begin
//  populateClientCombo;
  while not dm.tblClients.Eof do
  begin
    cmbClientID.Items.Add(IntToStr(dm.tblClients['ClientID']));
    dm.tblClients.Next;
  end;
//  populatePropertyCombo;
  while not dm.tblProperties.Eof do
  begin
    cmbPropertyID.Items.Add(IntToStr(dm.tblProperties['PropertyID']));
    dm.tblProperties.Next;
  end;
end;

procedure TfrmStats.populateClientCombo;
begin
  while not dm.tblClients.Eof do
  begin
    cmbClientID.Items.Add(IntToStr(dm.tblClients['ClientID']));
    dm.tblClients.Next;
  end;
end;

procedure TfrmStats.populatePropertyCombo;
begin
  while not dm.tblProperties.Eof do
  begin
    cmbPropertyID.Items.Add(IntToStr(dm.tblProperties['PropertyID']));
    dm.tblProperties.Next;
  end;
end;

end.
