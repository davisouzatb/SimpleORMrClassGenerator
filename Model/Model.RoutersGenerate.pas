unit Model.RoutersGenerate;

interface

uses
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  Model.Interfaces,
  Model.FileControl,
  Model.Util, Model.DAO.Interfaces, Model.DAO.Connection.FireDac;

type
  TModelRoutersGenerate = class(TInterfacedObject, iModelRoutersGenerate)
      private
        [weak]
        FParent : iModelGenerator;
        [weak]
        FConnection : iModelDAOConnection;
        FTabelas :TStrings;
        function PrefixoProjeto : String;
        function FormataNome( aValue : String) : String;
        function Routers : string;
      public
        constructor Create( aParent : iModelGenerator);
        Destructor Destroy; override;
        class function New( aParent : iModelGenerator) : iModelRoutersGenerate;
        function Connection( aConnection : iModelDAOConnection) : iModelRoutersGenerate;
        function Generate : iModelRoutersGenerate;
        function Tabelas(aValue : TStrings) : iModelRoutersGenerate;
        function &End :iModelGenerator;
  end;

implementation

{ TModelRoutersGenerate }

function TModelRoutersGenerate.&End: iModelGenerator;
begin
  Result := FParent;
end;

function TModelRoutersGenerate.FormataNome(aValue: String): String;
begin
  Result := Capitaliza(RemoveAcento(aValue) , FParent.Params.Captalizar, FParent.Params.RemoverCaracter);
end;

function TModelRoutersGenerate.Routers: string;
var
  mUnit: iModelFileControl;
  FQuery: iModelDAOConnectionQuery;
  vTabela : String;
begin
  mUnit := TModelFileControl.New;
  FParent.Params.Display('Adicionar os Register no Projeto');
  FParent.Params.Display('');
  FQuery := TModelDAOConnectionQuery.New(FConnection);
  for vTabela in FTabelas do
  begin
    FQuery
      .SQLClear
      .SQL('select * from '+ vTabela)
      .SQL('where 1 > 1 ')
    .Open;

    mUnit
      .Add('unit ' + PrefixoProjeto + 'Routers.' + FormataNome(vTabela) + ';')
      .Add('')
      .Add('interface')
      .Add('')
      .Add('uses')
      .Add('  System.JSON,')
      .Add('  System.Classes,')
      .Add('  System.SysUtils,')
      .Add('  ' + PrefixoProjeto + 'Model.Entity.'+FormataNome(vTabela)+',')
      .Add('  ' + PrefixoProjeto + 'Controller.Interfaces,')
      .Add('  ' + PrefixoProjeto + 'Utils,')
      .Add('  ' + PrefixoProjeto + 'Controller,')
      .Add('  Horse;')
      .Add('')
      .Add('procedure Registry;')
      .Add('procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('')
      .Add('implementation')
      .Add('')
      .Add('procedure Registry;')
      .Add('begin')
      .Add('  THorse')
      .Add('    .Get('+QuotedStr('/'+LowerCase(FormataNome(vTabela))+'')+', Get)')
      .Add('    .Get('+QuotedStr('/'+LowerCase(FormataNome(vTabela))+'/:id')+', GetID)')
      .Add('    .Post('+QuotedStr('/'+LowerCase(FormataNome(vTabela))+'')+', Insert)')
      .Add('    .Put('+QuotedStr('/'+LowerCase(FormataNome(vTabela))+'/:id')+', Update)')
      .Add('    .Delete('+QuotedStr('/'+LowerCase(FormataNome(vTabela))+'/:id')+', Delete);')
      .Add('end;')
      .Add('')
      .Add('procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('var')
      .Add('  iController : iControllerEntity<T'+FormataNome(vTabela)+'>;')
      .Add('begin')
      .Add('  iController := TController.New.'+FormataNome(vTabela)+';')
      .Add('  iController.This')
      .Add('    .DAO')
      .Add('      .SQL')
      .Add('        .Where(TServerUtils.New.LikeFind(Req))')
      .Add('        .OrderBy(TServerUtils.New.OrderByFind(Req))')
      .Add('      .&End')
      .Add('    .Find;')
      .Add('')
      .Add('  Res.Status(200).Send<TJsonArray>(iController.This.DataSetAsJsonArray);')
      .Add('end;')
      .Add('')
      .Add('procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('var')
      .Add('  iController : iControllerEntity<T'+FormataNome(vTabela)+'>;')
      .Add('begin')
      .Add('  iController := TController.New.'+FormataNome(vTabela)+';')
      .Add('  iController.This')
      .Add('    .DAO')
      .Add('      .SQL {Verificar ID da Tabela}')
      .Add('        .Where(' + quotedstr(RemoveAcento(FQuery.DataSet.Fields[0].FieldName)+'=') + ' + Req.Params['+ QuotedStr('id')+'])')
      .Add('      .&End')
      .Add('    .Find;')
      .Add(' ')
      .Add('  Res.Status(200).Send<TJsonArray>(iController.This.DataSetAsJsonArray);')
      .Add('end;')
      .Add('')
      .Add('procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('var')
      .Add('      vBody : TJsonObject;')
      .Add('      aGuuid: string;')
      .Add('begin')
      .Add('  vBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;')
      .Add('  try')
      .Add('    if not vBody.TryGetValue<String>('+ QuotedStr('guuid')+', aGuuid) then')
      .Add('      vBody.AddPair('+ QuotedStr('guuid')+', TServerUtils.New.AdjustGuuid(TGUID.NewGuid.ToString()));')
      .Add('    TController.New.'+FormataNome(vTabela)+'.This.Insert(vBody);')
      .Add('    Res.Status(200).Send<TJsonObject>(vBody);')
      .Add('  except')
      .Add('    Res.Status(500).Send('''');')
      .Add('  end;')
      .Add('end;')
      .Add('')
      .Add('procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('var')
      .Add('  vBody : TJsonObject;')
      .Add('  aGuuid: string;')
      .Add('begin')
      .Add('  vBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;')
      .Add('  try')
      .Add('    if not vBody.TryGetValue<String>('+ QuotedStr('guuid')+', aGuuid) then')
      .Add('      vBody.AddPair('+ QuotedStr('guuid')+', Req.Params['+ QuotedStr('id')+']);')
      .Add('    TController.New.'+FormataNome(vTabela)+'.This.Update(vBody);')
      .Add('    Res.Status(200).Send<TJsonObject>(vBody);')
      .Add('  except')
      .Add('    Res.Status(500).Send('''');')
      .Add('  end;')
      .Add('end;')
      .Add('')
      .Add('procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);')
      .Add('begin')
      .Add('  try')
      .Add('    TController.New.'+FormataNome(vTabela)+'.This.Delete('+ QuotedStr('guuid')+', QuotedStr(Req.Params['+ QuotedStr('id')+']));')
      .Add('    Res.Status(200).Send('''');')
      .Add('  except')
      .Add('    Res.Status(500).Send('''');')
      .Add('  end;')
      .Add('end;')
      .Add('')
      .Add('end.')

      .SaveToFile(FParent.Params.Diretorio+'\Routers\' + PrefixoProjeto + 'Routers.' + FormataNome(vTabela)+'.pas')
      .Clear;

      FParent.Params.Display(PrefixoProjeto + 'Routers.' + FormataNome(vTabela)+'.Registry;')
  end;

  Result := mUnit.Text;
end;

function TModelRoutersGenerate.Connection(aConnection: iModelDAOConnection): iModelRoutersGenerate;
begin
  Result := Self;
  FConnection := aConnection;
end;

constructor TModelRoutersGenerate.Create( aParent : iModelGenerator);
begin
  FParent := aParent;
end;

destructor TModelRoutersGenerate.Destroy;
begin

  inherited;
end;

function TModelRoutersGenerate.Generate: iModelRoutersGenerate;
begin
  Result := Self;

  FParent
    .Params
    .Display(Routers);
end;

class function TModelRoutersGenerate.New( aParent : iModelGenerator) : iModelRoutersGenerate;
begin
  Result := Self.Create(aParent);
end;

function TModelRoutersGenerate.PrefixoProjeto: String;
begin
  Result := ifThen(FParent.Params.Projeto.Trim.IsEmpty,
                   '',
                   FParent.Params.Projeto.Trim+'.');
end;

function TModelRoutersGenerate.Tabelas(aValue: TStrings): iModelRoutersGenerate;
begin
  Result := Self;
  FTabelas := aValue;
end;

end.
