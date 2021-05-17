unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.CategoryButtons,
  Vcl.WinXCtrls,
  System.Actions,
  System.Threading,
  Vcl.ActnList,
  System.ImageList,
  Vcl.ImgList,
  Vcl.WinXPanels,
  Vcl.CheckLst,
  Model.DAO.Interfaces,
  Model.DAO.Connection.FireDac,
  Model.EntityGenerate;

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
    SubDfe: TSplitView;
    CatDFe: TCategoryButtons;
    pnEmbeded: TPanel;
    mListaFormAberta: TSplitView;
    ListForms: TListBox;
    Timer1: TTimer;
    SubTributacao: TSplitView;
    CatTributacao: TCategoryButtons;
    CardPanel1: TCardPanel;
    CardConexao: TCard;
    CardGerador: TCard;
    Panel2: TPanel;
    Panel3: TPanel;
    cpDrive: TCardPanel;
    Panel4: TPanel;
    cpFirebird: TCard;
    edtCaminhoBanco: TLabeledEdit;
    edtUsuario: TLabeledEdit;
    edtSenha: TLabeledEdit;
    btnConectar: TButton;
    edtServidor: TLabeledEdit;
    Panel6: TPanel;
    chkListaTabelas: TCheckListBox;
    Panel7: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel5: TPanel;
    Panel8: TPanel;
    Button3: TButton;
    mResult: TMemo;
    edtPrefixoEntidades: TLabeledEdit;
    edtCaminhoArquivos: TLabeledEdit;
    cbDriver: TComboBox;
    ckCapitalizar: TCheckBox;
    ckRemoverCaracter: TCheckBox;
    procedure logoClick(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure catPrincipalCategories0Items0Click(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure GetTableList;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FConnection : iModelDAOConnection;
    { Private declarations }
    procedure Notify(Value : String);
    procedure WorkArea;
    procedure HabilitaTimer;
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
  end;
  try
    FConnection.
      ParamClear.
      DriverName(Drive).
      Database(edtCaminhoBanco.Text).
      UserName(edtUsuario.Text).
      Password(edtSenha.Text).
      AddParam('Server='+ edtServidor.Text).
      AutoReconnect(True).
    Connected(True);

    CardPanel1.ActiveCard := CardGerador;

    GetTableList;
  except on E: Exception do
    raise Exception.Create('Error ao conectar:'+ e.Message);
  end;
end;

procedure TFPrincipal.Button1Click(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := True;
  end;
end;

procedure TFPrincipal.Button2Click(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to chkListaTabelas.Count -1 do
  begin
    chkListaTabelas.Checked[i] := False;
  end;
end;

procedure TFPrincipal.Button3Click(Sender: TObject);
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
      TModelEntityGenerate.New
        .Captalizar(ckCapitalizar.Checked)
        .RemoverCaracter(ckRemoverCaracter.Checked)
        .Connection(FConnection)
        .Diretorio(edtCaminhoArquivos.Text)
        .Prefixo(edtPrefixoEntidades.Text)
        .Tabela(chkListaTabelas.Items[j].Trim)
        .Dispay(Notify)
      .Generate;
  end;
  ShowMessage('Concluído');
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  HabilitaTimer;
  FConnection := TModelDAOConnection.New;
  CardPanel1.ActiveCard := CardConexao;
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
  CardPanel1.ActiveCard := CardGerador;
  OnResize(nil);
end;

procedure TFPrincipal.catPrincipalCategories0Items0Click(Sender: TObject);
begin
  CardPanel1.ActiveCard := CardConexao;
  OnResize(nil);
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
