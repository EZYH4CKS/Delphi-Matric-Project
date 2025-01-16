unit frmProperties_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.Samples.Spin,
  dm_u, frmClient_u, clsProperty;

type
  TfrmProperties = class(TForm)
    dbGrid: TDBGrid;
    rSort: TRadioGroup;
    rSortFields: TRadioGroup;
    pnlAdjustments: TPanel;
    dbNav: TDBNavigator;
    edtSearch: TEdit;
    btnShowAll: TButton;
    pnlMaintenance: TPanel;
    Label1: TLabel;
    pnlAgentInfo: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtPropertyAddress: TEdit;
    edtPropertyRooms: TEdit;
    edtPropertyBathrooms: TEdit;
    edtHasParking: TEdit;
    edtPropertyValue: TEdit;
    Panel1: TPanel;
    btnClose: TBitBtn;
    btnCreate: TButton;
    btnDelete: TButton;
    btnHelp: TBitBtn;
    btnUpdate: TButton;
    procedure rSortClick(Sender: TObject);
    procedure rSortFieldsClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure dbNavClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormActivate(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnShowAllClick(Sender: TObject);
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
  frmProperties: TfrmProperties;

  dynamicPanel : TPanel;
  lblAddress : TLabel;
  lblRooms : TLabel;
  lblBathrooms : TLabel;
  lblHasParking : TLabel;
  lblValue : TLabel;
  lblAgentFK : TLabel;
  lblClientFK : TLabel;
  lblID : TLabel;
  edtAddress : TEdit;
  spnRooms : TSpinEdit;
  spnBathrooms : TSpinEdit;
  cmbHasParking : TComboBox;
  edtValue : TEdit;
  spnAgentFK : TSpinEdit;
  spnClientFK : TSpinEdit;
  edtID : TEdit;
  btnReset : TBitBtn;
  btnCreateRecord : TBitBtn;
  btnUpdateRecord : TBitBtn;
  btnDeleteRecord : TBitBtn;
  btnCancel : TBitBtn;

implementation

{$R *.dfm}

{ TfrmProperties }

// Dynamic Button Event Handler: [Cancel] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Removes the dynamic components/elements from the form. Resets the form to
// original width.
procedure TfrmProperties.btnCancelClick(Sender: TObject);
begin
  dynamicPanel.Free;
  frmProperties.ClientWidth := 820;
  enableEverything;
end;

// Dynamic Button Event Handler: [Clear Fields] (Applicable everywhere)
// =---------------------------------------------------------------------------=
// Resets all the fields on the dynamic component.
procedure TfrmProperties.btnClearClick(Sender: TObject);
begin
  edtAddress.Text := '';
  spnRooms.Value := 1;
  spnBathrooms.Value := 1;
  edtHasParking.Text := '';
  edtValue.Text := '';
  spnAgentFK.Value := 0;
  spnClientFK.Value := 0;
end;

procedure TfrmProperties.btnCreateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicCreate;
  disableEverything;
end;

// Dynamic Button Event Handler: [Create] (Applicable on dynamic Create)
// =---------------------------------------------------------------------------=
// Creates a new record with information gathered and adds it to the table.
procedure TfrmProperties.btnCreateRecordClick(Sender: TObject);
var
  sAddress : string;
  iRooms, iBathrooms, iAgentFK, iClientFK : integer;
  bHasParking : boolean;
  rValue : real;
  cProperty : TProperty;
begin
  sAddress := edtAddress.Text;
  iRooms := spnRooms.Value;
  iBathrooms := spnBathrooms.Value;
  bHasParking := StrToBool(cmbHasParking.Items[cmbHasParking.ItemIndex]);
  rValue := StrToFloat(edtValue.Text);
  iAgentFK := spnAgentFK.Value;
  iClientFK := spnClientFK.Value;
  dm.tblProperties.Last;
  dm.tblProperties.Insert;
  dm.tblProperties['PropertyAddress'] := sAddress;
  dm.tblProperties['PropertyRooms'] := iRooms;
  dm.tblProperties['PropertyBathrooms'] := iBathrooms;
  dm.tblProperties['PropertyHasParking'] := bHasParking;
  dm.tblProperties['PropertyValue'] := rValue;
  dm.tblProperties['AgentFK'] := iAgentFK;
  dm.tblProperties['ClientFK'] := iClientFK;
  dm.tblProperties.Post;
  dm.tblProperties.Refresh;

  dm.tblProperties.Last;
  cProperty := TProperty.Create(dm.tblProperties['PropertyID'], sAddress, iRooms, iBathrooms, bHasParking, rValue, iAgentFK, iClientFK);
  SetLength(dm.arrProperties, (Length(dm.arrProperties) + 1));
  dm.arrProperties[High(dm.arrProperties)] := cProperty;
  dm.tblProperties.First;

  ShowMessage('New record successfully created!');
  dynamicPanel.Free;
  enableEverything;
  frmProperties.ClientWidth := 820;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specified record from the table.
procedure TfrmProperties.btnDeleteClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicDelete;
  disableEverything;
end;

// Dynamic Button Event Handler: [Delete] (Applicable on dynamic Delete)
// =---------------------------------------------------------------------------=
// Deletes a specific record from the table.
procedure TfrmProperties.btnDeleteRecordClick(Sender: TObject);
var
  iID, i, j : integer;
  found : boolean;
begin
  found := false;
  iID := StrToInt(edtID.Text);
  dm.tblProperties.First;
  while not dm.tblProperties.Eof do
  begin
    if (dm.tblProperties['PropertyID'] = iID) then
    begin
      found := true;
      i := 0;
      while (i <= High(dm.arrProperties)) do
      begin
        if (dm.tblProperties['PropertyID'] = dm.arrProperties[i].getID) then
        begin
          dm.arrProperties[i] := nil;
          for j := i to High(dm.arrProperties)-1 do
          begin
            dm.arrProperties[j] := dm.arrProperties[j+1];
          end;
          SetLength(dm.arrProperties, (Length(dm.arrProperties)-1));
        end;
        i := i + 1;
      end;
      dm.tblProperties.Delete;
      dm.tblProperties.Refresh;
      dm.tblProperties.First;
      ShowMessage('Successfully deleted record!');
      dynamicPanel.Free;
      enableEverything;
      frmProperties.ClientWidth := 820;
    end
    else
    begin
      dm.tblProperties.Next;
    end;
  end;

  if (found <> true) then
  begin
    ShowMessage('Client ID was not found. Please retry with a valid ID.');
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Clears the search query. This makes the program show all the records in the
// table.
procedure TfrmProperties.btnShowAllClick(Sender: TObject);
begin
  edtSearch.Text := '';
end;

// Dynamic Creation (Update)
// =---------------------------------------------------------------------------=
// Calls other procedures to create a dynamic component on the form. This
// dynamic component in in regards to updating a record in the table.
procedure TfrmProperties.btnUpdateClick(Sender: TObject);
begin
  createDynamicPanel;
  initDynamicUpdate;
  disableEverything;
end;

// Dynamic Button Event Handler: [Update] (Applicable on dynamic Update)
// =---------------------------------------------------------------------------=
// Updates the current record with the information gathered from the user.
procedure TfrmProperties.btnUpdateRecordClick(Sender: TObject);
var
  sAddress : string;
  iRooms, iBathrooms, iAgentFK, iClientFK, i: integer;
  bHasParking : boolean;
  rValue : real;
begin
  sAddress := edtAddress.Text;
  iRooms := spnRooms.Value;
  iBathrooms := spnBathrooms.Value;
  bHasParking := StrToBool(cmbHasParking.Items[cmbHasParking.ItemIndex]);
  rValue := StrToFloat(edtValue.Text);
  iAgentFK := spnAgentFK.Value;
  iClientFK := spnClientFK.Value;

  for i := 0 to High(dm.arrProperties) do
  begin
    if (dm.tblProperties['PropertyID'] = dm.arrProperties[i].getID) then
    begin
      dm.arrProperties[i].setAddress(sAddress);
      dm.arrProperties[i].setRooms(iRooms);
      dm.arrProperties[i].setBathrooms(iBathrooms);
      dm.arrProperties[i].setParkingStatus(bHasParking);
      dm.arrProperties[i].setValue(rValue);
      dm.arrProperties[i].setAgentFK(iAgentFK);
      dm.arrProperties[i].setClientFK(iClientFK);
    end;
  end;

  dm.tblProperties.Edit;
  dm.tblProperties['PropertyAddress'] := sAddress;
  dm.tblProperties['PropertyRooms'] := iRooms;
  dm.tblProperties['PropertyBathrooms'] := iBathrooms;
  dm.tblProperties['PropertyHasParking'] := bHasParking;
  dm.tblProperties['PropertyValue'] := rValue;
  dm.tblProperties['AgentFK'] := iAgentFK;
  dm.tblProperties['ClientFK'] := iClientFK;
  dm.tblProperties.Post;
  dm.tblProperties.Refresh;
  ShowMessage('Current record successfully updated!');
  dynamicPanel.Free;
  enableEverything;
  frmProperties.ClientWidth := 820;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Updates the edits to display the information of the current record.
procedure TfrmProperties.changeEdits;
begin
  edtPropertyAddress.Text := dm.tblProperties['PropertyAddress'];
  edtPropertyRooms.Text := IntToStr(dm.tblProperties['PropertyRooms']);
  edtPropertyBathrooms.Text := IntToStr(dm.tblProperties['PropertyBathrooms']);
  edtHasParking.Text := BoolToStr(dm.tblProperties['PropertyHasParking'], true);
  edtPropertyValue.Text := FloatToStrF(dm.tblProperties['PropertyValue'], ffCurrency, 6, 2);
end;

// Dynamic Initialization
// =---------------------------------------------------------------------------=
// Main boilerplate code to create dynamic elements on the form. Initializes all
// dynamic components/elements. Changes the form's width to allow the displaying
// of the dynamic components/elements.
procedure TfrmProperties.createDynamicPanel;
begin
  dynamicPanel := TPanel.Create(frmProperties);
  lblAddress := TLabel.Create(dynamicPanel);
  lblRooms := TLabel.Create(dynamicPanel);
  lblBathrooms := TLabel.Create(dynamicPanel);
  lblHasParking := TLabel.Create(dynamicPanel);
  lblValue := TLabel.Create(dynamicPanel);
  lblAgentFK := TLabel.Create(dynamicPanel);
  lblClientFK := TLabel.Create(dynamicPanel);
  lblID := TLabel.Create(dynamicPanel);
  edtAddress := TEdit.Create(dynamicPanel);
  spnRooms := TSpinEdit.Create(dynamicPanel);
  spnBathrooms := TSpinEdit.Create(dynamicPanel);
  cmbHasParking := TComboBox.Create(dynamicPanel);
  edtValue := TEdit.Create(dynamicPanel);
  spnAgentFK := TSpinEdit.Create(dynamicPanel);
  spnClientFK := TSpinEdit.Create(dynamicPanel);
  edtID := TEdit.Create(dynamicPanel);
  btnReset := TBitBtn.Create(dynamicPanel);
  btnCreateRecord := TBitBtn.Create(dynamicPanel);
  btnUpdateRecord := TBitBtn.Create(dynamicPanel);
  btnDeleteRecord := TBitBtn.Create(dynamicPanel);
  btnCancel := TBitBtn.Create(dynamicPanel);

  frmProperties.ClientWidth := 1100;
  with dynamicPanel do
  begin
    Parent := frmProperties;
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
procedure TfrmProperties.dbNavClick(Sender: TObject; Button: TNavigateBtn);
begin
  changeEdits;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Disables all major functionality on the form. This is done to prevent the
// from causing edge cases where errors could occur.
procedure TfrmProperties.disableEverything;
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
// is compared against the PropertyAddress field. Changes the data source of the
// table to allow the viewing of the queried results. Disables the create,
// update, and delete buttons to eliminate errors and/or bugs.
procedure TfrmProperties.edtSearchChange(Sender: TObject);
var
  input : string;
begin
  input := edtSearch.Text;
  if (Length(input) = 0) then
  begin
    dbGrid.DataSource := dm.dsProperties;
    dbNav.DataSource := dm.dsProperties;
    btnCreate.Enabled := true;
    btnUpdate.Enabled := true;
    btnDelete.Enabled := true;
  end
  else
  begin
    btnCreate.Enabled := false;
    btnUpdate.Enabled := false;
    btnDelete.Enabled := false;
    if (dbGrid.DataSource <> dm.dsPropertiesQuery) then
    begin
      dbGrid.DataSource := dm.dsPropertiesQuery;
      dbNav.DataSource := dm.dsPropertiesQuery;
    end;
    with dm do
    begin
      qryProperties.Close;
      qryProperties.SQL.Clear;
      qryProperties.SQL.Text := 'SELECT * FROM tblProperties WHERE PropertyAddress LIKE ' + QuotedStr(UpperCase(input) + '%');
      qryProperties.Open;
    end;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Renables all major functionality on the form.
procedure TfrmProperties.enableEverything;
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
// sorting preferences to the default (Ascending by PropertyID).
procedure TfrmProperties.FormActivate(Sender: TObject);
begin
  dm.tblClients.First;
  changeEdits;
  formatDBGrid;
  rSort.ItemIndex := 0;
  rSortFields.ItemIndex := 0;
end;

// Quality of Life
// =---------------------------------------------------------------------------=
// Formats the DBGrid to allow for a more enjoyable user experience.
procedure TfrmProperties.formatDBGrid;
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
procedure TfrmProperties.initDynamicCreate;
begin
  with lblAddress do
  begin
    Parent := dynamicPanel;
    Top := 15;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Address:';
  end;

  with edtAddress do
  begin
    Parent := dynamicPanel;
    Top := 34;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To create a new record, please enter the address of the property here.';
    ShowHint := true;
  end;

  with lblRooms do
  begin
    Parent := dynamicPanel;
    Top := 63;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Rooms:';
  end;

  with spnRooms do
  begin
    Parent := dynamicPanel;
    Top := 82;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := 1;
    MinValue := 1;
    MaxValue := 99;
    Hint := 'To create a new record, please enter the number of rooms in the property here.';
    ShowHint := true;
  end;

  with lblBathrooms do
  begin
    Parent := dynamicPanel;
    Top := 111;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Bathrooms:';
  end;

  with spnBathrooms do
  begin
    Parent := dynamicPanel;
    Top := 130;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := 1;
    MinValue := 1;
    MaxValue := 99;
    Hint := 'To create a new record, please enter the number of bathrooms in the property here.';
    ShowHint := true;
  end;

  with lblHasParking do
  begin
    Parent := dynamicPanel;
    Top := 159;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Has Parking?';
  end;

  with cmbHasParking do
  begin
    Parent := dynamicPanel;
    Top := 178;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Items.AddStrings(['True','False']);
    ItemIndex := 1;
    Hint := 'To create a new record, please state if the property has indoor parking here.';
    ShowHint := true;
  end;

  with lblValue do
  begin
    Parent := dynamicPanel;
    Top := 207;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Value:';
  end;

  with edtValue do
  begin
    Parent := dynamicPanel;
    Top := 226;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To create a new record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with lblAgentFK do
  begin
    Parent := dynamicPanel;
    Top := 255;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property''s AgentFK:';
  end;

  with spnAgentFK do
  begin
    Parent := dynamicPanel;
    Top := 274;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := 0;
    MinValue := 0;
    Hint := 'To create a new record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with lblClientFK do
  begin
    Parent := dynamicPanel;
    Top := 303;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property''s ClientFK:';
  end;

  with spnClientFK do
  begin
    Parent := dynamicPanel;
    Top := 322;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := 0;
    MinValue := 0;
    Hint := 'To create a new record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with btnReset do
  begin
    Parent := dynamicPanel;
    Top := 351;
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
    Top := 390;
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
procedure TfrmProperties.initDynamicDelete;
begin
  with lblID do
  begin
    Parent := dynamicPanel;
    Top := 16;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property ID to delete:';
  end;

  with edtID do
  begin
    Parent := dynamicPanel;
    Top := 39;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := '';
    Hint := 'To delete a specific record, please input the ID of the property here.';
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
procedure TfrmProperties.initDynamicUpdate;
begin
  with lblAddress do
  begin
    Parent := dynamicPanel;
    Top := 15;
    Left := 16;
    Width := 74;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Address:';
  end;

  with edtAddress do
  begin
    Parent := dynamicPanel;
    Top := 34;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := dm.tblProperties['PropertyAddress'];
    Hint := 'To update the current record, please enter the address of the property here.';
    ShowHint := true;
  end;

  with lblRooms do
  begin
    Parent := dynamicPanel;
    Top := 63;
    Left := 16;
    Width := 90;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Rooms:';
  end;

  with spnRooms do
  begin
    Parent := dynamicPanel;
    Top := 82;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    MinValue := 1;
    Value := dm.tblProperties['PropertyRooms'];
    Hint := 'To update the current record, please enter the number of rooms in the property here.';
    ShowHint := true;
  end;

  with lblBathrooms do
  begin
    Parent := dynamicPanel;
    Top := 111;
    Left := 16;
    Width := 82;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Bathrooms:';
  end;

  with spnBathrooms do
  begin
    Parent := dynamicPanel;
    Top := 130;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    MinValue := 1;
    Value := dm.tblProperties['PropertyBathrooms'];
    Hint := 'To update the current record, please enter the number of bathrooms in the property here.';
    ShowHint := true;
  end;

  with lblHasParking do
  begin
    Parent := dynamicPanel;
    Top := 159;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Has Parking?';
  end;

  with cmbHasParking do
  begin
    Parent := dynamicPanel;
    Top := 178;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Items.AddStrings(['True','False']);
    ItemIndex := Items.IndexOf(BoolToStr(dm.tblProperties['PropertyHasParking'], true));
    Hint := 'To update the current record, please state if the property has indoor parking here.';
    ShowHint := true;
  end;

  with lblValue do
  begin
    Parent := dynamicPanel;
    Top := 207;
    Left := 16;
    Width := 62;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property Value:';
  end;

  with edtValue do
  begin
    Parent := dynamicPanel;
    Top := 226;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Text := FloatToStr(dm.tblProperties['PropertyValue']);
    Hint := 'To update the current record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with lblAgentFK do
  begin
    Parent := dynamicPanel;
    Top := 255;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property''s AgentFK:';
  end;

  with spnAgentFK do
  begin
    Parent := dynamicPanel;
    Top := 274;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := dm.tblProperties['AgentFK'];
    MinValue := 0;
    Hint := 'To update the current record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with lblClientFK do
  begin
    Parent := dynamicPanel;
    Top := 303;
    Left := 16;
    Width := 60;
    Height := 17;
    Font.Size := 10;
    Caption := 'Property''s ClientFK:';
  end;

  with spnClientFK do
  begin
    Parent := dynamicPanel;
    Top := 322;
    Left := 16;
    Width := 241;
    Height := 25;
    Font.Size := 10;
    Value := dm.tblProperties['ClientFK'];
    MinValue := 0;
    Hint := 'To update the current record, please enter the estimated value of the property here.';
    ShowHint := true;
  end;

  with btnReset do
  begin
    Parent := dynamicPanel;
    Top := 351;
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

  with btnUpdateRecord do
  begin
    Parent := dynamicPanel;
    Top := 390;
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
    Hint := 'Cancels the updating of a new record.';
    ShowHint := true;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Calls the sorting procedure to sort the table according to the user's
// preferences.
procedure TfrmProperties.rSortClick(Sender: TObject);
begin
  if (dbGrid.DataSource = dm.dsPropertiesQuery) then
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
procedure TfrmProperties.rSortFieldsClick(Sender: TObject);
begin
  if (dbGrid.DataSource = dm.dsPropertiesQuery) then
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
// ascending or descending by PropertyID, PropertyRooms, PropertyBathrooms, etc.
// This implementaion also allows the user to sort the query result(s) from
// searching.
procedure TfrmProperties.sort(direction, field: integer; isQuery: boolean);
var
  sortStr : string;
begin
  sortStr := '';
  if (direction = 0) then
  begin
    case field of
      0: sortStr := 'PropertyID ASC';
      1: sortStr := 'PropertyRooms ASC';
      2: sortStr := 'PropertyBathrooms ASC';
      3: sortStr := 'PropertyHasParking ASC';
      4: sortStr := 'PropertyValue ASC';
    end;
  end
  else
  begin
    case field of
      0: sortStr := 'PropertyID DESC';
      1: sortStr := 'PropertyRooms DESC';
      2: sortStr := 'PropertyBathrooms DESC';
      3: sortStr := 'PropertyHasParking DESC';
      4: sortStr := 'PropertyValue DESC';
    end;
  end;
  if (isQuery) then
  begin
    dm.qryProperties.Sort := sortStr;
  end
  else
  begin
    dm.tblProperties.Sort := sortStr;
  end;
end;

end.
