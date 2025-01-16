unit clsProperty;

interface
uses
  SysUtils;

type
  TProperty = class(TObject)
  private
    fPropertyAddress : String;
    fPropertyRooms, fPropertyBathrooms, fAgentFK, fClientFK, fPropertyID : Integer;
    fPropertyHasParking : Boolean;
    fPropertyValue : Real;

  public
    constructor Create(pPropertyID : integer; pPropertyAddress : String; pPropertyRooms : Integer;
             pPropertyBathrooms : Integer; pPropertyHasParking : Boolean;
             pPropertyValue : Real; pAgentFK : Integer; pClientFK : Integer);
    destructor Destroy;
    function getID : integer;
    function getAddress : string;
    function getRooms : integer;
    function getBathrooms : integer;
    function getParkingStatus : boolean;
    function getValue : real;
    function getAgentFK : integer;
    function getClientFK : integer;
    function estimateMarketValue : real;
    procedure setAddress(pPropertyAddress : string);
    procedure setRooms(pPropertyRooms : integer);
    procedure setBathrooms(pPropertyBathrooms : integer);
    procedure setParkingStatus(pPropertyHasParking : boolean);
    procedure setValue(pPropertyValue : real);
    procedure setAgentFK(pAgentFK : integer);
    procedure setClientFK(pClientFK : integer);
  end;

implementation

{ TProperty }

constructor TProperty.Create(pPropertyID : integer; pPropertyAddress: String; pPropertyRooms,
  pPropertyBathrooms: Integer; pPropertyHasParking: Boolean;
  pPropertyValue: Real; pAgentFK, pClientFK: Integer);
begin
  fPropertyID := pPropertyID;
  fPropertyAddress := pPropertyAddress;
  fPropertyRooms := pPropertyRooms;
  fPropertyBathrooms := pPropertyBathrooms;
  fPropertyHasParking := pPropertyHasParking;
  fPropertyValue := pPropertyValue;
  fAgentFK := pAgentFK;
  fClientFK := pClientFK;
end;

destructor TProperty.Destroy;
begin
  self.Free;
end;

function TProperty.estimateMarketValue: real;
var
  estimate : real;
begin
  estimate := 1000000;
  estimate := estimate + (fPropertyRooms * 150000);
  estimate := estimate + (fPropertyBathrooms * 100000);
  if (fPropertyHasParking = true) then
  begin
    estimate := estimate + 200000;
  end;
  Result := estimate;
end;

function TProperty.getAddress: string;
begin
  Result := fPropertyAddress;
end;

function TProperty.getAgentFK: integer;
begin
  Result := fAgentFK;
end;

function TProperty.getBathrooms: integer;
begin
  Result := fPropertyBathrooms;
end;

function TProperty.getClientFK: integer;
begin
  Result := fClientFK;
end;

function TProperty.getID: integer;
begin
  Result := fPropertyID;
end;

function TProperty.getParkingStatus: boolean;
begin
  Result := fPropertyHasParking;
end;

function TProperty.getRooms: integer;
begin
  Result := fPropertyRooms;
end;

function TProperty.getValue: real;
begin
  Result := fPropertyValue;
end;

procedure TProperty.setAddress(pPropertyAddress: string);
begin
  fPropertyAddress := pPropertyAddress;
end;

procedure TProperty.setAgentFK(pAgentFK: integer);
begin
  fAgentFK := pAgentFK;
end;

procedure TProperty.setBathrooms(pPropertyBathrooms: integer);
begin
  fPropertyBathrooms := pPropertyBathrooms;
end;

procedure TProperty.setClientFK(pClientFK: integer);
begin
  fClientFK := pClientFK;
end;

procedure TProperty.setParkingStatus(pPropertyHasParking: boolean);
begin
  fPropertyHasParking := pPropertyHasParking;
end;

procedure TProperty.setRooms(pPropertyRooms: integer);
begin
  fPropertyRooms := pPropertyRooms;
end;

procedure TProperty.setValue(pPropertyValue: real);
begin
  fPropertyValue := pPropertyValue;
end;

end.
