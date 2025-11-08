-- Query 1: Contagem de transações legítimas (0) vs. fraudulentas (1)
SELECT
  "Class",
  COUNT(*) AS total_transacoes
FROM
  transacoes
GROUP BY
  "Class";

-- Query 2: Valor total e médio por tipo de transação
SELECT
  "Class",
  COUNT(*) AS total_transacoes,
  SUM("Amount") AS valor_total_movimentado,
  AVG("Amount") AS valor_medio_por_transacao
FROM
  transacoes
GROUP BY
  "Class";

-- Query 3: Contagem de fraudes por faixa de valor
SELECT
  CASE
    WHEN "Amount" = 0 THEN 'Valor Zero'
    WHEN "Amount" > 0 AND "Amount" <= 50 THEN 'R$ 1 - R$ 50'
    WHEN "Amount" > 50 AND "Amount" <= 100 THEN 'R$ 51 - R$ 100'
    WHEN "Amount" > 100 AND "Amount" <= 500 THEN 'R$ 101 - R$ 500'
    ELSE 'Acima de R$ 500'
  END AS faixa_de_valor,

  COUNT(*) AS total_fraudes

FROM
  transacoes

WHERE
  "Class" = 1  -- Filtramos APENAS para transações fraudulentas

GROUP BY
  faixa_de_valor

ORDER BY
  total_fraudes DESC;