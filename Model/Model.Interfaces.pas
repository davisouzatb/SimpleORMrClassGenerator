unit Model.Interfaces;

interface

uses
  System.SysUtils,
  Model.DAO.Interfaces;

type
  iModelEntityGenerate = interface
    ['{D94A9F44-0E64-411A-940B-E1F2B29DEE08}']
    function Connection( aConnection : iModelDAOConnection) : iModelEntityGenerate;
    function Dispay( aDisplay : TProc<string>) : iModelEntityGenerate;
    function Diretorio( aValue : String) : iModelEntityGenerate;
    function Prefixo( aValue : String) : iModelEntityGenerate;
    function Tabela( aValue : String) : iModelEntityGenerate;
    function Generate: iModelEntityGenerate;
  end;

implementation

end.
