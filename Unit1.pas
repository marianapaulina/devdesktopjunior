unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.JSON, UCep, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    ButtonConsultar: TButton;
    EditCep: TEdit;
    MemoResultado: TMemo;
    IdHTTP1: TIdHTTP;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDQuerySalvar: TFDQuery;
    FDQueryVerificaCep: TFDQuery;
    procedure ButtonConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SalvarCepNoBanco(const ACep: TCep);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Cor de fundo do formulário e texto
  Color := clBlack;
  Font.Color := clWhite;

  // Estilizando o botão
  ButtonConsultar.Font.Color := clWhite;

  // Estilizando o campo de edição
  EditCep.Color := clDkGray;
  EditCep.Font.Color := clWhite;

  // Estilizando o memo
  MemoResultado.Color := clDkGray;
  MemoResultado.Font.Color := clWhite;
end;

procedure TForm1.SalvarCepNoBanco(const ACep: TCep);
begin
  FDQuerySalvar.SQL.Clear;
  FDQuerySalvar.SQL.Add(
    'INSERT INTO "TspdCep" (cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd) ' +
    'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :ibge, :ddd) ' +
    'ON CONFLICT (cep) DO UPDATE SET ' +
    'logradouro = EXCLUDED.logradouro, ' +
    'complemento = EXCLUDED.complemento, ' +
    'bairro = EXCLUDED.bairro, ' +
    'localidade = EXCLUDED.localidade, ' +
    'uf = EXCLUDED.uf, ' +
    'ibge = EXCLUDED.ibge, ' +
    'ddd = EXCLUDED.ddd'
  );

  FDQuerySalvar.ParamByName('cep').AsString := ACep.cep;
  FDQuerySalvar.ParamByName('logradouro').AsString := ACep.logradouro;
  FDQuerySalvar.ParamByName('complemento').AsString := ACep.complemento;
  FDQuerySalvar.ParamByName('bairro').AsString := ACep.bairro;
  FDQuerySalvar.ParamByName('localidade').AsString := ACep.localidade;
  FDQuerySalvar.ParamByName('uf').AsString := ACep.uf;
  FDQuerySalvar.ParamByName('ibge').AsString := ACep.ibge;
  FDQuerySalvar.ParamByName('ddd').AsString := ACep.ddd;

  try
    FDQuerySalvar.ExecSQL;
    MemoResultado.Lines.Add('CEP inserido/atualizado com sucesso!');
  except
    on E: Exception do
      MemoResultado.Lines.Add('Erro ao salvar no banco: ' + E.Message);
  end;
end;

procedure TForm1.ButtonConsultarClick(Sender: TObject);
var
  HTTP: TIdHTTP;
  JSON: TJSONObject;
  Resposta: string;
  Cep: TCep;
begin
  HTTP := TIdHTTP.Create(nil);
  Cep := TCep.Create;
  try
    try
      Resposta := HTTP.Get('http://viacep.com.br/ws/' + EditCep.Text + '/json/');
      JSON := TJSONObject.ParseJSONValue(Resposta) as TJSONObject;

      // Preenche a classe Cep com os dados retornados
      Cep.cep := JSON.GetValue<string>('cep');
      Cep.logradouro := JSON.GetValue<string>('logradouro');
      Cep.complemento := JSON.GetValue<string>('complemento');
      Cep.bairro := JSON.GetValue<string>('bairro');
      Cep.localidade := JSON.GetValue<string>('localidade');
      Cep.uf := JSON.GetValue<string>('uf');
      Cep.ibge := JSON.GetValue<string>('ibge');
      Cep.gia := JSON.GetValue<string>('gia');
      Cep.ddd := JSON.GetValue<string>('ddd');
      Cep.siafi := JSON.GetValue<string>('siafi');

      // Exibe as informações no MemoResultado
      MemoResultado.Lines.Text :=
        'Logradouro: ' + Cep.logradouro + sLineBreak +
        'Complemento: ' + Cep.complemento + sLineBreak +
        'Bairro: ' + Cep.bairro + sLineBreak +
        'Localidade: ' + Cep.localidade + sLineBreak +
        'UF: ' + Cep.uf + sLineBreak +
        'IBGE: ' + Cep.ibge + sLineBreak +
        'DDD: ' + Cep.ddd + sLineBreak +
        'GIA: ' + Cep.gia + sLineBreak +
        'SIAFI: ' + Cep.siafi;

      // Salva no banco de dados
      SalvarCepNoBanco(Cep);

    except
      on E: Exception do
        MemoResultado.Lines.Text := 'Erro na requisição: ' + E.Message;
    end;
  finally
    Cep.Free;
    HTTP.Free;
  end;
end;

end.

