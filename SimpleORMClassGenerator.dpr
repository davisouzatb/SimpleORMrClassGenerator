program SimpleORMClassGenerator;

uses
  Vcl.Forms,
  Model.DAO.Interfaces in 'Model\DAO\Model.DAO.Interfaces.pas',
  Model.DAO.Connection.FireDac in 'Model\DAO\Connection\Model.DAO.Connection.FireDac.pas',
  View.Principal in 'View\View.Principal.pas' {FPrincipal},
  Model.Interfaces in 'Model\Model.Interfaces.pas',
  Model.Generator in 'Model\Model.Generator.pas',
  Model.Util in 'Model\Model.Util.pas',
  Model.FileControl in 'Model\Model.FileControl.pas',
  Model.EntityGenerate in 'Model\Model.EntityGenerate.pas',
  Model.Generator.Params in 'Model\Model.Generator.Params.pas',
  Model.ModelGenerate in 'Model\Model.ModelGenerate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
