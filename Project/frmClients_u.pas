unit frmClients_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Buttons,
  frmProperties_u, dm_u, Vcl.Samples.Spin;

type
  TfrmClients = class(TForm)
    dbGrid: TDBGrid;
    pnlAdjustments: TPanel;
    dbNav: TDBNavigator;
    btnShowAll: TButton;
    edtSearch: TEdit;
    pnlMaintenance: TPanel;
    Label1: TLabel;
    pnlAgentInfo: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtClientName: TEdit;
    edtClientSurname: TEdit;
    edtClientGender: TEdit;
    edtClientAge: TEdit;
    edtClientCell: TEdit;
    Panel1: TPanel;
    btnClose: TBitBtn;
    btnCreate: TButton;
    btnDelete: TButton;
    btnHelp: TBitBtn;
    btnUpdate: TButton;
    rSort: TRadioGroup;
    rSortFields: TRadioGroup;
    procedure btnHelpClick(Sender: TObject);
    procedure dbNavClick(Sender: TObject; Button: TNavigateBtn);
    procedure btnShowAllClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rSortClick(Sender: TObject);
    procedure rSortFieldsClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    procedure sort(direction, field : integer; isQuery : boolean);
    procedure changeEdits();
    procedure formatDBGrid();
    procedure createDynamicPanel();
    procedure disableEverything;
    procedure enableEverything;
    procedure initDynamicCreate;
    procedure initDynamicUpdate;
    procedure initDynamicDelete;
    procedure btnCreateRecordClick(Sender: TObject);
    procedure btnUpdateRecordClick(Sender: TObject);
    procedure btnDeleteRecordClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmClients: TfrmClients;

  dynamicPanel : TPanel;
  lblName : TLabel;
  lblSurname : TLabel;
  lblGender : TLabel;
  lblAge : TLabel;
  lblCell : TLabel;
  lblID : TLabel;
  edtName : TEdit;
  edtSurname : TEdit;
  cmbGender : TComboBox;
  spnAge : TSpinEdit;
  edtCell : TEdit;
  edtID : TEdit;
  btnReset : TBitBtn;
  btnCreateRecord : TBitBtn;
  btnUpdateRecord : TBitBtn;
  btnDeleteRecord : TBitBtn;
  btnCancel : TBitBtn;

implementation

{$R *.dfm}

// General Functionality
// =---------------------------------------------------------------------------=
// Clears the search query. This makes the program show all the records in the
// table.
procedure TfrmClients.btnShowAllClick(Sender: TObject);
begin
  edtSearch.Text := '';
end;

// Dynamic Creation (Update)
// =---------------------------------------------------------------------------=
// Calls other procedures to create a dynamic component on the form. This
// dynamic component in in regards to updating a record in the table.
procedure TfrmClients.btnUpdateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicUpdate;
  disableEverything;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Updates the edits to display the information of the current record.
procedure TfrmClients.changeEdits;
begin
  edtClientName.Text := dm.tblClients['ClientName'];
  edtClientSurname.Text := dm.tblClients['ClientSurname'];
  edtClientGender.Text := dm.tblClients['ClientGender'];
  edtClientAge.Text := IntToStr(dm.tblClients['ClientAge']);
  edtClientCell.Text := dm.tblClients['ClientCell'];
end;

// Dynamic Initialization
// =---------------------------------------------------------------------------=
// Main boilerplate code to create dynamic elements on the form. Initializes all
// dynamic components/elements. Changes the form's width to allow the displaying
// of the dynamic components/elements.
procedure TfrmClients.createDynamicPanel;
begin
  dynamicPanel := TPanel.Create(frmClients);
  lblName := TLabel.Create(dynamicPanel);
  lblSurname := TLabel.Create(dynamicPanel);
  lblGender := TLabel.Create(dynamicPanel);
  lblAge := TLabel.Create(dynamicPanel);
  lblCell := TLabel.Create(dynamicPanel);
  lblID := TLabel.Create(dynamicPanel);
  edtName := TEdit.Create(dynamicPanel);
  edtSurname := TEdit.Create(dynamicPanel);
  cmbGender := TComboBox.Create(dynamicPanel);
  spnAge := TSpinEdit.Create(dynamicPanel);
  edtCell := TEdit.Create(dynamicPanel);
  edtID := TEdit.Create(dynamicPanel);
  btnReset := TBitBtn.Create(dynamicPanel);
  btnCreateRecord := TBitBtn.Create(dynamicPanel);
  btnUpdateRecord := TBitBtn.Create(dynamicPanel);
  btnDeleteRecord := TBitBtn.Create(dynamicPanel);
  btnCancel := TBitBtn.Create(dynamicPanel);

  frmClients.ClientWidth := 1100;
  with dynamicPanel do
  begin
    Parent := frmClients;
    Top := 8;
    Left := 819;
    Width := 273;
    Height := 514;
  end;
end;

// Dynamic Button Event Handler: [Clear Fields] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Resets all the fields on the dynamic component.
procedure TfrmClients.btnClearClick(Sender: TObject);
begin
  edtName.Text := '';
  edtSurname.Text := '';
  cmbGender.ItemIndex := -1;
  spnAge.Value := 18;
  edtCell.Text := '';
end;

// Dynamic Button Event Handler: [Create] (Applicable on dynamic Create)
// =---------------------------------------------------------------------------=
// Creates a new record with information gathered and adds it to the table.
procedure TfrmClients.btnCreateRecordClick(Sender: TObject);
var
  sName, sSurname, sCell : string;
begin
  sName := edtName.Text;
  sSurname := edtSurname.Text;
  sCell := edtCell.Text;
  if (dm.validName(sName) AND dm.validSurname(sSurname) AND dm.validCell(sCell)) then
  begin
    dm.tblClients.Last;
    dm.tblClients.Insert;
    dm.tblClients['ClientName'] := sName;
    dm.tblClients['ClientSurname'] := sSurname;
    dm.tblClients['ClientGender'] := cmbGender.Items[cmbGender.ItemIndex];
    dm.tblClients['ClientAge'] := spnAge.Value;
    dm.tblClients['ClientCell'] := sCell;
    dm.tblClients.Post;
    dm.tblClients.Refresh;
    ShowMessage('New record successfully created!');
    dynamicPanel.Free;
    enableEverything;
    frmClients.ClientWidth := 820;
  end
  else
  begin
    ShowMessage('Information entered was invalid. Please retry.');
  end;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specified record from the table.
procedure TfrmClients.btnDeleteClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicDelete;
  disableEverything;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specific record from the table.
procedure TfrmClients.btnDeleteRecordClick(Sender: TObject);
var
  iID : integer;
  found : boolean;
begin
  found := false;
  iID := StrToInt(edtID.Text);
  dm.tblClients.First;
  while not dm.tblClients.Eof do
  begin
    if (dm.tblClients['ClientID'] = iID) then
    begin
      found := true;
      dm.tblClients.Delete;
      dm.tblClients.Refresh;
      dm.tblClients.First;
      ShowMessage('Successfully deleted record!');
      dynamicPanel.Free;
      enableEverything;
      frmClients.ClientWidth := 820;
    end
    else
    begin
      dm.tblClients.Next;
    end;
  end;

  if (found <> true) then
  begin
    ShowMessage('Client ID was not found. Please retry with a valid ID.');
  end;
end;

// Dynamic Button Event Handler: [Update] (Applicable on dynamic Update)
// =---------------------------------------------------------------------------=
// Updates the current record with the information gathered from the user.
procedure TfrmClients.btnUpdateRecordClick(Sender: TObject);
var
  sName, sSurname, sCell : string;
begin
  sName := edtName.Text;
  sSurname := edtSurname.Text;
  sCell := edtCell.Text;
  if (dm.validName(sName) AND dm.validSurname(sSurname) AND dm.validCell(sCell)) then
  begin
    dm.tblClients.Edit;
    dm.tblClients['ClientName'] := sName;
    dm.tblClients['ClientSurname'] := sSurname;
    dm.tblClients['ClientGender'] := cmbGender.Items[cmbGender.ItemIndex];
    dm.tblClients['ClientAge'] := spnAge.Value;
    dm.tblClients['ClientCell'] := sCell;
    dm.tblClients.Post;
    dm.tblClients.Refresh;
    ShowMessage('Current record successfully updated!');
    dynamicPanel.Free;
    enableEverything;
    frmClients.ClientWidth := 820;
  end
  else
  begin
    ShowMessage('Information entered was invalid. Please retry.');
  end;
end;

// Dynamic Button Event Handler: [Cancel] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Removes the dynamic components/elements from the form. Resets the form to
// original width.
procedure TfrmClients.btnCancelClick(Sender: TObject);
begin
  dynamicPanel.Free;
  frmClients.ClientWidth := 820;
  enableEverything;
end;

// Quality of Life
// =---------------------------------------------------------------------------=
// Formats the DBGrid to allow for a more enjoyable user experience.
procedure TfrmClients.formatDBGrid;
begin
  dbGrid.Columns.Items[0].Width := 50;
  dbGrid.Columns.Items[1].Width := 100;
  dbGrid.Columns.Items[2].Width := 100;
  dbGrid.Columns.Items[3].Width := 100;
  dbGrid.Columns.Items[4].Width := 100;

  dbGrid.Columns.Items[0].Title.Alignment := TAlignment.taCenter;
  dbGrid.Columns.Items[1].Title.Alignment := TAlignment.taCenter;
  dbGrid.Columns.Items[2].Title.Alignment := TAlignment.taCenter;
  dbGrid.Columns.Items[3].Title.Alignment := TAlignment.taCenter;
  dbGrid.Columns.Items[4].Title.Alignment := TAlignment.taCenter;

  dbGrid.Columns.Items[0].Alignment := TAlignment.taLeftJustify;
  dbGrid.Columns.Items[1].Alignment := TAlignment.taLeftJustify;
  dbGrid.Columns.Items[2].Alignment := TAlignment.taLeftJustify;
  dbGrid.Columns.Items[3].Alignment := TAlignment.taLeftJustify;
  dbGrid.Columns.Items[4].Alignment := TAlignment.taLeftJustify;
end;

// Dynamic Creation (Create)
// =---------------------------------------------------------------------------=
// Main procedure for creating the dynamic component and adding all necessary or
// relevant elements onto it.
procedure TfrmClients.initDynamicCreate;
begin
  with lblName do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Name:';
  end;

  with lblSurname do
  begin
    Parent := dynamicPanel;
    Top := 80;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Surname:';
  end;

  with lblGender do
  begin
    Parent := dynamicPanel;
    Top := 144;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Gender:';
  end;

  with lblAge do
  begin
    Parent := dynamicPanel;
    Top := 208;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Age:';
  end;

  with lblCell do
  begin
    Parent := dynamicPanel;
    Top := 286;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Cell:';
  end;

  with edtName do
  begin
    Parent := dynamicPanel;
    Top := 39;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To create a new record please enter the name of the client here.';
    ShowHint := true;
  end;

  with edtSurname do
  begin
    Parent := dynamicPanel;
    Top := 103;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To create a new record please enter the surname of the client here.';
    ShowHint := true;
  end;

  with cmbGender do
  begin
    Parent := dynamicPanel;
    Top := 167;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Items.AddStrings(['Male','Female']);
    Hint := 'To create a new record please enter the gender of the client here.';
    ShowHint := true;
  end;

  with spnAge do
  begin
    Parent := dynamicPanel;
    Top := 231;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := 18;
    MinValue := 18;
    MaxValue := 100;
    Hint := 'To create a new record please enter the age of the client here.';
    ShowHint := true;
  end;

  with edtCell do
  begin
    Parent := dynamicPanel;
    Top := 309;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To create a new record please enter the cell of the client here.';
    ShowHint := true;
  end;

  with btnReset do
  begin
    Parent := dynamicPanel;
    Top := 340;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkRetry;
    Caption := '&Clear Fields';
    ModalResult := mrNone;
    OnClick := btnClearClick;
    Hint := 'Reset all fields in regards to creation of a new record.';
    ShowHint := true;
  end;

  with btnCreateRecord do
  begin
    Parent := dynamicPanel;
    Top := 381;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkOK;
    Default := true;
    Caption := '&Create';
    ModalResult := mrNone;
    OnClick := btnCreateRecordClick;
    Hint := 'Creates a new record with the information given.';
    ShowHint := true;
  end;

  with btnCancel do
  begin
    Parent := dynamicPanel;
    Top := 467;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkCancel;
    Caption := '&Cancel';
    ModalResult := mrNone;
    OnClick := btnCancelClick;
    Hint := 'Cancels the creation of a new record.';
    ShowHint := true;
  end;
end;

// Dynamic Creation (Delete)
// =---------------------------------------------------------------------------=
// Main procedure for creating the dynamic component and adding all necessary or
// relevant elements onto it.
procedure TfrmClients.initDynamicDelete;
begin
  with lblID do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client ID to delete:';
  end;

  with edtId do
  begin
    Parent := dynamicPanel;
    Top := 39;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To delete a specific record, please input the ID of the client here.';
    ShowHint := true;
  end;

  with btnDeleteRecord do
  begin
    Parent := dynamicPanel;
    Top := 381;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkOK;
    Default := true;
    Caption := '&Delete';
    ModalResult := mrNone;
    OnClick := btnDeleteRecordClick;
    Hint := 'Deletes the specified record.';
    ShowHint := true;
  end;

  with btnCancel do
  begin
    Parent := dynamicPanel;
    Top := 467;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkCancel;
    Caption := '&Cancel';
    ModalResult := mrNone;
    OnClick := btnCancelClick;
    Hint := 'Cancels the deletion of a specific record.';
    ShowHint := true;
  end;
end;

// Dynamic Creation (Update)
// =---------------------------------------------------------------------------=
// Main procedure for creating the dynamic component and adding all necessary or
// relevant elements onto it.
procedure TfrmClients.initDynamicUpdate;
begin
  with lblName do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Name:';
  end;

  with lblSurname do
  begin
    Parent := dynamicPanel;
    Top := 80;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Surname:';
  end;

  with lblGender do
  begin
    Parent := dynamicPanel;
    Top := 144;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Gender:';
  end;

  with lblAge do
  begin
    Parent := dynamicPanel;
    Top := 208;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Age:';
  end;

  with lblCell do
  begin
    Parent := dynamicPanel;
    Top := 286;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Client Cell:';
  end;

  with edtName do
  begin
    Parent := dynamicPanel;
    Top := 39;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := dm.tblClients['ClientName'];
    Hint := 'To update the current record, please change the name of the client here.';
    ShowHint := true;
  end;

  with edtSurname do
  begin
    Parent := dynamicPanel;
    Top := 103;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := dm.tblClients['ClientSurname'];
    Hint := 'To update the current record, please change the surname of the client here.';
    ShowHint := true;
  end;

  with cmbGender do
  begin
    Parent := dynamicPanel;
    Top := 167;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Items.AddStrings(['Male','Female']);
    ItemIndex := Items.IndexOf(dm.tblClients['ClientGender']);
    Hint := 'To update the current record, please change the gender of the client here.';
    ShowHint := true;
  end;

  with spnAge do
  begin
    Parent := dynamicPanel;
    Top := 231;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    MinValue := 18;
    MaxValue := 100;
    Value := dm.tblClients['ClientAge'];
    Hint := 'To update the current record, please change the age of the client here.';
    ShowHint := true;
  end;

  with edtCell do
  begin
    Parent := dynamicPanel;
    Top := 309;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := dm.tblClients['ClientCell'];
    Hint := 'To update the current record, please change the cell of the client here.';
    ShowHint := true;
  end;

  with btnReset do
  begin
    Parent := dynamicPanel;
    Top := 340;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkRetry;
    Caption := '&Clear Fields';
    ModalResult := mrNone;
    OnClick := btnClearClick;
    Hint := 'Reset all fields in regards to updating a record.';
    ShowHint := true;
  end;

  with btnUpdateRecord do
  begin
    Parent := dynamicPanel;
    Top := 381;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkOK;
    Default := true;
    Caption := '&Update';
    ModalResult := mrNone;
    OnClick := btnUpdateRecordClick;
    Hint := 'Updates the current record with the given information.';
    ShowHint := true;
  end;

  with btnCancel do
  begin
    Parent := dynamicPanel;
    Top := 467;
    Left := 16;
    Width := 241;
    Height := 35;
    Kind := bkCancel;
    Caption := '&Cancel';
    ModalResult := mrNone;
    OnClick := btnCancelClick;
    Hint := 'Cancels the updating of the current record.';
    ShowHint := true;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Calls the sorting procedure to sort the table according to the user's
// preferences.
procedure TfrmClients.rSortClick(Sender: TObject);
begin
  if (dbGrid.DataSource = dm.dsClientsQuery) then
  begin
    sort(rSort.ItemIndex, rSortFields.ItemIndex, true);
  end
  else
  begin
    sort(rSort.ItemIndex, rSortFields.ItemIndex, false);
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Calls the sorting procedure to sort the table according to the user's
// preferences.
procedure TfrmClients.rSortFieldsClick(Sender: TObject);
begin
  if (dbGrid.DataSource = dm.dsClientsQuery) then
  begin
    sort(rSort.ItemIndex, rSortFields.ItemIndex, true);
  end
  else
  begin
    sort(rSort.ItemIndex, rSortFields.ItemIndex, false);
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Allows the user to sort the table according to their liking. This can be
// ascending or descending by ClientID, ClientName, ClientSurname, etc. This
// implementaion also allows the user to sort the query result(s) from searching
procedure TfrmClients.sort(direction, field: integer; isQuery : boolean);
var
  sortStr : string;
begin
  sortStr := '';
  if (direction = 0) then
  begin
    case field of
      0: sortStr := 'ClientID ASC';
      1: sortStr := 'ClientName ASC';
      2: sortStr := 'ClientSurname ASC';
      3: sortStr := 'ClientGender ASC';
      4: sortStr := 'ClientAge ASC';
    end;
  end
  else
  begin
    case field of
      0: sortStr := 'ClientID DESC';
      1: sortStr := 'ClientName DESC';
      2: sortStr := 'ClientSurname DESC';
      3: sortStr := 'ClientGender DESC';
      4: sortStr := 'ClientAge DESC';
    end;
  end;
  if (isQuery) then
  begin
    dm.qryClients.Sort := sortStr;
  end
  else
  begin
    dm.tblClients.Sort := sortStr;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Whenever the user browses through the table, the relevant data is displayed
// in edits to give the user a better viewing experience.
procedure TfrmClients.dbNavClick(Sender: TObject; Button: TNavigateBtn);
begin
  changeEdits;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Disables all major functionality on the form. This is done to prevent the
// from causing edge cases where errors could occur.
procedure TfrmClients.disableEverything;
begin
  dbNav.Enabled := false;
  btnCreate.Enabled := false;
  btnUpdate.Enabled := false;
  btnDelete.Enabled := false;
  btnShowAll.Enabled := false;
  edtSearch.Enabled := false;
  rSort.Enabled := false;
  rSortFields.Enabled := false;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Renables all major functionality on the form.
procedure TfrmClients.enableEverything;
begin
  dbNav.Enabled := true;
  btnCreate.Enabled := true;
  btnUpdate.Enabled := true;
  btnDelete.Enabled := true;
  btnShowAll.Enabled := true;
  edtSearch.Enabled := true;
  rSort.Enabled := true;
  rSortFields.Enabled := true;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Allows the user to search through the table for a specific record. Any input
// is compared against the ClientName field. Changes the data source of the
// table to allow the viewing of the queried results. Disables the create,
// update, and delete buttons to eliminate errors and/or bugs.
procedure TfrmClients.edtSearchChange(Sender: TObject);
var
  input : string;
begin
  input := edtSearch.Text;
  if (Length(input) = 0) then
  begin
    dbGrid.DataSource := dm.dsClients;
    dbNav.DataSource := dm.dsClients;
    btnCreate.Enabled := true;
    btnUpdate.Enabled := true;
    btnDelete.Enabled := true;
  end
  else
  begin
    btnCreate.Enabled := false;
    btnUpdate.Enabled := false;
    btnDelete.Enabled := false;
    if (dbGrid.DataSource <> dm.dsClientsQuery) then
    begin
      dbGrid.DataSource := dm.dsClientsQuery;
      dbNav.DataSource := dm.dsClientsQuery;
    end;
    with dm do
    begin
      qryClients.Close;
      qryClients.SQL.Clear;
      qryClients.SQL.Text := 'SELECT * FROM tblClients WHERE ClientName LIKE ' + QuotedStr(UpperCase(input) + '%');
      qryClients.Open;
    end;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// This gets called when the form gets displayed. Sets the current (first)
// record's data to be displayed in the edits. Formats the DBGrid. Sets the
// sorting preferences to the default (Ascending by ClientID).
procedure TfrmClients.FormActivate(Sender: TObject);
begin
  dm.tblClients.First;
  changeEdits;
  formatDBGrid;
  rSort.ItemIndex := 0;
  rSortFields.ItemIndex := 0;
end;

// Dynamic Creation (Create)
// =---------------------------------------------------------------------------=
// Calls other procedures to create a dynamic component on the form. This
// dynamic component in in regards to updating a record in the table.
procedure TfrmClients.btnCreateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicCreate;
  disableEverything;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Displays help.
procedure TfrmClients.btnHelpClick(Sender: TObject);
begin
  frmProperties_u.frmProperties.ShowModal;
end;

end.
