unit Model.DAO.Interfaces;

interface

uses
  Data.DB;

type
  iModelDAOConnection = interface
    ['{2028B2C4-650F-40C0-B901-F4010DA2A7EC}']
    function ParamClear : iModelDAOConnection;
    function AddParam( aValue : String) : iModelDAOConnection;
    function DriverName( aValue : String) : iModelDAOConnection;
    function Database( aValue : String) : iModelDAOConnection;
    function Password( aValue : String) : iModelDAOConnection;
    function UserName( aValue : String) : iModelDAOConnection;
    function Connected( aValue : Boolean) : iModelDAOConnection;
    function AutoReconnect( aValue : Boolean) : iModelDAOConnection;
    function Connection : TCustomConnection;
  end;

  iModelDAOConnectionQuery = interface
    ['{4BF86541-6F52-4BBA-9EF2-38B574134410}']
    function Active( aValue : Boolean) : iModelDAOConnectionQuery;
    function DataSet : TDataSet;
    function SQLClear : iModelDAOConnectionQuery;
    function SQL( aValue : String) : iModelDAOConnectionQuery;
    function AddParam( aParam: String; aValue : Variant): iModelDAOConnectionQuery;
    function GetTableList : TDataSet;
    function Open : iModelDAOConnectionQuery;
    function Close : iModelDAOConnectionQuery;
  end;

implementation

end.
