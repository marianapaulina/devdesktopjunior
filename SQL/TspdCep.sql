CREATE TABLE "TspdCep" (
    cep VARCHAR(10) NOT NULL PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    complemento VARCHAR(255),
    bairro VARCHAR(255) NOT NULL,
    localidade VARCHAR(255) NOT NULL,
    uf BPCHAR(2) NOT NULL,
    ibge VARCHAR(7),
    ddd VARCHAR(2)
);