unit Model.FileControl;

interface

uses
  Model.Interfaces,
  System.Classes, System.SysUtils;

type
  TModelFileControl = class(TInterfacedObject, iModelFileControl)
      private
        FStringList: TStringList;
      public
        constructor Create;
        Destructor Destroy; override;
        class function New : iModelFileControl;
        function Add( aValue : String) : iModelFileControl;
        function Clear : iModelFileControl;
        function SaveToFile( aValue : String) : iModelFileControl;
        function Text : String;
  end;

implementation

{ TModelStringListControl }

function TModelFileControl.Add(aValue: String): iModelFileControl;
begin
  Result := Self;
  FStringList.Add(aValue);
end;

function TModelFileControl.Clear: iModelFileControl;
begin
  Result := Self;
  FStringList.Clear;
end;

constructor TModelFileControl.Create;
begin
  FStringList := TStringList.Create;
end;

destructor TModelFileControl.Destroy;
begin
  FStringList.DisposeOf;
  inherited;
end;

class function TModelFileControl.New: iModelFileControl;
begin
  Result := Self.Create;
end;

function TModelFileControl.SaveToFile(aValue: String): iModelFileControl;
begin
  Result := Self;
  if ForceDirectories(ExtractFilePath(aValue)) then
    FStringList.SaveToFile(aValue);
end;

function TModelFileControl.Text: String;
begin
  Result := FStringList.Text;
end;

end.
