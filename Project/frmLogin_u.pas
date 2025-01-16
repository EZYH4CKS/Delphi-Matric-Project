unit frmLogin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Samples.Spin,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  frmMenu_u, dm_u;

type
  TfrmLogin = class(TForm)
    edtLoginUsername: TEdit;
    pnlLogin: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtLoginPassword: TEdit;
    btnLogin: TButton;
    pnlRegister: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edtRegUsername: TEdit;
    Label6: TLabel;
    edtRegPassword: TEdit;
    Label7: TLabel;
    edtRegName: TEdit;
    edtRegSurname: TEdit;
    Label8: TLabel;
    rgpRegGender: TRadioGroup;
    Label9: TLabel;
    spnRegAge: TSpinEdit;
    Label10: TLabel;
    edtRegCell: TEdit;
    btnRegister: TButton;
    btnHelp: TBitBtn;
    btnClose: TBitBtn;
    rgpRegUser: TRadioGroup;
    procedure btnLoginClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
  private
    { Private declarations }
    procedure readFile;
    procedure writeFile(content : string);
    procedure resetPage;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  fileHashes : array[0..99] of string;
  adminStates : array[0..99] of integer;
  nrE : integer = 0;

implementation

{$R *.dfm}

// General Functionality
// =---------------------------------------------------------------------------=
// When the user clicks the "Login" button, the program validates the username
// + password combination. If the combination is valid the user is allowed to
// use the program, else display an error message.
procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  username, password, userHash : string;
  i : integer;
  found : boolean;
begin
  username := edtLoginUsername.Text;
  password := edtLoginPassword.Text;
  userHash := dm.getSHA256(username + '#' + password);

  found := false;
  i := 0;
  while ((i <= nrE) AND (found <> true)) do
  begin
    if (dm.compareHash(userHash, fileHashes[i]) = true) then
    begin
      found := true;
    end
    else
    begin
      i := i + 1;
    end;
  end;

  if (found = true) then
  begin
    if (adminStates[i] = 1) then
    begin
      frmMenu.bAdmin := true;
    end;
    frmMenu_u.frmMenu.ShowModal;
  end
  else
  begin
    ShowMessage('Invalid credentials!');
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// When the user clicks the "Register" button, the program validates the
// information provided by the user. If the information is valid the program
// will:
//   1. Hash the username + password combination.
//   2. Add the hash to the text file to allow the user to log into the account.
//   3. Add the name, surname, gender, etc. to the correct table in the database
//      according the user type selected by the user.
procedure TfrmLogin.btnRegisterClick(Sender: TObject);
var
  username, password, name, surname, gender, cell, hash : string;
  age, userType : integer;
begin
  username := edtRegUsername.Text;
  password := edtRegPassword.Text;
  name := edtRegName.Text;
  surname := edtRegSurname.Text;
  gender := rgpRegGender.Items[rgpRegGender.ItemIndex];
  cell := edtRegCell.Text;
  age := spnRegAge.Value;

  if ((Length(username) > 0) AND (Length(password) > 0) AND (Length(name) > 0) AND (Length(surname) > 0) AND (Length(cell) > 0)) then
  begin
    hash := dm.getSHA256(username + '#' + password);
    userType := rgpRegUser.ItemIndex;
    writeFile(hash + ';0#' + IntToStr(userType));
    resetPage;
    if (userType = 0) then
    begin
      dm.tblClients.Last;
      dm.tblClients.Insert;
      dm.tblClients['ClientName'] := name;
      dm.tblClients['ClientSurname'] := surname;
      dm.tblClients['ClientGender'] := gender;
      dm.tblClients['ClientAge'] := age;
      dm.tblClients['ClientCell'] := cell;
      dm.tblClients.Post;
    end
    else
    begin
      dm.tblAgents.Last;
      dm.tblAgents.Insert;
      dm.tblAgents['AgentName'] := name;
      dm.tblAgents['AgentSurname'] := surname;
      dm.tblAgents['AgentGender'] := gender;
      dm.tblAgents['AgentAge'] := age;
      dm.tblAgents['AgentCell'] := cell;
      dm.tblAgents.Post;
    end;
    ShowMessage('Successfully created a new user!');
  end
  else
  begin
    ShowMessage('Invalid information entered when trying to register!');
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// When the forms shows, read the text file and store it in parrallel arrays.
procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  readFile;
end;

procedure TfrmLogin.readFile;
var
  tFile : TextFile;
  line : string;
  i, delim : integer;
begin
  AssignFile(tFile, 'credentials.txt');

  try
    Reset(tFile);
  except
    ShowMessage('Error when reading credentials!');
    Application.Terminate;
  end;

  while not EOF(tFile) do
  begin
    Readln(tFile, line);
    delim := Pos(';', line);
    fileHashes[nrE] := Copy(line, 1, delim-1);
    adminStates[nrE] := StrToInt(Copy(line, delim+1, 1));
    nrE := nrE + 1;
  end;
  CloseFile(tFile);
end;

procedure TfrmLogin.resetPage;
begin
  edtRegUsername.Text := '';
  edtRegPassword.Text := '';
  rgpRegUser.ItemIndex := 0;
  edtRegName.Text := '';
  edtRegSurname.Text := '';
  rgpRegGender.ItemIndex := 0;
  spnRegAge.Value := 18;
  edtRegCell.Text := '';
  edtLoginUsername.Text := '';
  edtLoginPassword.Text := '';
end;

procedure TfrmLogin.writeFile(content: string);
var
  tFile : TextFile;
begin
  AssignFile(tFile, 'credentials.txt');

  try
    Append(tFile);
  except
    ShowMessage('Error when reading credentials!');
    Application.Terminate;
  end;

  writeln(tFile, content);
  CloseFile(tFile);

end;

end.
