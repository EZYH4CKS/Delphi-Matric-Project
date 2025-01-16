unit frmAgents_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Samples.Spin, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, dm_u,
  Vcl.Imaging.jpeg;

type
  TfrmAgents = class(TForm)
    dbGrid: TDBGrid;
    rSort: TRadioGroup;
    rSortFields: TRadioGroup;
    pnlAdjustments: TPanel;
    dbNav: TDBNavigator;
    btnShowAll: TButton;
    edtSearch: TEdit;
    pnlMaintenance: TPanel;
    Label1: TLabel;
    btnCreate: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;
    btnHelp: TBitBtn;
    btnClose: TBitBtn;
    pnlAgentInfo: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtAgentName: TEdit;
    edtAgentSurname: TEdit;
    edtAgentGender: TEdit;
    edtAgentAge: TEdit;
    edtAgentCell: TEdit;
    Panel1: TPanel;
    Image1: TImage;
    procedure rSortClick(Sender: TObject);
    procedure rSortFieldsClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure btnShowAllClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbNavClick(Sender: TObject; Button: TNavigateBtn);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
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
  frmAgents: TfrmAgents;

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

{ TfrmAgents }

// Dynamic Button Event Handler: [Cancel] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Removes the dynamic components/elements from the form. Resets the form to
// original width.
procedure TfrmAgents.btnCancelClick(Sender: TObject);
begin
  dynamicPanel.Free;
  frmAgents.ClientWidth := 820;
  enableEverything;
end;

// Dynamic Button Event Handler: [Clear Fields] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Resets all the fields on the dynamic component.
procedure TfrmAgents.btnClearClick(Sender: TObject);
begin
  edtName.Text := '';
  edtSurname.Text := '';
  cmbGender.ItemIndex := -1;
  spnAge.Value := 18;
  edtCell.Text := '';
end;

// Dynamic Creation (Create)
// =---------------------------------------------------------------------------=
// Calls other procedures to create a dynamic component on the form. This
// dynamic component in in regards to updating a record in the table.
procedure TfrmAgents.btnCreateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicCreate;
  disableEverything;
end;

// Dynamic Button Event Handler: [Create] (Applicable on dynamic Create)
// =---------------------------------------------------------------------------=
// Creates a new record with information gathered and adds it to the table.s
procedure TfrmAgents.btnCreateRecordClick(Sender: TObject);
var
  sName, sSurname, sCell : string;
begin
  sName := edtName.Text;
  sSurname := edtSurname.Text;
  sCell := edtCell.Text;
  if (dm.validName(sName) AND dm.validSurname(sSurname) AND dm.validCell(sCell)) then
  begin
    dm.tblAgents.Last;
    dm.tblAgents.Insert;
    dm.tblAgents['AgentName'] := sName;
    dm.tblAgents['AgentSurname'] := sSurname;
    dm.tblAgents['AgentGender'] := cmbGender.Items[cmbGender.ItemIndex];
    dm.tblAgents['AgentAge'] := spnAge.Value;
    dm.tblAgents['AgentCell'] := sCell;
    dm.tblAgents.Post;
    dm.tblAgents.Refresh;
    ShowMessage('New record successfully created!');
    dynamicPanel.Free;
    enableEverything;
    frmAgents.ClientWidth := 820;
  end
  else
  begin
    ShowMessage('Information entered was invalid. Please retry.');
  end;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specified record from the table.
procedure TfrmAgents.btnDeleteClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicDelete;
  disableEverything;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specific record from the table.
procedure TfrmAgents.btnDeleteRecordClick(Sender: TObject);
var
  iID : integer;
  found : boolean;
begin
  found := false;
  iID := StrToInt(edtID.Text);
  dm.tblAgents.First;
  while not dm.tblAgents.Eof do
  begin
    if (dm.tblAgents['AgentID'] = iID) then
    begin
      found := true;
      dm.tblAgents.Delete;
      dm.tblAgents.Refresh;
      dm.tblAgents.First;
      ShowMessage('Successfully deleted record!');
      dynamicPanel.Free;
      enableEverything;
      frmAgents.ClientWidth := 820;
      exit;
    end
    else
    begin
      dm.tblAgents.Next;
    end;
  end;

  if (found <> true) then
  begin
    ShowMessage('Agent ID was not found. Please retry with a valid ID.');
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Clears the search query. This makes the program show all the records in the
// table.
procedure TfrmAgents.btnShowAllClick(Sender: TObject);
begin
  edtSearch.Text := '';
end;

// Dynamic Creation (Update)
// =---------------------------------------------------------------------------=
// Calls other procedures to create a dynamic component on the form. This
// dynamic component in in regards to updating a record in the table.
procedure TfrmAgents.btnUpdateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicUpdate;
  disableEverything;
end;

// Dynamic Button Event Handler: [Update] (Applicable on dynamic Update)
// =---------------------------------------------------------------------------=
// Updates the current record with the information gathered from the user.
procedure TfrmAgents.btnUpdateRecordClick(Sender: TObject);
var
  sName, sSurname, sCell : string;
begin
  sName := edtName.Text;
  sSurname := edtSurname.Text;
  sCell := edtCell.Text;
  if (dm.validName(sName) AND dm.validSurname(sSurname) AND dm.validCell(sCell)) then
  begin
    dm.tblAgents.Edit;
    dm.tblAgents['AgentName'] := sName;
    dm.tblAgents['AgentSurname'] := sSurname;
    dm.tblAgents['AgentGender'] := cmbGender.Items[cmbGender.ItemIndex];
    dm.tblAgents['AgentAge'] := spnAge.Value;
    dm.tblAgents['AgentCell'] := sCell;
    dm.tblAgents.Post;
    dm.tblAgents.Refresh;
    ShowMessage('Current record successfully updated!');
    dynamicPanel.Free;
    enableEverything;
    frmAgents.ClientWidth := 820;
  end
  else
  begin
    ShowMessage('Information entered was invalid. Please retry.');
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Updates the edits to display the information of the current record.
procedure TfrmAgents.changeEdits;
begin
  edtAgentName.Text := dm.tblAgents['AgentName'];
  edtAgentSurname.Text := dm.tblAgents['AgentSurname'];
  edtAgentGender.Text := dm.tblAgents['AgentGender'];
  edtAgentAge.Text := IntToStr(dm.tblAgents['AgentAge']);
  edtAgentCell.Text := dm.tblAgents['AgentCell'];
end;

// Dynamic Initialization
// =---------------------------------------------------------------------------=
// Main boilerplate code to create dynamic elements on the form. Initializes all
// dynamic components/elements. Changes the form's width to allow the displaying
// of the dynamic components/elements.
procedure TfrmAgents.createDynamicPanel;
begin
  dynamicPanel := TPanel.Create(frmAgents);
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

  frmAgents.ClientWidth := 1100;
  with dynamicPanel do
  begin
    Parent := frmAgents;
    Top := 8;
    Left := 819;
    Width := 273;
    Height := 514;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Whenever the user browses through the table, the relevant data is displayed
// in edits to give the user a better viewing experience.
procedure TfrmAgents.dbNavClick(Sender: TObject; Button: TNavigateBtn);
begin
  changeEdits;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Disables all major functionality on the form. This is done to prevent the
// from causing edge cases where errors could occur.
procedure TfrmAgents.disableEverything;
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
// Allows the user to search through the table for a specific record. Any input
// is compared against the AgentName field. Changes the data source of the
// table to allow the viewing of the queried results. Disables the create,
// update, and delete buttons to eliminate errors and/or bugs.
procedure TfrmAgents.edtSearchChange(Sender: TObject);
var
  input : string;
begin
  input := edtSearch.Text;
  if (Length(input) = 0) then
  begin
    dbGrid.DataSource := dm.dsAgents;
    dbNav.DataSource := dm.dsAgents;
    btnCreate.Enabled := true;
    btnUpdate.Enabled := true;
    btnDelete.Enabled := true;
  end
  else
  begin
    btnCreate.Enabled := false;
    btnUpdate.Enabled := false;
    btnDelete.Enabled := false;
    if (dbGrid.DataSource <> dm.dsAgentsQuery) then
    begin
      dbGrid.DataSource := dm.dsAgentsQuery;
      dbNav.DataSource := dm.dsAgentsQuery;
    end;
    with dm do
    begin
      qryAgents.Close;
      qryAgents.SQL.Clear;
      qryAgents.SQL.Text := 'SELECT * FROM tblAgents WHERE AgentName LIKE ' + QuotedStr(UpperCase(input) + '%');
      qryAgents.Open;
    end;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Renables all major functionality on the form.
procedure TfrmAgents.enableEverything;
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
// This gets called when the form gets displayed. Sets the current (first)
// record's data to be displayed in the edits. Formats the DBGrid. Sets the
// sorting preferences to the default (Ascending by ClientID).
procedure TfrmAgents.FormActivate(Sender: TObject);
begin
  dm.tblAgents.First;
  changeEdits;
  formatDBGrid;
  rSort.ItemIndex := 0;
  rSortFields.ItemIndex := 0;
end;

// Quality of Life
// =---------------------------------------------------------------------------=
// Formats the DBGrid to allow for a more enjoyable user experience.
procedure TfrmAgents.formatDBGrid;
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
procedure TfrmAgents.initDynamicCreate;
begin
  with lblName do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Name:';
  end;

  with lblSurname do
  begin
    Parent := dynamicPanel;
    Top := 80;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Surname:';
  end;

  with lblGender do
  begin
    Parent := dynamicPanel;
    Top := 144;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Gender:';
  end;

  with lblAge do
  begin
    Parent := dynamicPanel;
    Top := 208;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Age:';
  end;

  with lblCell do
  begin
    Parent := dynamicPanel;
    Top := 286;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Cell:';
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
    Hint := 'To create a new record please enter the name of the agent here.';
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
    Hint := 'To create a new record please enter the surname of the agent here.';
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
    Hint := 'To create a new record please enter the gender of the agent here.';
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
    Hint := 'To create a new record please enter the age of the agent here.';
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
    Hint := 'To create a new record please enter the cell of the agent here.';
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
procedure TfrmAgents.initDynamicDelete;
begin
  with lblID do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent ID to delete:';
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
    Hint := 'To delete a specific record, please input the ID of the agent here.';
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
procedure TfrmAgents.initDynamicUpdate;
begin
  with lblName do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Name:';
  end;

  with lblSurname do
  begin
    Parent := dynamicPanel;
    Top := 80;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Surname:';
  end;

  with lblGender do
  begin
    Parent := dynamicPanel;
    Top := 144;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Gender:';
  end;

  with lblAge do
  begin
    Parent := dynamicPanel;
    Top := 208;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Age:';
  end;

  with lblCell do
  begin
    Parent := dynamicPanel;
    Top := 286;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Agent Cell:';
  end;

  with edtName do
  begin
    Parent := dynamicPanel;
    Top := 39;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := dm.tblAgents['AgentName'];
    Hint := 'To update the current record, please change the name of the agent here.';
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
    Text := dm.tblAgents['AgentSurname'];
    Hint := 'To update the current record, please change the surname of the agent here.';
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
    ItemIndex := Items.IndexOf(dm.tblAgents['AgentGender']);
    Hint := 'To update the current record, please change the gender of the agent here.';
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
    Value := dm.tblAgents['AgentAge'];
    Hint := 'To update the current record, please change the age of the agent here.';
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
    Text := dm.tblAgents['AgentCell'];
    Hint := 'To update the current record, please change the cell of the agent here.';
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
procedure TfrmAgents.rSortClick(Sender: TObject);
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
procedure TfrmAgents.rSortFieldsClick(Sender: TObject);
begin
  if (dbGrid.DataSource = dm.dsAgentsQuery) then
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
// ascending or descending by AgentID, AgentName, AgentSurname, etc. This
// implementation also allows the user to sort the query result(s) from
// searching.
procedure TfrmAgents.sort(direction, field: integer; isQuery : boolean);
var
  sortStr : string;
begin
  sortStr := '';
  if (direction = 0) then
  begin
    case field of
      0: sortStr := 'AgentID ASC';
      1: sortStr := 'AgentName ASC';
      2: sortStr := 'AgentSurname ASC';
      3: sortStr := 'AgentGender ASC';
      4: sortStr := 'AgentAge ASC';
    end;
  end
  else
  begin
    case field of
      0: sortStr := 'AgentID DESC';
      1: sortStr := 'AgentName DESC';
      2: sortStr := 'AgentSurname DESC';
      3: sortStr := 'AgentGender DESC';
      4: sortStr := 'AgentAge DESC';
    end;
  end;
  if (isQuery) then
  begin
    dm.qryAgents.Sort := sortStr;
  end
  else
  begin
    dm.tblAgents.Sort := sortStr;
  end;
end;

end.
