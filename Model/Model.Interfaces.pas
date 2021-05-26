unit Model.Interfaces;

interface

uses
  System.SysUtils,
  Model.DAO.Interfaces;

type
   iModelEntityGenerate = interface;
   iModelGeneratorParams = interface;

  iModelGenerator = interface
    ['{D94A9F44-0E64-411A-940B-E1F2B29DEE08}']
    function Params : iModelGeneratorParams;
    function EntityGenerate: iModelEntityGenerate;
    function ModelGenerate: iModelGenerator;
  end;

  iModelGeneratorParams = interface
    ['{34161ED1-9926-4482-B296-5F3D7C9C7FB8}']
    function Captalizar( aValue: Boolean) : iModelGeneratorParams; overload;
    function Captalizar: Boolean; overload;
    function RemoverCaracter( aValue: Boolean) : iModelGeneratorParams; overload;
    function RemoverCaracter: Boolean; overload;
    function Display( aDisplay : TProc<string>) : iModelGeneratorParams; overload;
    procedure Display(aValue : String); overload;
    function Diretorio( aValue : String) : iModelGeneratorParams; overload;
    function Diretorio : String; overload;
    function Prefixo( aValue : String) : iModelGeneratorParams; overload;
    function Prefixo: String; overload;
    function &End :iModelGenerator;
  end;

  iModelEntityGenerate = interface
    ['{0416D202-BFCE-499D-9CFD-683FF7E23116}']
    function Connection( aConnection : iModelDAOConnection) : iModelEntityGenerate;
    function Tabela( aValue : String) : iModelEntityGenerate;
    function Generate : iModelEntityGenerate;
    function &End :iModelGenerator;
  end;

  iModelFileControl = interface
    ['{1100B127-0A84-438C-ADD4-98F3A7C74D1D}']
    function Add( aValue : String) : iModelFileControl;
    function Clear : iModelFileControl;
    function SaveToFile( aValue : String) : iModelFileControl;
    function Text : String;
  end;

implementation

end.
