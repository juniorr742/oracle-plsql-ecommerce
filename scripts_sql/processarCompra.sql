ALTER TABLE ec_produtos ADD quantidade_estoque NUMBER DEFAULT 0;

select *
from ec_produtos;

update ec_produtos set quantidade_estoque = 50;

SET SERVEROUTPUT ON;
BEGIN
    prc_processar_compra(p_id_cliente => 'C3B3905E251E4DEDAA3D0641448674FB', p_id_produto => 'EA8EA7E571F047689D205BABD9F57BCD', p_quantidade => 100);
END;
/