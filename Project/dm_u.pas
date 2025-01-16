unit dm_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Forms,
  Data.FMTBcd, Data.SqlExpr, System.Hash, Data.DBXInterBase, clsProperty;

type
  Tdm = class(TDataModule)
    conn: TADOConnection;
    tblAgents: TADOTable;
    dsAgents: TDataSource;
    tblClients: TADOTable;
    dsClients: TDataSource;
    tblProperties: TADOTable;
    dsProperties: TDataSource;
    qryAgents: TADOQuery;
    qryClients: TADOQuery;
    qryProperties: TADOQuery;
    dsAgentsQuery: TDataSource;
    dsClientsQuery: TDataSource;
    dsPropertiesQuery: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure connect_mdb;
    procedure populateDynamicArray;
  public
    { Public declarations }
    arrProperties : array of TProperty;

    function getSHA256(message : string) : string;
    function compareHash(hash1 : string; hash2 : string) : boolean;

    function validName(name : string) : boolean;
    function validSurname(surname : string) : boolean;
    function validCell(cell : string) : boolean;
    function validAddress(address : string) : boolean;
    function validValue(value : real) : boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

// General Functionality
// =---------------------------------------------------------------------------=
// Connects the database to the program.
procedure Tdm.connect_mdb;
const
  scConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;' +
    'Data Source=%pathtomdb%@DatabaseName@;Mode=Share Deny None;' +
    'Persist Security Info=False;Jet OLEDB:System database="";Jet OLEDB:Registry Path="";'
    + 'Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;'
    + 'Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;'
    + 'Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;'
    + 'Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don''' +
    't Copy Locale on Compact=False;' +
    'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False';

    DatabaseName = 'database.mdb';
var
  APath : string;
begin
  conn.Connected := false;
  tblAgents.Active := false;
  tblClients.Active := false;
  tblProperties.Active := false;

  APath := extractfilepath(application.exename);
  conn.ConnectionString := Stringreplace(scConnectionString, '%pathtomdb%',
    APath, []);
  conn.ConnectionString := Stringreplace(conn.ConnectionString,
    '@DatabaseName@', DatabaseName, []);
  conn.Connected := true;
  tblAgents.Active := true;
  tblClients.Active := true;
  tblProperties.Active := true;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Compares two SHA256 hashes with each other. If they are the same return
// true, else return false.
function Tdm.compareHash(hash1, hash2: string): boolean;
var
  returnBool : boolean;
begin
  returnBool := false;
  if (hash1 = hash2) then
  begin
    returnBool := true;
  end;
  Result := returnBool;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Returns the SHA256 hash of a given input.
function Tdm.getSHA256(message: string): string;
begin
  Result := THashSHA2.GetHashString(message);
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Populates the dynamic array with property objects.
procedure Tdm.populateDynamicArray;
var
  sAddress : string;
  iRooms, iBathrooms, iAgentFK, iClientFK, iID, i : integer;
  bHasParking : boolean;
  rValue : real;
  cProperty : TProperty;
begin
  i := 0;
  while not tblProperties.Eof do
  begin
    iID := dm.tblProperties['PropertyID'];
    sAddress := dm.tblProperties['PropertyAddress'];
    iRooms := dm.tblProperties['PropertyRooms'];
    iBathrooms := dm.tblProperties['PropertyBathrooms'];
    bHasParking := dm.tblProperties['PropertyHasParking'];
    rValue := dm.tblProperties['PropertyValue'];
    iAgentFK := dm.tblProperties['AgentFK'];
    iClientFK := dm.tblProperties['ClientFK'];
    cProperty := TProperty.Create(iID, sAddress, iRooms, iBathrooms, bHasParking, rValue, iAgentFK, iClientFK);
    SetLength(arrProperties, (Length(arrProperties) + 1));
    arrProperties[i] := cProperty;
    i := i + 1;
    tblProperties.Next;
  end;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Validates if the given address follows a set of rules. If the address is
// valid return true, else return false.
function Tdm.validAddress(address: string): boolean;
var
  returnBool : boolean;
begin
  returnBool := true;
  if (Length(address) = 0) then
  begin
    returnBool := false;
  end;
  Result := returnBool;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Validates if the given cell follows a set of rules. If the cell is valid
// return true, else return false.
function Tdm.validCell(cell: string): boolean;
var
  returnBool : boolean;
begin
  returnBool := true;
  if (Length(cell) = 0) then
  begin
    returnBool := false;
  end;
  if ((Length(cell) > 20) AND (returnBool <> false)) then
  begin
    returnBool := false;
  end;
  Result := returnBool;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Validates if the given name follows a set of rules. If the name is valid
// return true, else return false.
function Tdm.validName(name: string): boolean;
var
  returnBool : boolean;
  i : integer;
begin
  returnBool := true;
  if (Length(name) = 0) then
  begin
    returnBool := false;
  end;
  if ((Length(name) > 50) AND (returnBool <> false)) then
  begin
    returnBool := false;
  end;
  for i := 1 to Length(name) do
  begin
    if ((name[i] in ['0'..'9']) AND (returnBool <> false)) then
    begin
      returnBool := false;
    end;
  end;
  Result := returnBool;
end;

// General Functionality
// =---------------------------------------------------------------------------=
// Validates if the given surname follows a set of rules. If the surname is valid
// return true, else return false.
function Tdm.validSurname(surname: string): boolean;
var
  returnBool : boolean;
  i : integer;
begin
  returnBool := true;
  if (Length(surname) = 0) then
  begin
    returnBool := false;
  end;
  if ((Length(surname) > 50) AND (returnBool <> false)) then
  begin
    returnBool := false;
  end;
  for i := 1 to Length(surname) do
  begin
    if ((surname[i] in ['0'..'9']) AND (returnBool <> false)) then
    begin
      returnBool := false;
    end;
  end;
  Result := returnBool;
end;

function Tdm.validValue(value: real): boolean;
begin

end;

// General Functionality
// =---------------------------------------------------------------------------=
// After creating the data module at runtime startup, connect to the database.
procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  connect_mdb;
  tblAgents.Open;
  tblClients.Open;
  tblProperties.Open;
  populateDynamicArray;
end;

end.
