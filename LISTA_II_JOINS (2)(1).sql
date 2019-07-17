/*LISTA 2 JOINS*/
/*1 OK*/
CREATE VIEW SONY AS(
SELECT produto.* FROM produto WHERE produto.Descricao LIKE '%SONY%'
);
/*2 OK*//*NO EXERCICIO FALA 1 LINHA DE RESPOSTA E NO MEU DEU 6*/
SELECT produto.* FROM produto WHERE produto.Descricao LIKE '%MICROSOFT%';
/*3 OK*/
SELECT SUM(SONY.ValorUnitario) as valor FROM SONY;
SELECT SUM(produto.ValorUnitario) as valor FROM produto WHERE produto.Descricao LIKE '%SONY%';
/*4 OK com LIMIT tenha cuidado*/
SELECT produto.*, SUM(produto.ValorUnitario*itempedido.Quantidade) as Valor_circulado 
FROM produto JOIN itempedido ON produto.CodProduto = itempedido.CodProduto 
GROUP BY produto.CodProduto ORDER BY Valor_circulado DESC LIMIT 5;
/*5 OK com LIMIT tenha cuidado*/
SELECT produto.*, SUM(itempedido.Quantidade) as Total_vendido
FROM produto 
JOIN itempedido ON produto.Codproduto = itempedido.CodProduto
JOIN pedido ON itempedido.CodPedido = pedido.CodPedido
WHERE YEAR(pedido.DataPedido) = '2015' AND MONTH(pedido.DataPedido) = '08'
GROUP BY produto.CodProduto ORDER BY Total_vendido DESC LIMIT 10;
/*6 OK, com LIMIT tenha cuidado*/
SELECT produto.*, SUM(itempedido.Quantidade*produto.ValorUnitario) as Total_vendido
FROM produto 
JOIN itempedido ON produto.Codproduto = itempedido.CodProduto
JOIN pedido ON itempedido.CodPedido = pedido.CodPedido
WHERE MONTH(pedido.DataPedido) = '06'
GROUP BY produto.CodProduto ORDER BY Total_vendido DESC LIMIT 20;
/*7*/
SELECT cliente.Nome, pedido.*, SUM(produto.ValorUnitario*itempedido.Quantidade) as valor_total
FROM cliente
JOIN pedido ON cliente.CodCliente =  pedido.CodPedido
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
JOIN produto ON itempedido.CodProduto = produto.CodProduto
GROUP BY pedido.CodPedido 
ORDER BY valor_total DESC;
/*8 com LIMIT tenha cuidado*/
SELECT vendedor.CodVendedor, SUM(pedido.CodPedido) as total_vendido
FROM vendedor 
JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor
WHERE MONTH(pedido.DataPedido) = '08'
GROUP BY vendedor.CodVendedor
ORDER BY total_vendido DESC
LIMIT 10;
/*9 com LIMIT tenha cuidado*/
SELECT cliente.Nome, pedido.*, SUM(produto.ValorUnitario*itempedido.Quantidade) as valor_total
FROM pedido
INNER JOIN cliente ON pedido.CodCliente = cliente.CodCliente
INNER JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
INNER JOIN produto ON itempedido.CodProduto = produto.CodProduto
WHERE YEAR(pedido.DataPedido) = '2015'
GROUP BY pedido.CodPedido 
ORDER BY valor_total ASC
LIMIT 10;

/*10 Sem média*/

CREATE VIEW Pedido_preco AS(
SELECT pedido.CodPedido, SUM(produto.ValorUnitario*itempedido.Quantidade) as valor_pedido
FROM pedido
INNER JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
INNER JOIN produto ON itempedido.CodProduto = produto.CodProduto
GROUP BY pedido.CodPedido, YEAR(pedido.DataPedido) 
);
CREATE VIEW Mais_caro AS(
SELECT Pedido_preco.CodPedido, Pedido_preco.valor_pedido FROM Pedido_preco 
ORDER BY Pedido_preco.valor_pedido ASC LIMIT 1
);
CREATE VIEW Mais_barato AS(
SELECT Pedido_preco.CodPedido, Pedido_preco.valor_pedido FROM Pedido_preco 
ORDER BY Pedido_preco.valor_pedido DESC LIMIT 1
);
CREATE VIEW Média AS(
SELECT AVG(Pedido_preco.valor_pedido) FROM Pedido_preco
);

CREATE VIEW resposta AS SELECT Mais_caro.* FROM Mais_caro UNION SELECT Mais_barato.* FROM Mais_barato;

SELECT * FROM resposta;
SELECT * FROM Média;

/*11*/


