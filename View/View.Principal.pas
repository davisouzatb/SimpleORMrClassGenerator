unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.CategoryButtons,
  System.Actions,
  Vcl.WinXCtrls,
  Vcl.ImgList,
  Vcl.CheckLst,
  Vcl.ComCtrls,
  System.ImageList,
  Model.DAO.Interfaces,
  Model.DAO.Connection.FireDac,
  Model.Generator;

type
  TFPrincipal = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image3: TImage;
    logo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LHora: TLabel;
    LData: TLabel;
    Menu: TSplitView;
    Image6: TImage;
    catPrincipal: TCategoryButtons;
    ImageList1: TImageList;
    catConfig: TCategoryButtons;
    pnEmbeded: TPanel;
    mListaFormAberta: TSplitView;
    ListForms: TListBox;
    Timer1: TTimer;
    tabGeral: TPageControl;
    pgConexao: TTabSheet;
    pgGerador: TTabSheet;
    Panel9: TPanel;
    Panel10: TPanel;
    edtCaminhoBanco: TEdit;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    btnConectar: TButton;
    edtServidor: TEdit;
    Panel4: TPanel;
    cbDriver: TComboBox;
    Panel2: TPanel;
    Panel11: TPanel;
    Panel3: TPanel;
    pnContent: TPanel;
    Panel6: TPanel;
    chkListaTabelas: TCheckListBox;
    Panel7: TPanel;
    btMarcar: TButton;
    btDesmarcar: TButton;
    edtPorta: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    edtCaminhoArquivos: TEdit;
    Panel5: TPanel;
    pgGeradorClasses: TPageControl;
    tbSimpleORM: TTabSheet;
    mResult: TMemo;
    Panel12: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    btGerarClass: TButton;
    edtPrefixoEntidades: TEdit;
    ckCapitalizar: TCheckBox;
    ckRemoverCaracter: TCheckBox;
    btGerarModel: TButton;
    edtPrefixoProjeto: TEdit;
    tbHorse: TTabSheet;
    btRoutersHorse: TButton;
    procedure logoClick(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure catPrincipalCategories0Items0Click(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure GetTableList;
    procedure btMarcarClick(Sender: TObject);
    procedure btDesmarcarClick(Sender: TObject);
    procedure btGerarClassClick(Sender: TObject);
    procedure cbDriverChange(Sender: TObject);
    procedure btGerarModelClick(Sender: TObject);
    procedure catPrincipalCategories0Items2Click(Sender: TObject);
  private
    FConnection : iModelDAOConnection;
    { Private declarations }
    procedure Notify(Value : String);
    procedure WorkArea;
    procedure HabilitaTimer;
    procedure HabilitaTabs( aTab : TTabSheet);
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

procedure TFPrincipal.Action7Execute(Sender: TObject);
begin
  Close;
end;

procedure TFPrincipal.btnConectarClick(Sender: TObject);
var
  Drive : String;
begin
  Drive := '';
  case cbDriver.ItemIndex of
    0 : Drive := 'FB';
    1 : Drive := 'MSSQL';
    2 : Drive := 'SQLite';
    3 : Drive := 'PG';
    4 : Drive := 'MySQL';
    5 : Drive := 'Ora';
  end;
  try
    FConnection.
      ParamClear.
      DriverName(Drive).
      Database(edtCaminhoBanco.Text).
      UserName(edtUsuario.Text).
      Password(edtSenha.Text).
      Server(edtServidor.Text).
      Port(edtPorta.Text).
      AutoReconnect(True).
    Connected(True);

    HabilitaTabs(pgGerador);

    GetTableList;
  except on E: Exception do
    raise Exception.Create('Error ao conectar:'+ e.Message);
  end;
end;

procedure TFPrincipal.btGerarModelClick(Sender: TObject);
var
  j : Integer;
  vTabelas : TStringList;
begin
  if not FConnection.Connection.Connected then
  begin
    ShowMessage('Base de dados não conectada');
    Abort;
  end;

  vTabelas := TStringList.Create;
  try
    for j := 0 to chkListaTabelas.Count -1 do
    begin
      Application.ProcessMessages;
      if chkListaTabelas.Checked[j] then
        vTabelas.Add(chkListaTabelas.Items[j].Trim);
    end;

    TModelGenerator.New
      .Params
        .Diretorio(edtCaminhoArquivos.Text)
        .Projeto(edtPrefixoProjeto.Text)
        .Prefixo(edtPrefixoEntidades.Text)
        .Captalizar(ckCapitalizar.Checked)
        .RemoverCaracter(ckRemoverCaracter.Checked)
        .Display(Notify)
      .&End
      .ModelGenerate
        .Tabelas(vTabelas)
        .Generate
      .&End;
  finally
    vTabelas.Free;
  end;
  ShowMessage('Concluído');
end;

procedure TFPrincipal.btMarcarClick(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := True;
  end;
end;

procedure TFPrincipal.btDesmarcarClick(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := False;
  end;
end;

procedure TFPrincipal.btGerarClassClick(Sender: TObject);
var
  j : Integer;
begin
  if not FConnection.Connection.Connected then
  begin
    ShowMessage('Base de dados não conectada');
    Abort;
  end;

  for j := 0 to chkListaTabelas.Count -1 do
  begin
    Application.ProcessMessages;
    if chkListaTabelas.Checked[j] then
      TModelGenerator.New
        .Params
          .Diretorio(edtCaminhoArquivos.Text)
          .Projeto(edtPrefixoProjeto.Text)
          .Prefixo(edtPrefixoEntidades.Text)
          .Captalizar(ckCapitalizar.Checked)
          .RemoverCaracter(ckRemoverCaracter.Checked)
          .Display(Notify)
        .&End
        .EntityGenerate
          .Connection(FConnection)
          .Tabela(chkListaTabelas.Items[j].Trim)
          .Generate
        .&End;
  end;
  ShowMessage('Concluído');
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  HabilitaTimer;
  FConnection := TModelDAOConnection.New;
  HabilitaTabs(pgConexao);
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFPrincipal.FormResize(Sender: TObject);
begin
  WorkArea;
end;

procedure TFPrincipal.GetTableList;
var
  i : integer;
  FQuery : iModelDAOConnectionQuery;
  function EliminaBrancos(sTexto: String): String;
  var
    nPos : Integer;
  begin
    while Pos(' ',sTexto) > 0 do
    begin
      nPos := Pos(' ',sTexto);
      Delete(sTexto,nPos,1);
    end;
    Result := sTexto;
  end;
begin
  FQuery := TModelDAOConnectionQuery.New(FConnection);
  FQuery.GetTableList;

  chkListaTabelas.Items.Clear();
  while not FQuery.DataSet.Eof do
  begin
    chkListaTabelas.Items.Add(EliminaBrancos(FQuery.DataSet.Fields[0].AsString));
    FQuery.DataSet.Next;
  end;

  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := True;
  end;
end;

procedure TFPrincipal.WorkArea;
begin
  if (Self.WindowState <> wsMaximized) then
    exit;
  Self.Left   := Screen.WorkAreaLeft - 3;
  Self.Top    := Screen.WorkAreaTop - 3;
  Self.Width  := Screen.WorkAreaWidth + 3;
  Self.Height := Screen.WorkAreaHeight + 3;
end;

procedure TFPrincipal.HabilitaTabs( aTab : TTabSheet);
begin
  pgGerador.TabVisible := False;
  pgConexao.TabVisible := False;

  aTab.TabVisible := True;
end;

procedure TFPrincipal.HabilitaTimer;
begin
  Timer1Timer(nil);
  Timer1.Enabled := True;
end;

procedure TFPrincipal.Notify(Value: String);
begin
  mResult.Lines.Add(Value);
end;

procedure TFPrincipal.Action2Execute(Sender: TObject);
begin
  HabilitaTabs(pgGerador);
  tbSimpleORM.TabVisible := True;
  tbHorse.TabVisible := False;
  OnResize(nil);
end;

procedure TFPrincipal.catPrincipalCategories0Items0Click(Sender: TObject);
begin
  HabilitaTabs(pgConexao);
  OnResize(nil);
end;

procedure TFPrincipal.catPrincipalCategories0Items2Click(Sender: TObject);
begin
  HabilitaTabs(pgGerador);
  tbSimpleORM.TabVisible := False;
  tbHorse.TabVisible := True;
  OnResize(nil);
end;

procedure TFPrincipal.cbDriverChange(Sender: TObject);
begin
  case cbDriver.ItemIndex of
    0 : edtPorta.Text := '3050';
    1 : edtPorta.Text := '1433';
    3 : edtPorta.Text := '5432'
    else
        edtPorta.Text := '';
  end;
end;

procedure TFPrincipal.logoClick(Sender: TObject);
begin
  if Menu.Opened then
    Menu.Close
  else
    Menu.Open;
  OnResize(nil);
end;

procedure TFPrincipal.Timer1Timer(Sender: TObject);
begin
  LHora.Caption := FormatDateTime('hh:mm',Now);
end;

end.
