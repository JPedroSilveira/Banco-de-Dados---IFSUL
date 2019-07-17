/*1) Mostre todos os dados dos clientes e a quantidade total de pedidos de cada cliente. Note que os
clientes que não fizeram nenhum pedido devem ser listados. (1576 linhas)*/

SELECT c.*, count(pd.CodPedido) FROM cliente as c
LEFT JOIN pedido as pd
ON c.CodCliente = pd.CodCliente
GROUP BY c.CodCliente;

/*2) Exiba uma relação em ordem alfabética do código do cliente e nome dos clientes que nunca fizeram
nenhum pedido. (7 linhas)*/

SELECT c.CodCliente, c.Nome AS cliente FROM cliente AS c
LEFT JOIN pedido as pd
ON c.CodCliente = pd.CodCliente
WHERE pd.CodCliente IS NULL
ORDER BY c.Nome ASC;

/*3) Mostre o código do produto, a descrição e o valor total obtido por cada produto ao longo da história
da loja. Ordene a lista pelo valor total dos produtos. Observe que mesmo os produtos que nunca foram
vendidos devem ser exibidos. (4763 linhas)*/

SELECT pr.CodProduto, pr.Descricao, sum(pr.ValorUnitario*it.Quantidade) as `total obtido` FROM produto as pr
LEFT JOIN itempedido as it
ON pr.CodProduto = it.CodProduto
GROUP BY pr.CodProduto;
-- Por que não posso colocar INNER JOIN com a tabela pedido? Por que não precisa?

/*4) Mostre o ano, código do produto, a descrição e o valor total obtido dos produtos que arrecadaram
mais que R$50.000,00 em um único ano. Ordene a lista por valor total. (411 linhas)*/

SELECT YEAR(pd.DataPedido), pr.CodProduto, pr.Descricao, sum(pr.ValorUnitario*it.Quantidade) 
as `total obtido dos produtos que arrecadaram mais de R$50.000 em um ano`
FROM produto as pr
INNER JOIN itempedido as it
ON pr.CodProduto = it.CodProduto
INNER JOIN pedido as pd
ON pd.CodPedido = it.CodPedido
GROUP BY YEAR(pd.DataPedido), pr.CodProduto
HAVING `total obtido dos produtos que arrecadaram mais de R$50.000 em um ano` > 50.000;

/*5) Mostre todos os dados dos vendedores e a quantidade total de pedidos efetuados por cada
vendedor. A relação deve contar apenas os vendedores de faixa de comissão “A” e ordenados pela
quantidade total de pedidos. (48 linhas)*/

SELECT v.*, count(pd.CodPedido) AS `total de pedidos` FROM vendedor AS v
INNER JOIN pedido AS pd
ON v.CodVendedor = pd.CodVendedor
WHERE v.FaixaComissao LIKE "A"
GROUP BY v.CodVendedor
ORDER BY `total de pedidos`;

/*6) Exiba os dados dos pedidos e a quantidade de produtos diferentes em cada pedido. A relação deve
conter apenas os pedidos do ano de 2016 e deve ser ordenada pela quantidade de produtos diferentes.
Note que os pedidos que não possuem nenhum produto devem ser listados. (1011 linhas)*/

SELECT pd.*, count(pr.CodProduto) `qtde produtos diferentes` FROM pedido AS pd
LEFT JOIN itempedido AS it
ON it.CodPedido = pd.CodPedido
LEFT JOIN produto AS pr
ON it.CodProduto = pr.CodProduto
WHERE YEAR(pd.DataPedido) = 2016
GROUP BY pd.CodPedido
ORDER BY `qtde produtos diferentes`;

/*7) Exiba uma relação com a quantidade total de pedidos para cada ano/mês. Ordene esta relação pela
quantidade total de pedidos em ordem decrescente. (38 linhas)*/

SELECT EXTRACT(YEAR FROM pd.DataPedido) AS ano, MONTH(pd.DataPedido) AS `mês`, count(pd.CodPedido) `qtde pedidos`
FROM pedido AS pd
GROUP BY ano, `mês`
ORDER BY `qtde pedidos` DESC;

/*8) Exiba uma relação com o valor total vendido para cada ano/mês. Ordene esta relação pelo valor
total em ordem decrescente. (38 linhas)*/

SELECT YEAR(pd.DataPedido) AS ano, MONTH(pd.DataPedido) as mes, sum(pr.ValorUnitario*it.Quantidade) AS `total vendido`
FROM pedido AS pd
INNER JOIN itempedido AS it
ON it.CodPedido = pd.CodPedido
INNER JOIN produto AS pr
ON pr.CodProduto = it.CodProduto
GROUP BY ano, mes
ORDER BY `total vendido` DESC;

/*9) Crie um ranking com o código do cliente, nome do cliente e a quantidade total de itens comprados
por cada cliente. Ordene esta relação pela quantidade total de itens comprados. (1557 linhas)*/

SELECT c.CodCliente, c.Nome as cliente, sum(it.Quantidade) as `total de itens comprados` FROM cliente as c
INNER JOIN pedido as pd
ON pd.CodCliente = c.CodCliente
INNER JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
GROUP BY c.CodCliente
ORDER BY `total de itens comprados`;

/*10) Crie um ranking com o código do vendedor, nome do vendedor e quantidade total de itens
vendidos por cada vendedor durante o ano de 2015. Ordene esta relação pela quantidade total de itens
vendidos. (244 linhas)*/

SELECT v.CodVendedor, v.Nome as vendedor, sum(it.Quantidade) as `total de itens vendidos` FROM vendedor as v
INNER JOIN pedido as pd
ON pd.CodVendedor = v.CodVendedor
INNER JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
WHERE YEAR(pd.DataPedido) = 2015
GROUP BY v.CodVendedor
ORDER BY `total de itens vendidos`;

/*11) Mostre os dados (código, descrição, valor unitário) dos produtos, bem como a quantidade de
pedidos que solicitaram esses produtos, a quantidade total de itens vendidos e o valor total obtido em
todas as vendas. Ordene a lista pelo valor total obtido em vendas de cada um dos produtos (do maior
para o menor). (4407 linhas)*/

SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario, 
count(pd.CodPedido) as `qtde de pedidos que solicitaram esse produto`,
sum(it.Quantidade) `total de itens vendidos`, 
sum(pr.ValorUnitario*it.Quantidade) as `total obtido em todas as vendas`
FROM produto as pr
INNER JOIN itempedido as it
ON it.CodProduto = pr.CodProduto
INNER JOIN pedido as pd
ON pd.CodPedido = it.CodPedido
GROUP BY pr.CodProduto
ORDER BY `total obtido em todas as vendas` DESC;

/*12) Exiba uma relação contendo o código do pedido, a data do pedido e o valor total dos pedidos de
2016. A lista deve ser ordenada pelo valor total de cada pedido em ordem decrescente. Note que os
pedidos que não possuem nenhum produto, ou seja, o seu valor total é zero, devem ser exibidos. (1011
linhas)*/

SELECT pd.CodPedido, pd.DataPedido, sum(pr.ValorUnitario*it.Quantidade) as `valor total` FROM pedido as pd
LEFT JOIN itempedido as it
ON it.CodPedido = pd.CodPEdido
LEFT JOIN produto as pr
ON pr.CodProduto = it.CodProduto
WHERE YEAR(pd.DataPedido) = 2016
GROUP BY pd.CodPedido
ORDER BY `valor total` DESC;

/*13) Exiba o código, a data do pedido, o código do cliente e o código do vendedor, dos pedidos que
não possuem nenhum produto vendido. Isso quer dizer que um pedido foi cadastrado, mas não há
nenhum item cadastrado. (1925 linhas)*/

SELECT pd.CodPedido, pd.DataPedido, c.CodCliente, v.CodVendedor FROM pedido as pd
INNER JOIN cliente as c
ON c.CodCliente = pd.CodCliente
INNER JOIN vendedor as v
ON v.CodVendedor = pd.CodVendedor
LEFT JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
WHERE it.CodPedido IS NULL
GROUP BY pd.CodPedido;

/*14) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba uma relação
contendo ano, mês e a quantidade de pedidos sem nenhum item cadastrado. A lista deve ser ordenada
pela quantidade de pedidos sem nenhum item cadastrado em ordem decrescente. (38 linhas)*/

SELECT YEAR(temp.DataPedido) as ano, MONTH(temp.DataPedido) as mes, 
count(temp.CodPedido) as `qtde pedidos sem itens`
FROM (SELECT pd.CodPedido, pd.DataPedido, c.CodCliente, v.CodVendedor FROM pedido as pd
INNER JOIN cliente as c
ON c.CodCliente = pd.CodCliente
INNER JOIN vendedor as v
ON v.CodVendedor = pd.CodVendedor
LEFT JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
WHERE it.CodPedido IS NULL
GROUP BY pd.CodPedido) as temp
GROUP BY ano, mes
ORDER BY `qtde pedidos sem itens` DESC;

/*15) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba um ranking
contendo o código do cliente, o nome e a quantidade de pedidos efetuados, nos quais o cliente não
adicionou nenhum item. Novamente a lista deve ser ordenada pela quantidade de pedidos sem
nenhum item cadastrados em ordem decrescente. (1129 linhas)*/

SELECT temp.CodCliente, c.Nome as cliente, count(temp.CodPedido) as `qtde pedidos sem itens`
FROM (SELECT pd.CodPedido, pd.DataPedido, c.CodCliente, v.CodVendedor FROM pedido as pd
INNER JOIN cliente as c
ON c.CodCliente = pd.CodCliente
INNER JOIN vendedor as v
ON v.CodVendedor = pd.CodVendedor
LEFT JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
WHERE it.CodPedido IS NULL
GROUP BY pd.CodPedido) as temp, cliente as c
WHERE c.CodCliente = temp.CodCliente
GROUP BY temp.CodCliente
ORDER BY `qtde pedidos sem itens` DESC;

/*16) Utilize a query desenvolvida na questão 13 como uma tabela temporária. Exiba um ranking
contendo o código do vendedor, o nome e a quantidade de pedidos, nos quais não foram adicionados
nenhum item. Novamente a lista deve ser ordenada pela quantidade de pedidos sem nenhum item
cadastrados em ordem decrescente. (244 linhas)*/

SELECT temp.CodVendedor, v.Nome as vendedor, count(temp.CodPedido) as `qtde pedidos sem itens`
FROM (SELECT pd.CodPedido, pd.DataPedido, c.CodCliente, v.CodVendedor FROM pedido as pd
INNER JOIN cliente as c
ON c.CodCliente = pd.CodCliente
INNER JOIN vendedor as v
ON v.CodVendedor = pd.CodVendedor
LEFT JOIN itempedido as it
ON it.CodPedido = pd.CodPedido
WHERE it.CodPedido IS NULL
GROUP BY pd.CodPedido) as temp, vendedor as v
WHERE v.CodVendedor = temp.CodVendedor
GROUP BY temp.CodVendedor
ORDER BY `qtde pedidos sem itens` DESC;