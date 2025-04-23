object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = ButtonConsultar
  Caption = 'Form1'
  ClientHeight = 554
  ClientWidth = 740
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object ButtonConsultar: TButton
    Left = 146
    Top = 200
    Width = 129
    Height = 49
    Caption = 'Consultar CEP'
    TabOrder = 0
    OnClick = ButtonConsultarClick
  end
  object EditCep: TEdit
    Left = 48
    Top = 120
    Width = 321
    Height = 49
    TabOrder = 1
  end
  object MemoResultado: TMemo
    Left = 408
    Top = 64
    Width = 313
    Height = 393
    Lines.Strings = (
      'MemoResultado')
    TabOrder = 2
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 352
    Top = 496
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=postgres'
      'Password=mari'
      'Server=localhost'
      'DriverID=PG')
    Connected = True
    Left = 112
    Top = 496
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 56
    Top = 504
  end
  object FDQuerySalvar: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'FDQuerySalvar.SQL.Clear;'
      
        'FDQuerySalvar.SQL.Add('#39'INSERT INTO "TspdCep" (cep, logradouro, c' +
        'omplemento, bairro, localidade, uf, ibge, ddd)'#39');'
      
        'FDQuerySalvar.SQL.Add('#39'VALUES (:cep, :logradouro, :complemento, ' +
        ':bairro, :localidade, :uf, :ibge, :ddd)'#39');')
    Left = 176
    Top = 504
  end
  object FDQueryVerificaCep: TFDQuery
    Connection = FDConnection1
    Left = 248
    Top = 496
  end
end
