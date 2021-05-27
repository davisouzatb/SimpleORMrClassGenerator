unit Model.Generator;

interface

uses
  Model.Interfaces,
  Model.Generator.Params,
  Model.EntityGenerate,
  Model.ModelGenerate,
  Model.RoutersGenerate;

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
        function ModelGenerate: iModelModelGenerate;
        function RoutersGenerate: iModelRoutersGenerate;
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

function TModelGenerator.ModelGenerate: iModelModelGenerate;
begin
  Result := TModelModelGenerate.New(Self);
end;

class function TModelGenerator.New: iModelGenerator;
begin
  Result := Self.Create;
end;

function TModelGenerator.Params: iModelGeneratorParams;
begin
  Result := FParams;
end;

function TModelGenerator.RoutersGenerate: iModelRoutersGenerate;
begin
  Result := TModelRoutersGenerate.New(Self);
end;

end.
