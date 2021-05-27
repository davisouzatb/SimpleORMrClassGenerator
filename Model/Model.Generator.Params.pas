unit Model.Generator.Params;

interface

uses
  System.SysUtils,
  Model.Interfaces;

type
  TModelGeneratorParams = class(TInterfacedObject, iModelGeneratorParams)
      private
        [weak]
        FParent : iModelGenerator;
        FDisplay : TProc<string>;
        FDiretorio : String;
        FPrefixo : String;
        FProjeto : String;
        FCaptalizar : Boolean;
        FRemoverCaracter : Boolean;
      public
        constructor Create( aParent : iModelGenerator);
        Destructor Destroy; override;
        class function New( aParent : iModelGenerator) : iModelGeneratorParams;
        function Captalizar( aValue: Boolean) : iModelGeneratorParams; overload;
        function Captalizar: Boolean; overload;
        function RemoverCaracter( aValue: Boolean) : iModelGeneratorParams; overload;
        function RemoverCaracter: Boolean; overload;
        function Display( aDisplay : TProc<string>) : iModelGeneratorParams; overload;
        function Display(aValue : String): iModelGeneratorParams; overload;
        function Diretorio( aValue : String) : iModelGeneratorParams; overload;
        function Diretorio : String; overload;
        function Prefixo( aValue : String) : iModelGeneratorParams; overload;
        function Prefixo: String; overload;
        function Projeto( aValue : String) : iModelGeneratorParams; overload;
        function Projeto: String; overload;
        function &End :iModelGenerator;
  end;

implementation

{ TModelGeneratorParams }

function TModelGeneratorParams.Captalizar(aValue: Boolean): iModelGeneratorParams;
begin
  Result := Self;
  FCaptalizar := aValue;
end;

function TModelGeneratorParams.Captalizar: Boolean;
begin
  Result := FCaptalizar;
end;

function TModelGeneratorParams.&End: iModelGenerator;
begin
  Result := FParent;
end;

constructor TModelGeneratorParams.Create( aParent : iModelGenerator);
begin
  FCaptalizar := False;
  FRemoverCaracter := False;
  FProjeto := '';
  FParent := aParent;
end;

destructor TModelGeneratorParams.Destroy;
begin

  inherited;
end;

function TModelGeneratorParams.Diretorio(aValue: String): iModelGeneratorParams;
begin
  Result := Self;
  FDiretorio := aValue;
end;

function TModelGeneratorParams.Diretorio: String;
begin
  Result := FDiretorio;
end;

function TModelGeneratorParams.Display(aValue : String): iModelGeneratorParams;
begin
  Result := Self;
  FDisplay(aValue);
end;

function TModelGeneratorParams.Display(aDisplay: TProc<string>): iModelGeneratorParams;
begin
  Result := Self;
  FDisplay := aDisplay;
end;

class function TModelGeneratorParams.New( aParent : iModelGenerator) : iModelGeneratorParams;
begin
  Result := Self.Create(aParent);
end;

function TModelGeneratorParams.Prefixo: String;
begin
  Result := FPrefixo;
end;

function TModelGeneratorParams.Projeto: String;
begin
  Result := FProjeto;
end;

function TModelGeneratorParams.Projeto(aValue: String): iModelGeneratorParams;
begin
  Result := Self;
  FProjeto := aValue;
end;

function TModelGeneratorParams.Prefixo(aValue: String): iModelGeneratorParams;
begin
  Result := Self;
  FPrefixo := aValue;
end;

function TModelGeneratorParams.RemoverCaracter(aValue: Boolean): iModelGeneratorParams;
begin
  Result := Self;
  FRemoverCaracter := aValue;
end;

function TModelGeneratorParams.RemoverCaracter: Boolean;
begin
  Result := FRemoverCaracter;
end;

end.
