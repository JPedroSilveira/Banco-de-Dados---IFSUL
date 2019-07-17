USE compubras;
SELECT IF((SELECT produto.ValorUnitario from produto WHERE produto.CodProduto = 1)>(SELECT produto.ValorUnitario from produto WHERE produto.CodProduto = 2),(SELECT produto.Descricao from produto WHERE produto.CodProduto = 1), (SELECT produto.Descricao from produto WHERE produto.CodProduto = 2)) as 'oi';

SELECT CASE 1 WHEN 0 THEN 'zero' WHEN 1 THEN 'um' END;

SELECT @@version;

SELECT @@lc_time_names;

SET lc_time_names = 'pt_BR'; /*Modifica a lingua do mysql (prints e entrada de formato de números)*/

SET lc_time_names = 'en_US';

SET lc_time_names = 'de_DE';

SELECT MONTHNAME(NOW());

DELIMITER //
CREATE FUNCTION digitei(texto VARCHAR(20))
RETURNS VARCHAR(50) CHARSET utf8
RETURN CONCAT('Você digitou: ',texto,' !!!');
//

DELIMITER ;

SELECT digitei('oi');

DELIMITER //
CREATE FUNCTION ola(nome VARCHAR(50)) 
RETURNS VARCHAR (70) CHARSET utf8 
BEGIN
RETURN CONCAT("Olá ", nome, "!");
END
//

DELIMITER ;

SELECT ola('pedro') as 'Mensagem';

DELIMITER //

CREATE FUNCTION comissao (nome CHAR(1), venda DECIMAL(15,2))
RETURNS DECIMAL(15,2)
BEGIN
	DECLARE comissao DECIMAL(15,2);
CASE nome
	WHEN 'A' THEN SET comissao = venda * 0.20;
	WHEN 'B' THEN SET comissao = venda * 0.15;
	WHEN 'C' THEN SET comissao = venda * 0.10;
	WHEN 'D' THEN SET comissao = venda * 0.05;
    ELSE SET comissao = 1;
END CASE;

RETURN comissao;

END
//




DELIMITER ;

SELECT comissao((SELECT vendedor.FaixaComissao FROM vendedor WHERE vendedor.CodVendedor = 1),(SELECT produto.ValorUnitario FROM produto JOIN itempedido ON produto.CodProduto = itempedido.CodProduto JOIN pedido ON itempedido.CodPedido = pedido.CodPedido JOIN vendedor ON pedido.CodVendedor = vendedor.CodVendedor WHERE vendedor.CodVendedor = 1 LIMIT 1)) as 'oi';

/*DESAFIO 1: Crie uma função que receba um número IPv4 (Internet Protocol version 4) no formato
xxx.xxx.xxx.xxx e retorne a classe do mesmo e se é um IP válido ou inválido. */
DELIMITER //
CREATE FUNCTION IPV4(ip VARCHAR(15))
RETURNS CHAR(1)
BEGIN
    DECLARE ip_d VARCHAR(4);
	DECLARE class CHAR(1);
    SET ip_d = SUBSTRING_INDEX(ip,'.',1);
    IF(ip_d = 0) THEN SET class = 'Z';
    ELSEIF(ip_d < 128) THEN SET class = 'A';
    ELSEIF(ip_d < 192) THEN SET class = 'B';
    ELSEIF(ip_d < 224) THEN SET class = 'C';
    ELSEIF(ip_d < 256) THEN SET class = 'D';
    ELSE SET class = 'Z';
    END IF;
RETURN class;
END
//
DELIMITER ;

SELECT IPV4('223.255.255.0');

/**/