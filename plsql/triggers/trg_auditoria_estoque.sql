CREATE OR REPLACE TRIGGER trg_auditoria_estoque
AFTER UPDATE OF quantidade_estoque ON ec_produtos
FOR EACH ROW 
BEGIN 
    
    IF :OLD.quantidade_estoque <> :NEW.quantidade_estoque THEN 
    
    INSERT INTO ec_auditoria_estoque (
        id_auditoria,
        id_produto,
        estoque_antigo,
        estoque_novo,
        usuario_db
    ) VALUES (
        SYS_GUID(),
        :NEW.id_produto,
        :OLD.quantidade_estoque,
        :NEW.quantidade_estoque,
        USER
    );
    END IF;
END;
/