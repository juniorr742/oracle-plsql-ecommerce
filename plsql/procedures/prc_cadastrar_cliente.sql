set serveroutput on;
CREATE OR REPLACE PROCEDURE prc_cadastrar_cliente (
    p_nome IN VARCHAR2,
    p_email IN VARCHAR2,
    p_id OUT RAW
) IS
BEGIN

    IF p_nome IS NULL OR p_email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nome e E-mail são obrigatórios para o cadastro.');
    END IF;
    
    p_id := SYS_GUID();
    
    INSERT INTO ec_clientes (id_cliente, nome, email)
    VALUES (p_id, p_nome, p_email);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Sucesso! Cliente ' || p_nome || ' cadastrado com ID ' || p_id);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O e-mail ' || p_email || ' ja esta em uso.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro crítico inesperado: ' || SQLERRM);
END;
/

DECLARE
    v_id_gerado RAW(16);
BEGIN

    prc_cadastrar_cliente(
        p_nome => 'Lucas Almeida',
        p_email => 'lucas@email.com',
        p_id  => v_id_gerado
    );
    DBMS_OUTPUT.PUT_LINE('ID retornado para o bloco de teste: ' || v_id_gerado);
END;
/

select * 
from ec_clientes
where id_cliente = 'C3B3905E251E4DEDAA3D0641448674FB';
