/*1) Mostre todos os dados dos clientes e a quantidade total de pedidos de cada cliente. Note que os
clientes que não fizeram nenhum pedido devem ser listados. (1576 linhas)*/

SELECT cliente.*, COUNT(pedido.CodCliente) as 'Pedidos realizados' FROM cliente 
LEFT JOIN pedido ON cliente.CodCliente = pedido.CodCliente GROUP BY cliente.CodCliente;

/*2) Exiba uma relação em ordem alfabética do código do cliente e nome dos clientes que nunca fizeram
nenhum pedido. (7 linhas)*/

SELECT cliente.CodCliente, cliente.Nome FROm cliente
LEFT JOIN pedido ON cliente.CodCliente = pedido.CodCliente 
GROUP BY cliente.CodCliente
HAVING COUNT(pedido.CodCliente) = 0
ORDER BY cliente.Nome;

SELECT cliente.CodCliente, cliente.Nome FROm cliente
LEFT JOIN pedido ON cliente.CodCliente = pedido.CodCliente 
WHERE pedido.CodCliente IS NULL
ORDER BY cliente.Nome;


/*3) Mostre o código do produto, a descrição e o valor total obtido por cada produto ao longo da história
da loja. Ordene a lista pelo valor total dos produtos. Observe que mesmo os produtos que nunca foram
vendidos devem ser exibidos. (4763 linhas)*/

SELECT produto.CodProduto, produto.Descricao, SUM(itempedido.Quantidade*produto.ValorUnitario) as vendido
FROM produto LEFT JOIN itempedido ON produto.CodProduto = itempedido.CodProduto
GROUP BY produto.CodProduto
ORDER BY vendido;

/*4) Mostre o ano, código do produto, a descrição e o valor total obtido dos produtos que arrecadaram
mais que R$50.000,00 em um único ano. Ordene a lista por valor total. (411 linhas)*/

SELECT YEAR(pedido.DataPedido) as 'ano', produto.CodProduto, produto.Descricao, SUM(itempedido.Quantidade*produto.ValorUnitario) as 'vendido'
FROM pedido JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido JOIN produto ON itempedido.CodProduto = produto.CodProduto
GROUP BY produto.CodProduto, YEAR(pedido.DataPedido)
HAVING SUM(itempedido.Quantidade*produto.ValorUnitario)>50000
ORDER BY SUM(itempedido.Quantidade*produto.ValorUnitario);


/*5) Mostre todos os dados dos vendedores e a quantidade total de pedidos efetuados por cada
vendedor. A relação deve contar apenas os vendedores de faixa de comissão “A” e ordenados pela
quantidade total de pedidos. (48 linhas)*/

SELECT vendedor.*, COUNT(pedido.CodPedido) as vendido
FROM vendedor JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor
WHERE vendedor.FaixaComissao = 'A' 
GROUP BY vendedor.CodVendedor
ORDER BY COUNT(pedido.CodPedido);

/*6) Exiba os dados dos pedidos e a quantidade de produtos diferentes em cada pedido. A relação deve
conter apenas os pedidos do ano de 2016 e deve ser ordenada pela quantidade de produtos diferentes.
Note que os pedidos que não possuem nenhum produto devem ser listados. (1011 linhas)*/

SELECT pedido.*, COUNT(produto.CodProduto) as quantidade
FROM pedido 
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
LEFT JOIN produto ON itempedido.CodProduto = produto.CodProduto
WHERE YEAR(pedido.DataPedido) = 2016 
GROUP BY pedido.CodPedido
ORDER BY quantidade;

/*7) Exiba uma relação com a quantidade total de pedidos para cada ano/mês. Ordene esta relação pela
quantidade total de pedidos em ordem decrescente. (38 linhas)*/

SELECT YEAR(pedido.DataPedido) as ano, MONTH(pedido.DataPedido) as mês, COUNT(pedido.CodPedido) as quantidade
FROM pedido
GROUP BY  YEAR(pedido.DataPedido), MONTH(pedido.DataPedido)
ORDER BY quantidade DESC;

/*8) Exiba uma relação com o valor total vendido para cada ano/mês. Ordene esta relação pelo valor
total em ordem decrescente. (38 linhas)*/

SELECT  YEAR(pedido.DataPedido) as ano, MONTH(pedido.DataPedido) as mês, SUM(itempedido.Quantidade*produto.ValorUnitario) as valor_vendido
FROM pedido 
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
JOIN produto ON itempedido.CodProduto = produto.CodProduto
GROUP BY YEAR(pedido.DataPedido), MONTH(pedido.DataPedido)
ORDER BY valor_vendido DESC;

/*9) Crie um ranking com o código do cliente, nome do cliente e a quantidade total de itens comprados
por cada cliente. Ordene esta relação pela quantidade total de itens comprados. (1557 linhas)*/

SELECT cliente.CodCliente, cliente.Nome, SUM(itempedido.Quantidade) as comprados
FROM cliente JOIN pedido ON cliente.CodCliente = pedido.CodCliente
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
GROUP BY cliente.CodCliente
ORDER BY comprados;

/*10) Crie um ranking com o código do vendedor, nome do vendedor e quantidade total de itens
vendidos por cada vendedor durante o ano de 2015. Ordene esta relação pela quantidade total de itens
vendidos. (244 linhas)*/

SELECT vendedor.CodVendedor, vendedor.Nome, SUM(itempedido.Quantidade) as comprados
FROM vendedor JOIN pedido ON vendedor.CodVendedor = pedido.CodVendedor
JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE YEAR(Pedido.DataPedido)=2015
GROUP BY vendedor.CodVendedor
ORDER BY comprados;

/*11) Mostre os dados (código, descrição, valor unitário) dos produtos, bem como a quantidade de
pedidos que solicitaram esses produtos, a quantidade total de itens vendidos e o valor total obtido em
todas as vendas. Ordene a lista pelo valor total obtido em vendas de cada um dos produtos (do maior
para o menor). (4407 linhas)*/

SELECT produto.*, 
COUNT(pedido.CodPedido) as 'quantidade de
pedidos que solicitaram esses produtos', 
SUM(itempedido.Quantidade) as 'total de itens vendidos', 
SUM(itempedido.Quantidade*produto.ValorUnitario) as valor_total
FROM produto 
JOIN itempedido ON produto.CodProduto = itempedido.CodProduto
JOIN pedido ON itempedido.CodPedido = pedido.CodPedido
GROUP BY produto.CodProduto 
ORDER BY valor_total DESC;

/*12) Exiba uma relação contendo o código do pedido, a data do pedido e o valor total dos pedidos de
2016. A lista deve ser ordenada pelo valor total de cada pedido em ordem decrescente. Note que os
pedidos que não possuem nenhum produto, ou seja, o seu valor total é zero, devem ser exibidos. (1011
linhas)*/

SELECT pedido.CodPedido, pedido.DataPedido, SUM(itempedido.Quantidade*produto.ValorUnitario) as total
FROM pedido LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
LEFT JOIN produto ON itempedido.CodProduto = produto.CodProduto
WHERE YEAR(pedido.DataPedido) = '2016'
GROUP BY pedido.CodPedido
ORDER BY total DESC;

/*13) Exiba o código, a data do pedido, o código do cliente e o código do vendedor, dos pedidos que
não possuem nenhum produto vendido. Isso quer dizer que um pedido foi cadastrado, mas não há
nenhum item cadastrado. (1925 linhas)*/

SELECT pedido.CodPedido, pedido.DataPedido, pedido.CodCliente, pedido.CodVendedor FROM pedido
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE itempedido.CodPedido IS NULL
GROUP BY pedido.CodPedido;

/*14) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba uma relação
contendo ano, mês e a quantidade de pedidos sem nenhum item cadastrado. A lista deve ser ordenada
pela quantidade de pedidos sem nenhum item cadastrado em ordem decrescente. (38 linhas)*/

/*MODO 1*/
CREATE VIEW temp_table AS(
SELECT pedido.CodPedido, pedido.DataPedido, pedido.CodCliente, pedido.CodVendedor FROM pedido
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE itempedido.CodPedido IS NULL
GROUP BY pedido.CodPedido
);

SELECT YEAR(temp_table.DataPedido) as ano, MONTH(temp_table.DataPedido) as mes, COUNT(temp_table.CodPedido) as quant_null 
FROM temp_table
GROUP BY ano,mes
ORDER BY quant_null DESC;

/*MODO 2*/

SELECT YEAR(temp.DataPedido) as ano, MONTH(temp.DataPedido) as mes, COUNT(temp.CodPedido) as quant_null FROM (
SELECT pedido.CodPedido, pedido.DataPedido FROM pedido
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE itempedido.CodPedido IS NULL
GROUP BY pedido.CodPedido
) as temp
GROUP BY ano,mes
ORDER BY quant_null DESC;

/*15) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba um ranking
contendo o código do cliente, o nome e a quantidade de pedidos efetuados, nos quais o cliente não
adicionou nenhum item. Novamente a lista deve ser ordenada pela quantidade de pedidos sem
nenhum item cadastrados em ordem decrescente. (1129 linhas)*/

/*MODO 1*/
SELECT temp_table.CodCliente, Cliente.Nome, COUNT(temp_table.CodPedido) as quant FROM temp_table
LEFT JOIN cliente ON temp_table.CodCliente = cliente.CodCliente
GROUP BY temp_table.CodCliente
ORDER BY quant DESC;

/*MODO 2*/
SELECT temp.CodCliente, Cliente.Nome, COUNT(temp.CodPedido) as quant FROM(
SELECT pedido.CodPedido, pedido.DataPedido, pedido.CodCliente, pedido.CodVendedor FROM pedido
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE itempedido.CodPedido IS NULL
GROUP BY pedido.CodPedido
) as temp
LEFT JOIN cliente ON temp.CodCliente = cliente.CodCliente
GROUP BY temp.CodCliente
ORDER BY quant DESC;

/*16) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba um ranking
contendo o código do vendedor, o nome e a quantidade de pedidos, nos quais não foram adicionados
nenhum item. Novamente a lista deve ser ordenada pela quantidade de pedidos sem nenhum item
cadastrados em ordem decrescente. (244 linhas)*/

/*MODO 1*/
SELECT temp_table.CodVendedor, vendedor.Nome, COUNT(temp_table.CodPedido) as quant FROM temp_table
LEFT JOIN vendedor ON temp_table.CodVendedor = vendedor.CodVendedor
GROUP BY temp_table.CodVendedor
ORDER BY quant DESC;

/*MODO 2*/
SELECT temp.CodVendedor, vendedor.Nome, COUNT(temp.CodPedido) as quant FROM(
SELECT pedido.CodPedido, pedido.DataPedido, pedido.CodCliente, pedido.CodVendedor FROM pedido
LEFT JOIN itempedido ON pedido.CodPedido = itempedido.CodPedido
WHERE itempedido.CodPedido IS NULL
GROUP BY pedido.CodPedido
) as temp
LEFT JOIN vendedor ON temp.CodVendedor = vendedor.CodVendedor
GROUP BY temp.CodVendedor
ORDER BY quant DESC;