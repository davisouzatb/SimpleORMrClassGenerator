unit Model.ModelGenerate;

interface

uses
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  Model.Interfaces,
  Model.FileControl,
  Model.Util;

type
  TModelModelGenerate = class(TInterfacedObject, iModelModelGenerate)
      private
        [weak]
        FParent : iModelGenerator;
        FTabelas :TStrings;
        function PrefixoProjeto : String;
        function FormataNome( aValue : String) : String;
        function ModelDAO : String;
        function ControllerInterfaces : String;
        function ControllerGeneric : string;
        function Controller : string;
      public
        constructor Create( aParent : iModelGenerator);
        Destructor Destroy; override;
        class function New( aParent : iModelGenerator) : iModelModelGenerate;
        function Generate : iModelModelGenerate;
        function Tabelas(aValue : TStrings) : iModelModelGenerate;
        function &End :iModelGenerator;
  end;

implementation

{ TModelModelGenerate }

function TModelModelGenerate.&End: iModelGenerator;
begin
  Result := FParent;
end;

function TModelModelGenerate.FormataNome(aValue: String): String;
begin
  Result := Capitaliza(RemoveAcento(aValue) , FParent.Params.Captalizar, FParent.Params.RemoverCaracter);
end;

function TModelModelGenerate.Controller: string;
var
  mUnit: iModelFileControl;
  vTabela : String;
begin
  mUnit := TModelFileControl.New;

  mUnit
    .Clear
    .Add('unit ' + PrefixoProjeto + 'Controller;')
    .Add('')
    .Add('interface')
    .Add('')
    .Add('uses');
     for vTabela in FTabelas do
      mUnit.Add('  ' + PrefixoProjeto + 'Model.Entity.'+FormataNome(vTabela)+',');

    mUnit
    .Add('  ' + PrefixoProjeto + 'Controller.Generic,')
    .Add('  ' + PrefixoProjeto + 'Controller.Interfaces;')
    .Add('')
    .Add('type')
    .Add('  TController = class(TInterfacedObject, iController)')
    .Add('    private');

    for vTabela in FTabelas do
      mUnit.Add('      F'+FormataNome(vTabela)+' : iControllerEntity<T'+FormataNome(vTabela)+'>;');

    mUnit
    .Add('    public')
    .Add('      constructor Create;')
    .Add('      destructor Destroy; override;')
    .Add('      class function New : iController;');

    for vTabela in FTabelas do
      mUnit.Add('      function '+FormataNome(vTabela)+' : iControllerEntity<T'+FormataNome(vTabela)+'>;');

    mUnit
    .Add('  end;')
    .Add('')
    .Add('implementation')
    .Add('')
    .Add('{ TController }')
    .Add('');

    for vTabela in FTabelas do
      mUnit.Add('function TController.'+FormataNome(vTabela)+': iControllerEntity<T'+FormataNome(vTabela)+'>;')
      .Add('begin')
      .Add('  if not Assigned(F'+FormataNome(vTabela)+') then')
      .Add('    F'+FormataNome(vTabela)+' := TControllerGeneric<T'+FormataNome(vTabela)+'>.New(Self);')
      .Add('')
      .Add('  Result := F'+FormataNome(vTabela)+';')
      .Add('end;')
      .Add('');

    mUnit
    .Add('constructor TController.Create;')
    .Add('begin')
    .Add('')
    .Add('end;')
    .Add('')
    .Add('destructor TController.Destroy;')
    .Add('begin')
    .Add('')
    .Add('  inherited;')
    .Add('end;')
    .Add('')
    .Add('class function TController.New: iController;')
    .Add('begin')
    .Add('    Result := Self.Create;')
    .Add('end;')
    .Add('')
    .Add('end.')

    .SaveToFile(FParent.Params.Diretorio+'\Controller\'+PrefixoProjeto+'Controller.pas');

  Result := mUnit.Text;
end;

function TModelModelGenerate.ControllerGeneric: string;
var
  mUnit: iModelFileControl;
begin
  mUnit := TModelFileControl.New;

  mUnit
    .Clear
    .Add('unit ' + PrefixoProjeto + 'Controller.Generic;')
    .Add('')
    .Add('interface')
    .Add('')
    .Add('uses')
    .Add('  ' + PrefixoProjeto + 'Model.DAO,')
    .Add('  ' + PrefixoProjeto + 'Controller.Interfaces;')
    .Add('')
    .Add('type')
    .Add('  TControllerGeneric<T : class, constructor> = class(TInterfacedObject, iControllerEntity<T>)')
    .Add('    private')
    .Add('      FModel : iDAOGeneric<T>;')
    .Add('      [weak]')
    .Add('      FParent : iController;')
    .Add('    public')
    .Add('      constructor Create(Parent : iController);')
    .Add('      destructor Destroy; override;')
    .Add('      class function New(Parent : iController) : iControllerEntity<T>;')
    .Add('      function This : iDAOGeneric<T>;')
    .Add('      function &End : iController;')
    .Add('  end;')
    .Add('')
    .Add('implementation')
    .Add('')
    .Add('{ TControllerGeneric }')
    .Add('')
    .Add('function TControllerGeneric<T>.&End: iController;')
    .Add('begin')
    .Add('  Result := FParent;')
    .Add('end;')
    .Add('')
    .Add('constructor TControllerGeneric<T>.Create(Parent : iController);')
    .Add('begin')
    .Add('  FParent := Parent;')
    .Add('  FModel := TDAOGeneric<T>.New;')
    .Add('end;')
    .Add('')
    .Add('destructor TControllerGeneric<T>.Destroy;')
    .Add('begin')
    .Add('')
    .Add('  inherited;')
    .Add('end;')
    .Add('')
    .Add('class function TControllerGeneric<T>.New(Parent : iController): iControllerEntity<T>;')
    .Add('begin')
    .Add('    Result := Self.Create(Parent);')
    .Add('end;')
    .Add('')
    .Add('function TControllerGeneric<T>.This: iDAOGeneric<T>;')
    .Add('begin')
    .Add('  Result := FModel;')
    .Add('end;')
    .Add('')
    .Add('end.')

    .SaveToFile(FParent.Params.Diretorio+'\Controller\'+PrefixoProjeto+'Controller.Generic.pas');

  Result := mUnit.Text;
end;

function TModelModelGenerate.ControllerInterfaces: String;
var
  mUnit: iModelFileControl;
  vTabela : String;
begin
  mUnit := TModelFileControl.New;

  mUnit
    .Clear
    .Add('unit ' + PrefixoProjeto + 'Controller.Interfaces;')
    .Add('')
    .Add('interface')
    .Add('')
    .Add('uses');

    for vTabela in FTabelas do
      mUnit.Add('  ' + PrefixoProjeto + 'Model.Entity.'+FormataNome(vTabela)+',');

    mUnit
    .Add('  ' + PrefixoProjeto + 'Model.DAO;')
    .Add('')
    .Add('type')
    .Add('  iControllerEntity<T : class> = interface;')
    .Add('')
    .Add('  iController = interface')
    .Add('    ['+GerarAssinatura+']');

    for vTabela in FTabelas do
      mUnit.Add('    function '+FormataNome(vTabela)+' : iControllerEntity<T'+FormataNome(vTabela)+'>;');

    mUnit
    .Add('  end;')
    .Add('')
    .Add('  iControllerEntity<T : class> = interface')
    .Add('    ['+GerarAssinatura+']')
    .Add('    function This : iDAOGeneric<T>;')
    .Add('    function &End : iController;')
    .Add('  end;')
    .Add('')
    .Add('implementation')
    .Add('')
    .Add('end.');

  mUnit.SaveToFile(FParent.Params.Diretorio+'\Controller\'+PrefixoProjeto+'Controller.Interfaces.pas');

  Result := mUnit.Text;
end;

constructor TModelModelGenerate.Create( aParent : iModelGenerator);
begin
  FParent := aParent;
end;

destructor TModelModelGenerate.Destroy;
begin

  inherited;
end;

function TModelModelGenerate.Generate: iModelModelGenerate;
begin
  Result := Self;

  FParent
    .Params
    .Display(ModelDAO)
    .Display('')
    .Display('--------------------------------------------------------------------')
    .Display('')
    .Display(ControllerInterfaces)
    .Display('')
    .Display('--------------------------------------------------------------------')
    .Display('')
    .Display(ControllerGeneric)
    .Display('')
    .Display('--------------------------------------------------------------------')
    .Display('')
    .Display(Controller);
end;

function TModelModelGenerate.ModelDAO: String;
var
  mUnit: iModelFileControl;
begin
  mUnit := TModelFileControl.New;

  mUnit
    .Clear
    .Add('unit ' + PrefixoProjeto + 'Model.DAO;')
    .Add('')
    .Add('interface')
    .Add('')
    .Add('uses')
    .Add('  System.JSON,')
    .Add('  REST.Json,')
    .Add('  SimpleInterface,')
    .Add('  SimpleDAO,')
    .Add('  SimpleAttributes,')
    .Add('  SimpleQueryFiredac,')
    .Add('  Data.DB,')
    .Add('  DataSet.Serialize,')
    .Add('  FireDAC.Stan.Intf,')
    .Add('  FireDAC.Stan.Option,')
    .Add('  FireDAC.Stan.Param,')
    .Add('  FireDAC.Stan.Error,')
    .Add('  FireDAC.DatS,')
    .Add('  FireDAC.Phys.Intf,')
    .Add('  FireDAC.DApt.Intf,')
    .Add('  FireDAC.Comp.DataSet,')
    .Add('  FireDAC.Comp.Client;')
    .Add('')
    .Add('type')
    .Add('')
    .Add('  iDAOGeneric<T : class> = interface')
    .Add('    ['+GerarAssinatura+']')
    .Add('    function Find : TJsonArray; overload;')
    .Add('    function Find (const aID : String ) : TJsonObject; overload;')
    .Add('    function Insert (const aJsonObject : TJsonObject) : TJsonObject;')
    .Add('    function Update (const aJsonObject : TJsonObject) : TJsonObject;')
    .Add('    function Delete (aField : String; aValue : String) : TJsonObject;')
    .Add('    function DAO : ISimpleDAO<T>;')
    .Add('    function DataSetAsJsonArray : TJsonArray;')
    .Add('    function DataSetAsJsonObject : TJsonObject;')
    .Add('    function DataSetToStream : String;')
    .Add('  end;')
    .Add('')
    .Add('  TDAOGeneric<T : class, constructor> = class(TInterfacedObject, iDAOGeneric<T>)')
    .Add('  private')
    .Add('    FIndexConn : Integer;')
    .Add('    FConn : iSimpleQuery;')
    .Add('    FDAO : iSimpleDAO<T>;')
    .Add('    FDataSource : TDataSource;')
    .Add('  public')
    .Add('    constructor Create;')
    .Add('    destructor Destroy; override;')
    .Add('    class function New : iDAOGeneric<T>;')
    .Add('    function Find : TJsonArray; overload;')
    .Add('    function Find (const aID : String ) : TJsonObject; overload;')
    .Add('    function Insert (const aJsonObject : TJsonObject) : TJsonObject;')
    .Add('    function Update (const aJsonObject : TJsonObject) : TJsonObject;')
    .Add('    function Delete (aField : String; aValue : String) : TJsonObject;')
    .Add('    function DAO : ISimpleDAO<T>;')
    .Add('    function DataSetAsJsonArray : TJsonArray;')
    .Add('    function DataSetAsJsonObject : TJsonObject;')
    .Add('    function DataSetToStream : String;')
    .Add('  end;')
    .Add('')
    .Add('implementation')
    .Add('')
    .Add('{ TDAOGeneric<T> }')
    .Add('')
    .Add('uses')
    .Add('  System.SysUtils,')
    .Add('  ' + PrefixoProjeto + 'Model.Connection,')
    .Add('  System.Classes,')
    .Add('  GBJSON.Helper,')
    .Add('  GBJSON.Interfaces;')
    .Add('')
    .Add('constructor TDAOGeneric<T>.Create;')
    .Add('begin')
    .Add('  FDataSource := TDataSource.Create(nil);')
    .Add('  FIndexConn := ' + PrefixoProjeto + 'Model.Connection.Connected;')
    .Add('  FConn := TSimpleQueryFiredac.New(' + PrefixoProjeto + 'Model.Connection.FConnList.Items[FIndexConn]);')
    .Add('  FDAO := TSimpleDAO<T>.New(FConn).DataSource(FDataSource);')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.DAO: ISimpleDAO<T>;')
    .Add('begin')
    .Add('  Result := FDAO;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.DataSetAsJsonArray: TJsonArray;')
    .Add('begin')
    .Add('  Result := FDataSource.DataSet.ToJSONArray;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.DataSetAsJsonObject: TJsonObject;')
    .Add('begin')
    .Add('  Result := FDataSource.DataSet.ToJSONObject;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.DataSetToStream: String;')
    .Add('var')
    .Add('  lStream : TStringStream;')
    .Add('  FDMemTable : TFDMemTable;')
    .Add('begin')
    .Add('  lStream := TStringStream.Create;')
    .Add('  FDMemTable := TFDMemTable.Create(nil);')
    .Add('  try')
    .Add('    FDMemTable.Assign(FDataSource.DataSet);')
    .Add('    FDMemTable.SaveToStream(lStream, sfJSON);')
    .Add('    lStream.Position := 0;')
    .Add('    Result := lStream.DataString;')
    .Add('  finally')
    .Add('    lStream.Free;')
    .Add('    FDMemTable.Free;')
    .Add('  end;')
    .Add('')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.Delete(aField, aValue: String): TJsonObject;')
    .Add('begin')
    .Add('  FDAO.Delete(aField, aValue);')
    .Add('  Result := FDataSource.DataSet.ToJSONObject;')
    .Add('end;')
    .Add('')
    .Add('destructor TDAOGeneric<T>.Destroy;')
    .Add('begin')
    .Add('  FDataSource.Free;')
    .Add('  ' + PrefixoProjeto + 'Model.Connection.Disconnected(FIndexConn);')
    .Add('  inherited;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.Find(const aID: String): TJsonObject;')
    .Add('begin')
    .Add('  FDAO.Find(StrToInt(aID));')
    .Add('  Result := FDataSource.DataSet.ToJSONObject;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.Find: TJsonArray;')
    .Add('var')
    .Add('  ateste: Integer;')
    .Add('  ateste2: string;')
    .Add('begin')
    .Add('  FDAO.Find(False);')
    .Add('  Result := FDataSource.DataSet.ToJSONArray;')
    .Add('end;')
    .Add('')
    .Add('class function TDAOGeneric<T>.New: iDAOGeneric<T>;')
    .Add('begin')
    .Add('  Result := Self.Create;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.Insert(const aJsonObject: TJsonObject): TJsonObject;')
    .Add('var')
    .Add('  aObj : T;')
    .Add('begin')
    .Add('  aObj := T.Create;')
    .Add('  try')
    .Add('    TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);')
    .Add('    TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(aObj, aJsonObject);')
    .Add('    aObj.fromJSONObject(aJsonObject);')
    .Add('    FDAO.Insert(aObj);')
    .Add('    Result := FDataSource.DataSet.ToJSONObject;')
    .Add('  finally')
    .Add('    aObj.Free;')
    .Add('  end;')
    .Add('end;')
    .Add('')
    .Add('function TDAOGeneric<T>.Update(const aJsonObject: TJsonObject): TJsonObject;')
    .Add('var')
    .Add('  aObj : T;')
    .Add('begin')
    .Add('  aObj := T.Create;')
    .Add('  try')
    .Add('    TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);')
    .Add('    TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(aObj, aJsonObject);')
    .Add('    aObj.fromJSONObject(aJsonObject);')
    .Add('    FDAO.Update(aObj);')
    .Add('    Result := FDataSource.DataSet.ToJSONObject;')
    .Add('  finally')
    .Add('    aObj.Free;')
    .Add('  end;')
    .Add('end;')
    .Add('')
    .Add('end.')

    .SaveToFile(FParent.Params.Diretorio+'\Model\DAO\'+PrefixoProjeto+'Model.DAO.pas');

  Result := mUnit.Text;
end;

class function TModelModelGenerate.New( aParent : iModelGenerator) : iModelModelGenerate;
begin
  Result := Self.Create(aParent);
end;

function TModelModelGenerate.PrefixoProjeto: String;
begin
  Result := ifThen(FParent.Params.Projeto.Trim.IsEmpty,
                   '',
                   FParent.Params.Projeto.Trim+'.');
end;

function TModelModelGenerate.Tabelas(aValue: TStrings): iModelModelGenerate;
begin
  Result := Self;
  FTabelas := aValue;
end;

end.
