CREATE OR REPLACE PROCEDURE prc_processar_compra (
    p_id_cliente  IN RAW,
    p_id_produto  IN RAW,
    p_quantidade  IN RAW
) IS
    v_estoque_atual NUMBER;
    v_preco_prod    NUMBER(10,2);
    v_status_prod   VARCHAR2(10);
    v_id_novo_ped   RAW;
BEGIN
    -- 1. BLOQUEIO E CAPTURA (Adicionamos a quantidade_estoque no SELECT)
    SELECT preco_atual, status, quantidade_estoque 
    INTO v_preco_prod, v_status_prod, v_estoque_atual
    FROM ec_produtos
    WHERE id_produto = p_id_produto
    FOR UPDATE; -- Trava a linha do produto no banco

    -- 2. VALIDAÇÃO: O produto está ativo?
    IF v_status_prod != 'ATIVO' THEN
        RAISE_APPLICATION_ERROR(-20020, 'Compra recusada: Produto inativo.');
    END IF;

    -- 3. NOVA VALIDAÇÃO: Tem estoque suficiente?
    IF v_estoque_atual < p_quantidade THEN
        RAISE_APPLICATION_ERROR(-20023, 'Compra recusada: Estoque insuficiente. Temos apenas ' || v_estoque_atual || ' unidades disponíveis.');
    END IF;

    -- 4. ATUALIZAÇÃO DO ESTOQUE
    UPDATE ec_produtos
    SET quantidade_estoque = quantidade_estoque - p_quantidade
    WHERE id_produto = p_id_produto;

    -- 5. CRIAÇÃO DO PEDIDO (Gera cabeçalho e item)
    v_id_novo_ped := seq_ec_pedidos.NEXTVAL;

    INSERT INTO ec_pedidos (id_pedido, id_cliente, valor_total, status)
    VALUES (v_id_novo_ped, p_id_cliente, (v_preco_prod * p_quantidade), 'PAGO');

    INSERT INTO ec_itens_pedido (id_item, id_pedido, id_produto, quantidade, preco_unit)
    VALUES (seq_ec_itens.NEXTVAL, v_id_novo_ped, p_id_produto, p_quantidade, v_preco_prod);

    -- 6. CONFIRMAÇÃO TOTAL
    COMMIT; -- Salva as inserções, o update do estoque e libera o cadeado do FOR UPDATE
    DBMS_OUTPUT.PUT_LINE('Sucesso! Pedido #' || v_id_novo_ped || ' processado. Estoque atualizado.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Erro: Produto com ID ' || p_id_produto || ' não existe.');
        
    WHEN OTHERS THEN
        ROLLBACK; -- Segurança máxima: desfaz tudo se explodir qualquer erro
        RAISE_APPLICATION_ERROR(-20022, 'Falha crítica no motor de vendas: ' || SQLERRM);
END;
/