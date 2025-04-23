unit UCep;

interface

// Definindo uma classe chamada TCep para representar os dados de um CEP.
type
  TCep = class
  public
    cep: string;
    logradouro: string;
    complemento: string;
    bairro: string;
    localidade: string;
    uf: string;
    ibge: string;
    gia: string;
    ddd: string;
    siafi: string;
  end;

implementation

end.

