unit Model.EntityGenerate;

interface

uses
  System.StrUtils,
  System.SysUtils,
  Data.DB,
  Model.Interfaces,
  Model.DAO.Interfaces,
  Model.DAO.Connection.FireDac,
  Model.FileControl,
  Model.Util;

type
  TModelEntityGenerate = class(TInterfacedObject, iModelEntityGenerate)
      private
        [weak]
        FParent : iModelGenerator;
        [weak]
        FConnection : iModelDAOConnection;
        FTabela : String;
        function PrefixoProjeto : String;
        function FormataNome( aValue : String) : String;
        function GetFieldType( aClassName : String) : String;
      public
        constructor Create( aParent : iModelGenerator);
        Destructor Destroy; override;
        class function New( aParent : iModelGenerator) : iModelEntityGenerate;
        function Connection( aConnection : iModelDAOConnection) : iModelEntityGenerate;
        function Tabela( aValue : String) : iModelEntityGenerate;
        function Generate : iModelEntityGenerate;
        function &End :iModelGenerator;

  end;

implementation

{ TModelEntityGenerate }

function TModelEntityGenerate.Connection( aConnection : iModelDAOConnection) : iModelEntityGenerate;
begin
  Result := Self;
  FConnection := aConnection;
end;

constructor TModelEntityGenerate.Create( aParent : iModelGenerator);
begin
  FParent := aParent;
end;

destructor TModelEntityGenerate.Destroy;
begin

  inherited;
end;

function TModelEntityGenerate.FormataNome(aValue: String): String;
begin
 Result := Capitaliza(RemoveAcento(aValue) , FParent.Params.Captalizar, FParent.Params.RemoverCaracter);
end;

function TModelEntityGenerate.Generate: iModelEntityGenerate;
var
  i: Integer;
  campo: string;
  FQuery: iModelDAOConnectionQuery;
  mUnit: iModelFileControl;
begin
  Result := Self;

  FQuery := TModelDAOConnectionQuery.New(FConnection);

  FQuery
    .SQLClear
    .SQL('select * from '+ FTabela)
    .SQL('where 1 > 1 ')
  .Open;

  mUnit := TModelFileControl.New;
  mUnit
    .Clear
    .Add('unit ' + PrefixoProjeto + FParent.Params.Prefixo + '.' + FormataNome(FTabela) + ';')
    .Add('')
    .Add('interface')
    .Add('')
    .Add('uses')
    .Add('  System.Generics.Collections,')
    .Add('  System.Classes,')
    .Add('  Data.DB,')
    .Add('  Rest.Json,')
    .Add('  System.JSON,')
    .Add('  SimpleAttributes;')
    .Add('')
    .Add('type')
    .Add('  [Tabela(' + QuotedStr(RemoveAcento(FTabela)) + ')]')
    .Add('  T' + FormataNome(FTabela) + ' = class')
    .Add('  private');

  for I := 0 to FQuery.DataSet.FieldCount - 1 do
  begin
    campo := GetFieldType(FQuery.DataSet.Fields[i].ClassName) + ';';
    mUnit.Add('    F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ': ' + campo);
  end;

  mUnit
    .Add('')
    .Add('  public')
    .Add('    constructor Create;')
    .Add('    destructor Destroy; override;')
    .Add('')
    .Add('  published')
    .Add('{verificar os atributos do campo de chave primária}')
    .Add('{Exemplo: [Campo(' + QuotedStr('NOME_CAMPO') + '), PK, AutoInc] }');

  for I := 0 to FQuery.DataSet.FieldCount - 1 do
  begin
    campo := GetFieldType(FQuery.DataSet.Fields[i].ClassName);
    if I = 0 then
      mUnit.Add('    [Campo(' + quotedstr(RemoveAcento(FQuery.DataSet.Fields[i].FieldName)) + '), PK, AutoInc]')
    else
      mUnit.Add('    [Campo(' + quotedstr(RemoveAcento(FQuery.DataSet.Fields[i].FieldName)) + ')]');
    mUnit.Add('    property ' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ': ' + campo + ' read F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ' write F' + FormataNome(FQuery.DataSet.Fields[i].FieldName) + ';');
  end;

  mUnit
    .Add('')
    .Add('    function ToJSONObject: TJsonObject;')
    .Add('    function ToJsonString: string;')
    .Add('')
    .Add('  end;')
    .Add('')
    .Add('implementation')
    .Add('')
    .Add('constructor T' + FormataNome(FTabela) + '.Create;')
    .Add('begin')
    .Add('')
    .Add('end;')
    .Add('')
    .Add('destructor T' + FormataNome(FTabela) + '.Destroy;')
    .Add('begin')
    .Add('')
    .Add('  inherited;')
    .Add('end;')
    .Add('')
    .Add('function T' + FormataNome(FTabela) + '.ToJSONObject: TJsonObject;')
    .Add('begin')
    .Add('  Result := TJson.ObjectToJsonObject(Self);')
    .Add('end;')
    .Add('')
    .Add('function T' + FormataNome(FTabela) + '.ToJsonString: string;')
    .Add('begin')
    .Add('  result := TJson.ObjectToJsonString(self);')
    .Add('end;')
    .Add('')
    .Add('end.')

    .SaveToFile(FParent.Params.Diretorio+'\Model\Entity\'+PrefixoProjeto +  FParent.Params.Prefixo+'.'+FormataNome(FTabela)+'.pas');

   FParent.Params.Display(mUnit.Text);
end;

function TModelEntityGenerate.GetFieldType(aClassName: String): String;
const _Real    = 'double';
      _Integer = 'integer';
      _string  = 'string';
      _Date    = 'TDate';
      _DateTime= 'TDateTime';
      _Blob    = 'string';
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

class function TModelEntityGenerate.New( aParent : iModelGenerator) : iModelEntityGenerate;
begin
  Result := Self.Create( aParent);
end;

function TModelEntityGenerate.PrefixoProjeto: String;
begin
  Result := ifThen(FParent.Params.Projeto.Trim.IsEmpty,
                   '',
                   FParent.Params.Projeto.Trim+'.');
end;

function TModelEntityGenerate.Tabela( aValue : String) : iModelEntityGenerate;
begin
  Result := Self;
  FTabela := aValue;
end;

function TModelEntityGenerate.&End: iModelGenerator;
begin
  Result := FParent;
end;

end.
