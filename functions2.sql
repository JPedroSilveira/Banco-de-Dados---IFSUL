/*Retorne o número mais o nome do mês em português (1 - Janeiro) de acordo com o parâmetro
informado que deve ser uma data. Para testar, crie uma consulta que retorne o cliente e mês de
venda (número e nome do mês).*/
USE compubras;

SET lc_time_names = 'pt_BR';

DELIMITER //
CREATE FUNCTION aloha(nome VARCHAR(50), data_mes DATE)
RETURNS VARCHAR(50)
BEGIN
DECLARE mes TINYINT;
DECLARE mes_nome VARCHAR(10);
SET mes_nome = MONTHNAME(data_mes);
SET mes = MONTH(data_mes);
RETURN CONCAT('Nome: ',nome,' Mês: ',mes,' | ',mes_nome);
END
//
DELIMITER ;

SET lc_time_names = 'en_US';
SELECT aloha('joao',NOW());