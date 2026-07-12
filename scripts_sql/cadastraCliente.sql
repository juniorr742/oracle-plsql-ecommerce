SET SERVEROUTPUT ON;

DECLARE 
    v_id_gerado RAW(16);
BEGIN
    
    prc_cadastrar_cliente(
        p_nome => 'Lucas Almeida',
        p_email => 'lucas@email.com',
        p_id => v_id_gerado
    );
    
    DBMS_OUTPUT.PUT_LINE('ID retornado para o bloco de teste: ' || v_id_gerado);
END;
/