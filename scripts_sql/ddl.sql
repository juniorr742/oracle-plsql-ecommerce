CREATE TABLE ec_produtos (
    id_produto RAW(16) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    categoria VARCHAR2(50),
    preco_atual NUMBER(10,2),
    status VARCHAR2(10)
);

CREATE TABLE ec_historico_precos (
    id_histórico RAW(16) PRIMARY KEY,
    id_produto RAW(16),
    preco_antigo NUMBER(10,2),
    preco_novo NUMBER(10,2),
    data_alteracao DATE DEFAULT SYSDATE,
    
    CONSTRAINT fk_hist_produtos FOREIGN KEY (id_produto) REFERENCES ec_produtos(id_produto)
);
    