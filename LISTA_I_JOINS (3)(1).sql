/*LISTA 1 JOINS*/
Use compubras;
/*1 Não pensei onde botar um JOIN*/ 
SELECT vendedor.Nome, vendedor.SalarioFixo*1.75+120 FROM vendedor WHERE vendedor.FaixaComissao = 'C';
/*2*/
SELECT produto.Descricao,produto.CodProduto, SUM(itempedido.quantidade) as quantidade_vendida FROM itempedido RIGHT JOIN produto ON produto.CodProduto = itempedido.CodProduto GROUP BY itempedido.CodProduto;
/*3*/
SELECT pedido.*, COUNT(itempedido.quantidade) as quantidade_produtos FROM itempedido RIGHT JOIN pedido ON itempedido.CodPedido = pedido.CodPedido GROUP BY itempedido.CodPedido;
/*4*/
SELECT pedido.*, COUNT(itempedido.quantidade) as quantidade_produtos FROM itempedido RIGHT JOIN pedido ON itempedido.CodPedido = pedido.CodPedido GROUP BY itempedido.CodPedido HAVING COUNT(itempedido.quantidade)>3;
/*5*/
SELECT cliente.*, pedido.CodPedido FROM cliente LEFT JOIN pedido ON cliente.CodCliente=pedido.CodCliente;
/*6*/
SELECT cliente.*, pedido.* FROM cliente JOIN pedido ON pedido.CodCliente = cliente.CodCliente;
/*7*/
SELECT cliente.*, pedido.* FROM cliente LEFT JOIN pedido ON pedido.CodCliente = cliente.CodCliente;
/*8*/
SELECT cliente.*,pedido.* FROM cliente JOIN pedido ON pedido.CodCliente = cliente.CodCliente WHERE DATEDIFF(pedido.PrazoEntrega,pedido.DataPedido) > 10 AND cliente.Uf='RS' OR cliente.Uf='SC';
SELECT cliente.*,pedido.* FROM cliente JOIN pedido ON pedido.CodCliente = cliente.CodCliente WHERE DATEDIFF(pedido.PrazoEntrega,pedido.DataPedido) > 10 AND cliente.Uf IN ('RS','SC');
/*9*/
SELECT cliente.*,pedido.PrazoEntrega FROM cliente JOIN pedido ON pedido.CodCliente = cliente.CodCliente ORDER BY pedido.PrazoEntrega DESC;
/*10 OK Linhas=6339*/
SELECT vendedor.* FROM vendedor JOIN pedido ON pedido.CodVendedor = vendedor.CodVendedor WHERE DATEDIFF(pedido.PrazoEntrega,pedido.DataPedido) > 15 AND vendedor.SalarioFixo>='1000' ORDER BY vendedor.Nome ASC;
/*11 OK*/
/* A minha é mais lenta :( */
SELECT vendedor.CodVendedor, vendedor.Nome,
(SELECT SUM(produto.ValorUnitario*0.2*itempedido.Quantidade) FROM pedido LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
LEFT JOIN produto ON itempedido.CodProduto = produto.CodProduto WHERE vendedor.CodVendedor = pedido.CodVendedor GROUP BY vendedor.CodVendedor) 
as comissao FROM vendedor;

/*DO professor*/
SELECT vendedor.Nome, SUM(produto.ValorUnitario*0.2*itempedido.Quantidade) FROM vendedor 
LEFT JOIN pedido ON pedido.codvendedor = vendedor.codvendedor 
LEFT JOIN itempedido ON pedido.codpedido=itempedido.codpedido
LEFT JOIN produto ON itempedido.Codproduto = produto.CodProduto 
GROUP BY vendedor.CodVendedor;

/*12*/
CREATE VIEW total AS (
SELECT vendedor.CodVendedor, vendedor.Nome, vendedor.FaixaComissao,vendedor.SalarioFixo,MONTH(pedido.DataPedido) as 'mes',
SUM(produto.ValorUnitario*itempedido.Quantidade) as comissao,  
COUNT(itempedido.Quantidade) as Total_Vendido
FROM vendedor
LEFT JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor 
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
LEFT JOIN produto ON itempedido.CodProduto = produto.CodProduto 
GROUP BY vendedor.CodVendedor, MONTH(pedido.DataPedido)
);

CREATE VIEW classe_A AS (SELECT total.CodVendedor,total.Nome,total.FaixaComissao,total.mes,SalarioFixo,total.comissao*0.2 as comissao,(total.comissao*0.2)+total.SalarioFixo as 'Salario_Total',total.Total_Vendido FROM total WHERE total.FaixaComissao ='A');
CREATE VIEW classe_B AS (SELECT total.CodVendedor,total.Nome,total.FaixaComissao,total.mes,total.SalarioFixo,total.comissao*0.15,(total.comissao*0.15)+total.SalarioFixo as 'Salario_Total',total.Total_Vendido FROM total WHERE total.FaixaComissao ='B');
CREATE VIEW classe_C AS (SELECT total.CodVendedor,total.Nome,total.FaixaComissao,total.mes,total.SalarioFixo,total.comissao*0.1,(total.comissao*0.1)+total.SalarioFixo as 'Salario_Total',total.Total_Vendido FROM total WHERE total.FaixaComissao ='C');
CREATE VIEW classe_D AS (SELECT total.CodVendedor,total.Nome,total.FaixaComissao,total.mes,total.SalarioFixo,total.comissao*0.05,(total.comissao*0.05)+total.SalarioFixo as 'Salario_Total',total.Total_Vendido FROM total WHERE total.FaixaComissao ='D');

SELECT * from total; 
DROP VIEW total;

SELECT SUM(classe_A.comissao) from classe_A GROUP BY classe_A.nome; /*Caso queira unir totas as comissões do ano*/

SELECT * FROM classe_A;
DROP VIEW classe_A;

SELECT * FROM classe_B; 
DROP VIEW classe_B;

SELECT * FROM classe_C; 
DROP VIEW classe_C;

SELECT * FROM classe_D; 
DROP VIEW classe_D;

/*13 OK*/
SELECT cliente.*,(SELECT vendedor.Nome FROM vendedor LEFT JOIN pedido ON pedido.CodVendedor = vendedor.CodVendedor WHERE cliente.CodCliente = pedido.CodCliente ORDER BY pedido.DataPedido LIMIT 1) as 'primeiro_vendedor' FROM cliente;

/*17 OK*/
SELECT cliente.Nome, COUNT(pedido.CodPedido) as quant_pedidos FROM cliente INNER JOIN pedido ON cliente.CodCliente = pedido.CodCliente GROUP BY cliente.CodCliente ORDER BY quant_pedidos;
/*18 OK*/
SELECT cliente.Nome, pedido.CodPedido, SUM(itempedido.quantidade) quantidade_total_produtos_pedido FROM cliente RIGHT JOIN pedido ON cliente.CodCliente = pedido.CodPedido RIGHT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido GROUP BY pedido.CodPedido;
/*19 OK*/
SELECT cliente.Nome, pedido.CodPedido, SUM(itempedido.quantidade*produto.ValorUnitario) as Valor_total_pedido FROM cliente 
JOIN pedido ON cliente.CodCliente = pedido.CodCliente
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
JOIN produto ON itempedido.CodProduto = produto.CodProduto GROUP BY pedido.CodPedido;
/*20*/
SELECT cliente.Nome, SUM(itempedido.quantidade*produto.ValorUnitario) as Valor_gasto FROM cliente 
JOIN pedido ON cliente.CodCliente = pedido.CodCliente 
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
JOIN produto ON itempedido.CodProduto = produto.CodProduto 
GROUP BY cliente.CodCliente;
/*21*/
SELECT vendedor.Nome,COUNT(pedido.CodPedido) as 'quantidade vendida' FROM vendedor JOIN pedido ON vendedor.CodVendedor=pedido.CodVendedor GROUP BY pedido.CodVendedor; /*SUM(para o total de produtos vendidos) ou COUNT (para o total de pedidos realizados)
/*3 piores*/
SELECT vendedor.Nome,COUNT(pedido.CodPedido) as 'quantidade vendida' FROM vendedor JOIN pedido ON vendedor.CodVendedor=pedido.CodVendedor GROUP BY pedido.CodVendedor ORDER BY COUNT(pedido.CodPedido) asc limit 3; 
/*3 melhores*/
SELECT vendedor.Nome,COUNT(pedido.CodPedido) as 'quantidade vendida' FROM vendedor JOIN pedido ON vendedor.CodVendedor=pedido.CodVendedor GROUP BY pedido.CodVendedor ORDER BY COUNT(pedido.CodPedido) desc limit 3; 

/*22*/
/*Pablão*/
/*Por quantidade de pedido*/
SELECT vendedor.Nome,COUNT(pedido.CodPedido) as 'quantidade vendida' FROM vendedor JOIN pedido ON vendedor.CodVendedor=pedido.CodVendedor WHERE YEAR(pedido.DataPedido)='2014' GROUP BY pedido.CodVendedor ORDER BY COUNT(pedido.CodPedido) desc limit 1; 
/*Por preço*/
SELECT vendedor.Nome, SUM(itempedido.quantidade*produto.ValorUnitario) as Valor_vendido FROM vendedor 
JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor 
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
JOIN produto ON itempedido.CodProduto = produto.CodProduto 
GROUP BY vendedor.Nome
ORDER BY Valor_vendido desc limit 1;
/*23*/
SELECT produto.Descricao, SUM(itempedido.Quantidade) as total_vendido FROM produto JOIN itempedido ON produto.CodProduto = itempedido.CodProduto GROUP BY itempedido.CodProduto ORDER BY total_vendido;
/*24*/
SELECT produto.Descricao, SUM(itempedido.Quantidade) as total_vendido FROM produto 
JOIN itempedido ON produto.CodProduto = itempedido.CodProduto 
WHERE (produto.Descricao LIKE '%IPHONE%' OR produto.Descricao LIKE 'APPLE' OR produto.Descricao LIKE '%MAC%') 
AND produto.Descricao NOT LIKE '%CAPA%' AND produto.Descricao NOT LIKE '%PELICULA%' AND produto.Descricao NOT LIKE '%CABO%' AND produto.Descricao NOT LIKE '%ADAP%' AND produto.Descricao NOT LIKE '%ICLAM%' 
GROUP BY itempedido.CodProduto ORDER BY total_vendido;

/*DBAs troço*/

CREATE VIEW total_DBAs AS ( /*Seleciona o total vendido por cada vendedor*/
SELECT vendedor.CodVendedor, vendedor.Nome, vendedor.FaixaComissao,vendedor.SalarioFixo,
SUM(produto.ValorUnitario*itempedido.Quantidade) as total_vendido  
FROM vendedor
JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor 
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido 
JOIN produto ON itempedido.CodProduto = produto.CodProduto 
WHERE YEAR(pedido.DataPedido) = '2015'
GROUP BY vendedor.CodVendedor
);

/*Cede a comissão de acordo com a faixa de comissao*/
CREATE VIEW classe_A AS (SELECT total_DBAs.CodVendedor,total_DBAs.Nome,total_DBAs.FaixaComissao, ROUND((total_DBAs.total_vendido*0.2),2) as 'comissao' FROM total_DBAs WHERE total_DBAs.FaixaComissao ='A');
CREATE VIEW classe_B AS (SELECT total_DBAs.CodVendedor,total_DBAs.Nome,total_DBAs.FaixaComissao,ROUND((total_DBAs.total_vendido*0.15),2) as 'comissao' FROM total_DBAs WHERE total_DBAs.FaixaComissao ='B');
CREATE VIEW classe_C AS (SELECT total_DBAs.CodVendedor,total_DBAs.Nome,total_DBAs.FaixaComissao,ROUND((total_DBAs.total_vendido*0.1),2) as 'comissao' FROM total_DBAs WHERE total_DBAs.FaixaComissao ='C');
CREATE VIEW classe_D AS (SELECT total_DBAs.CodVendedor,total_DBAs.Nome,total_DBAs.FaixaComissao,ROUND((total_DBAs.total_vendido*0.05),2) as 'comissao' FROM total_DBAs WHERE total_DBAs.FaixaComissao ='D');

/*Une as faixas de comissao*/
CREATE VIEW comissoes_2015 AS SELECT classe_A.* FROM classe_A  UNION SELECT classe_B.* FROM classe_B UNION SELECT classe_C.* FROM classe_C UNION  SELECT  classe_D.* FROM classe_D;

SELECT * FROM comissoes_2015;
DROP VIEW comissoes_2015;

SELECT * from total_DBAs; 
DROP VIEW total_DBAs;

SELECT * from classe_A; 
DROP VIEW classe_A;

SELECT * FROM classe_B; 
DROP VIEW classe_B;

SELECT * FROM classe_C; 
DROP VIEW classe_C;

SELECT * FROM classe_D; 
DROP VIEW classe_D;

