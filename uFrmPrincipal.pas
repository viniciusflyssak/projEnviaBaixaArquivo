unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDM, FileCtrl;

type
  TfrmPrincipal = class(TForm)
    pnlFundo: TPanel;
    pnlBotoes: TPanel;
    btnEnviarArquivo: TSpeedButton;
    edtTitulo: TEdit;
    lblNomeArquivo: TLabel;
    btnBaixarArquivo: TSpeedButton;
    procedure edtTituloKeyPress(Sender: TObject; var Key: Char);
    procedure btnEnviarArquivoClick(Sender: TObject);
    function geraHexArquivo: String;
    function selecionaArquivo: String;
    procedure btnBaixarArquivoClick(Sender: TObject);
    procedure lblNomeArquivoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function HexStringToBin(HexStr: AnsiString): TMemoryStream;
    function BuscaArquivo: AnsiString;
  private
    FArquivoSelecionado: String;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnEnviarArquivoClick(Sender: TObject);
var
  qryInserir: TFDQuery;
begin
  if trim(edtTitulo.Text) = '' then
    raise Exception.Create('Adicione um t�tulo!');
  if FArquivoSelecionado = '' then
    raise Exception.Create('Selecione ao menos um  arquivo!');
  qryInserir := TFDQuery.Create(nil);
  try
    qryInserir.Connection := DM.Connection;
    qryInserir.SQL.Add(' insert into arquivos values (default, :pTitulo, :pExtensao, :pArquivo) ');
    qryInserir.ParamByName('pTitulo').Value := edtTitulo.Text;
    qryInserir.ParamByName('pExtensao').Value := ExtractFileExt(FArquivoSelecionado);
    qryInserir.ParamByName('pArquivo').AsBlob := geraHexArquivo;
    qryInserir.ExecSQL;
  finally
    FreeAndNil(qryInserir);
  end;
  ShowMessage('Arquivo inserido com sucesso!');
end;

procedure TfrmPrincipal.edtTituloKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #$D then
    btnEnviarArquivoClick(Sender);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FArquivoSelecionado := '';
end;

function TfrmPrincipal.geraHexArquivo: String;
  function StreamToHexStr(AStream: TStream): String;
  const
   HexArr: array[0..15] of char =
   ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
  var
   AByte: Byte;
   i: Integer;
  begin
   SetLength(Result, AStream.Size * 2);
   AStream.Position := 0;
   for i := 0 to AStream.Size - 1 do
   begin
     AStream.ReadBuffer(AByte, SizeOf(AByte));
     Result[i * 2 + 1] := HexArr[AByte shr 4];
     Result[i * 2 + 2] := HexArr[AByte and $0F];
   end;
  end;
var
   Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FArquivoSelecionado);
    Result := StreamToHexStr(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrmPrincipal.lblNomeArquivoClick(Sender: TObject);
begin
  FArquivoSelecionado := selecionaArquivo;
  lblNomeArquivo.Caption := FArquivoSelecionado;
end;

function TfrmPrincipal.selecionaArquivo: String;
var
  selectedFile: string;
  dlg: TOpenDialog;
begin
  selectedFile := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.InitialDir := 'C:\';
    dlg.Filter := 'All files (*.*)|*.*';
    if dlg.Execute(Handle) then
      selectedFile := dlg.FileName;
  finally
    dlg.Free;
  end;

  if selectedFile <> '' then
    Result := selectedFile;
end;

function TfrmPrincipal.HexStringToBin(HexStr: AnsiString): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.Size := Length(HexStr) div 2;
  if Result.Size > 0 then
    HexToBin(PAnsiChar(HexStr), Result.Memory, Result.Size);
end;

function TfrmPrincipal.BuscaArquivo: AnsiString;
var
  qryImagem: TFDQuery;
begin
  Result := '';
  qryImagem := TFDQuery.Create(nil);
  try
    qryImagem.Connection := DM.Connection;
    qryImagem.Sql.Add(' SELECT TITULO, ARQUIVO, EXTENSAO FROM ARQUIVOS ');
    qryImagem.Sql.Add(' WHERE TITULO ILIKE :pTitulo ');
    qryImagem.ParamByName('pTitulo').Value := '%' + edtTitulo.Text + '%';
    qryImagem.Open;
    qryImagem.First;
    if not(qryImagem.RecordCount > 0) then
      raise Exception.Create('Arquivo n�o encontrado!');
    Result :=  qryImagem.FieldByName('ARQUIVO').AsAnsiString;
    FArquivoSelecionado :=  qryImagem.FieldByName('TITULO').AsString + qryImagem.FieldByName('EXTENSAO').AsString;
  finally
    FreeAndNil(qryImagem);
  end;
end;

procedure TfrmPrincipal.btnBaixarArquivoClick(Sender: TObject);
var
  Stream: TMemoryStream;
  function selecionaDir: String;
  var
    Dir: string;
  const
    SELDIRHELP = 1000;
  begin
    Dir := 'C:\';
    if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
      Result := Dir
    else
      raise Exception.Create('Selecione ao menos um diret�rio!');
  end;
begin
  if Trim(edtTitulo.Text) = '' then
    raise Exception.Create('Preencha o campo de busca!');
  Stream := HexStringToBin(BuscaArquivo);
  try
    Stream.position := 0;
    Stream.SaveToFile(selecionaDir + '\' + FArquivoSelecionado);
  finally
    Stream.free;
  end;
  showmessage('Arquivo gravado com sucesso!');
end;

end.
