
CREATE TABLE ec_pedidos (
    id_pedido  RAW(16) PRIMARY KEY,
    id_cliente RAW(16) NOT NULL,
    data_pedido DATE DEFAULT SYSDATE,
    valor_total NUMBER(10,2) DEFAULT 0,
    status      VARCHAR2(20) DEFAULT 'PENDENTE'
                CHECK (status IN ('PENDENTE', 'PAGO', 'CANCELADO')),
    
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES ec_clientes(id_cliente)
);

CREATE TABLE ec_itens_pedido (
    id_item RAW(16) PRIMARY KEY,
    id_pedido RAW(16) NOT NULL,
    id_produto RAW(16) NOT NULL,
    quantidade NUMBER NOT NULL,
    preco_unit NUMBER(10,2) NOT NULL,
    
    CONSTRAINT fk_itens_pedido FOREIGN KEY (id_pedido) REFERENCES ec_pedidos(id_pedido),
    CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto) REFERENCES ec_produtos(id_produto)
);
