unit Model.Generator;

interface

uses
  Model.Interfaces,
  Model.Generator.Params,
  Model.EntityGenerate;

type
  TModelGenerator = class(TInterfacedObject, iModelGenerator)
      private
        FParams : iModelGeneratorParams;
      public
        constructor Create;
        Destructor Destroy; override;
        class function New : iModelGenerator;
        function Params : iModelGeneratorParams;
        function EntityGenerate: iModelEntityGenerate;
        function ModelGenerate: iModelGenerator;
  end;

implementation

{ TModelEntityGenerate }


constructor TModelGenerator.Create;
begin
  FParams := TModelGeneratorParams.New(Self);
end;

destructor TModelGenerator.Destroy;
begin

  inherited;
end;

function TModelGenerator.EntityGenerate: iModelEntityGenerate;
begin
  Result := TModelEntityGenerate.New(Self);
end;

function TModelGenerator.ModelGenerate: iModelGenerator;
begin
//
end;

class function TModelGenerator.New: iModelGenerator;
begin
  Result := Self.Create;
end;

function TModelGenerator.Params: iModelGeneratorParams;
begin
  Result := FParams;
end;

end.
