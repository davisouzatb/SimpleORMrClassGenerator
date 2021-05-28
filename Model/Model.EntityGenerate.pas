unit Model.EntityGenerate;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Model.Interfaces,
  Model.Util,
  Model.DAO.Interfaces,
  Model.DAO.Connection.FireDac;

type
  TModelEntityGenerate = class(TInterfacedObject, iModelEntityGenerate)
      private
        [weak]
        FConnection : iModelDAOConnection;
        FDisplay : TProc<string>;
        FDiretorio : String;
        FPrefixo : String;
        FTabela : String;
        FCaptalizar : Boolean;
        FRemoverCaracter : Boolean;
        function GetFieldType( aClassName : String) : String;
        function FormataNome( aValue : String) : String;
      public
        constructor Create;
        Destructor Destroy; override;
        class function New : iModelEntityGenerate;
        function Connection( aConnection : iModelDAOConnection) : iModelEntityGenerate;
        function Captalizar( aValue: Boolean) : iModelEntityGenerate;
        function RemoverCaracter( aValue: Boolean) : iModelEntityGenerate;
        function Dispay( aDisplay : TProc<string>) : iModelEntityGenerate;
        function Diretorio( aValue : String) : iModelEntityGenerate;
        function Prefixo( aValue : String) : iModelEntityGenerate;
        function Tabela( aValue : String) : iModelEntityGenerate;
        function Generate: iModelEntityGenerate;
  end;

implementation

{ TModelEntityGenerate }

function TModelEntityGenerate.Captalizar(aValue: Boolean): iModelEntityGenerate;
begin
  Result := Self;
  FCaptalizar := aValue;
end;

function TModelEntityGenerate.Connection(aConnection: iModelDAOConnection): iModelEntityGenerate;
begin
  Result := Self;
  FConnection := aConnection;
end;

constructor TModelEntityGenerate.Create;
begin
  FCaptalizar := False;
  FRemoverCaracter := False;
end;

destructor TModelEntityGenerate.Destroy;
begin

  inherited;
end;

function TModelEntityGenerate.Diretorio(aValue: String): iModelEntityGenerate;
begin
  Result := Self;
  FDiretorio := aValue;
end;

function TModelEntityGenerate.Dispay(aDisplay: TProc<string>): iModelEntityGenerate;
begin
  Result := Self;
  FDisplay := aDisplay;
end;

function TModelEntityGenerate.Generate: iModelEntityGenerate;
var
  i: Integer;
  campo: string;
  FQuery: iModelDAOConnectionQuery;
  mUnit: TStringList;
begin
  Result := Self;

  mUnit := TStringList.Create;
  try
    FQuery := TModelDAOConnectionQuery.New(FConnection);

    FQuery
      .SQLClear
      .SQL('select * from '+ FTabela)
    .Open;

    mUnit.Clear;
    mUnit.Add('unit ' + FPrefixo + '.' + FormataNome(FTabela) + ';');
    mUnit.Add('');
    mUnit.Add('interface');
    mUnit.Add('');
    mUnit.Add('uses');
    mUnit.Add('  System.Generics.Collections,');
    mUnit.Add('  System.Classes,');
    mUnit.Add('  Rest.Json,');
    mUnit.Add('  System.JSON,');
    mUnit.Add('  SimpleAttributes;');
    mUnit.Add('');
    mUnit.Add('type');
    mUnit.Add('  [Tabela(' + QuotedStr(RemoveAcento(FTabela)) + ')]');
    mUnit.Add('  T' + FormataNome(FTabela) + ' = class');
    mUnit.Add('  private');
    for I := 0 to FQuery.DataSet.FieldCount - 1 do
    begin
      campo := GetFieldType(FQuery.DataSet.Fields[i].ClassName) + ';';
      mUnit.Add('    F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ': ' + campo);
    end;
    mUnit.Add('');
    mUnit.Add('  public');
    mUnit.Add('    constructor Create;');
    mUnit.Add('    destructor Destroy; override;');
    mUnit.Add('');
    mUnit.Add('  published');
    mUnit.Add('{verificar os atributos do campo de chave primária}');
    mUnit.Add('{Exemplo: [Campo(' + QuotedStr('NOME_CAMPO') + '), PK, AutoInc] }');
    for I := 0 to FQuery.DataSet.FieldCount - 1 do
    begin
      campo := GetFieldType(FQuery.DataSet.Fields[i].ClassName);
      if I = 0 then
        mUnit.Add('    [Campo(' + quotedstr(RemoveAcento(FQuery.DataSet.Fields[i].FieldName)) + '), PK, AutoInc]')
      else
        mUnit.Add('    [Campo(' + quotedstr(RemoveAcento(FQuery.DataSet.Fields[i].FieldName)) + ')]');
      mUnit.Add('    property ' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ': ' + campo + ' read F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ' write F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ';');
    end;
    mUnit.Add('');
    mUnit.Add('    function ToJSONObject: TJsonObject;');
    mUnit.Add('    function ToJsonString: string;');
    mUnit.Add('');
    mUnit.Add('  end;');
    mUnit.Add('');
    mUnit.Add('implementation');
    mUnit.Add('');
    mUnit.Add('constructor T' + FormataNome(FTabela) + '.Create;');
    mUnit.Add('begin');
    mUnit.Add('');
    mUnit.Add('end;');
    mUnit.Add('');
    mUnit.Add('destructor T' + FormataNome(FTabela) + '.Destroy;');
    mUnit.Add('begin');
    mUnit.Add('');
    mUnit.Add('  inherited;');
    mUnit.Add('end;');
    mUnit.Add('');
    mUnit.Add('function T' + FormataNome(FTabela) + '.ToJSONObject: TJsonObject;');
    mUnit.Add('begin');
    mUnit.Add('  Result := TJson.ObjectToJsonObject(Self);');
    mUnit.Add('end;');
    mUnit.Add('');
    mUnit.Add('function T' + FormataNome(FTabela) + '.ToJsonString: string;');
    mUnit.Add('begin');
    mUnit.Add('  result := TJson.ObjectToJsonString(self);');
    mUnit.Add('end;');
    mUnit.Add('');
    mUnit.Add('end.');

    if not DirectoryExists(FDiretorio) then
      CreateDir(FDiretorio);
    mUnit.SaveToFile(FDiretorio+'\'+FPrefixo+'.'+FormataNome(FTabela)+'.pas');

    if Assigned(FDisplay) then
     FDisplay(mUnit.Text);
  finally
    mUnit.DisposeOf
  end;
end;

function TModelEntityGenerate.GetFieldType(aClassName: String): String;
const _Real    = 'double';
      _Integer = 'integer';
      _string  = 'string';
      _Date    = 'TDate';
      _DateTime= 'TDateTime';
      _Blob    = 'TBlobField';
begin
  if aClassName = 'TIntegerField' then
    Result := _Integer
  else if aClassName = 'TSmallintField' then
    Result := _Integer
  else if aClassName = 'TLargeintField' then
    Result := _Integer
  else if aClassName = 'TIBStringField' then
    Result := _string
  else if aClassName = 'TDateField' then
    Result := _Date
  else if aClassName = 'TSQLTimeStampField' then
    Result := _DateTime
  else if aClassName = 'TBCDField' then
    Result := _Real
  else if aClassName = 'TIBBCDField' then
    Result := _Real
  else if aClassName = 'TFMTBCDField' then
    Result := _Real
  else if aClassName = 'TCurrencyField' then
    Result := _Real
  else if aClassName = 'TSingleField' then
    Result := _Real
  else if aClassName = 'TStringField' then
    Result := _string
  else if aClassName = 'TFloatField' then
    Result := _Real
   else if aClassName = 'TBlobField' then
    Result := _Blob
  else
    Result := _string+ '   {'+aClassName+'}';
end;

function TModelEntityGenerate.FormataNome(aValue: String): String;
begin
  Result := Capitaliza(RemoveAcento(aValue) , FCaptalizar, FRemoverCaracter);
end;

class function TModelEntityGenerate.New: iModelEntityGenerate;
begin
  Result := Self.Create;
end;

function TModelEntityGenerate.Prefixo(aValue: String): iModelEntityGenerate;
begin
  Result := Self;
  FPrefixo := aValue;
end;

function TModelEntityGenerate.RemoverCaracter(aValue: Boolean): iModelEntityGenerate;
begin
  Result := Self;
  FRemoverCaracter := aValue;
end;

function TModelEntityGenerate.Tabela(aValue: String): iModelEntityGenerate;
begin
  Result := Self;
  FTabela := aValue;
end;

end.
