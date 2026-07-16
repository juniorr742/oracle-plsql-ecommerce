CREATE TABLE ec_auditoria_estoque (
    id_auditoria  RAW(16) PRIMARY KEY,
    id_produto  RAW(16) NOT NULL,
    estoque_antigo NUMBER,
    estoque_novo NUMBER,
    usuario_db VARCHAR(50),
    data_acao DATE DEFAULT SYSDATE,
    
    CONSTRAINT fk_auditoria_produtos FOREIGN KEY (id_produto) REFERENCES ec_produtos(id_produto)
);

