CREATE OR REPLACE PROCEDURE prc_reajuste_preco_massa (
    p_categoria IN VARCHAR2,
    p_percentual IN NUMBER
) IS 
    
    TYPE t_id_produto IS TABLE OF ec_produtos.id_produto%TYPE;
    TYPE t_preco      IS TABLE OF ec_produtos.preco_atual%TYPE;
    
    v_ids   t_id_produto;
    v_precos_velhos     t_preco;
    v_precos_novos      t_preco;
    
BEGIN

    SELECT id_produto, preco_atual, (preco_atual * (1 + (p_percentual/100)))
    BULK COLLECT INTO v_ids, v_precos_velhos, v_precos_novos
    FROM ec_produtos
    WHERE categoria = p_categoria AND status = 'ATIVA';
    
    IF v_ids.COUNT = 0 THEN
        RETURN;
    END IF;
    
    FORALL i IN 1..v_ids.COUNT
        UPDATE ec_produtos
        SET preco_atual = v_precos_novos(i)
        WHERE id_produto = v_ids(i);
        
    FORALL i IN 1..v_ids.COUNT
        INSERT INTO ec_historico_precos (id_histórico, id_produto, preco_antigo, preco_novo)
        VALUES (SYS_GUID(), v_ids(i), v_precos_velhos(i), v_precos_novos(i));
        
        COMMIT;
        
    DBMS_OUTPUT.PUT_LINE('Sucesso! Total de produtos reajustados: ' || v_ids.COUNT);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, 'Falha no reajuste em massa: ' || SQLERRM);
END;
/