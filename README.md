# Projeto SQL: Análise de Fraude em Cartão de Crédito

## 🎯 Objetivo

Investigar um dataset de transações de cartão de crédito para identificar padrões em transações fraudulentas usando SQL. O objetivo é responder perguntas de negócio como: "Qual o impacto financeiro das fraudes?" e "As fraudes seguem algum padrão de valor?".

## 📂 Dataset

Foi utilizado o dataset "Credit Card Fraud Detection" do Kaggle, contendo transações europeias. A tabela `transacoes` possui 284.807 linhas.

---

## 🔍 Análise e Descobertas

Usei consultas SQL no PostgreSQL para extrair os seguintes insights:

### Descoberta 1: Fraudes são raras, mas existem

A primeira consulta revelou que o dataset é altamente desbalanceado. A esmagadora maioria das transações é legítima.

* **Transações Legítimas (Classe 0):** 284.315
* **Transações Fraudulentas (Classe 1):** 492

Isso significa que apenas **0,17%** do total de transações são fraudes. Isso confirma que a detecção é um problema de "achar uma agulha no palheiro".

*(Consulta SQL utilizada)*
```sql
-- Query 1: Contagem de transações legítimas (0) vs. fraudulentas (1)
SELECT
  "Class",
  COUNT(*) AS total_transacoes
FROM
  transacoes
GROUP BY
  "Class";
Descoberta 2: O "Ticket Médio" da fraude é maior
A segunda consulta comparou o impacto financeiro. Embora raras, as transações fraudulentas tendem a ter um valor individual mais alto.

Valor Médio (Legítima): R$ 88,29

Valor Médio (Fraude): R$ 122,21

Uma fraude é, em média, 38,4% mais cara que uma transação normal, mostrando que elas causam um prejuízo financeiro individual significativo.

(Consulta SQL utilizada)

SQL

-- Query 2: Valor total e médio por tipo de transação
SELECT
  "Class",
  SUM("Amount") AS valor_total_movimentado,
  AVG("Amount") AS valor_medio_por_transacao
FROM
  transacoes
GROUP BY
  "Class";
Descoberta 3: A maioria das fraudes se concentra em valores baixos
A terceira consulta investigou onde as fraudes acontecem. E aqui está o insight mais importante:

56,7% de todas as fraudes (279 de 492) ocorrem em transações de valor baixo (entre R$ 1 e R$ 50).

Transações de "Valor Zero" (27 casos) e valores entre "R$ 51 - R$ 100" (56 casos) também são relevantes.

(Consulta SQL utilizada)

SQL

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
🏁 Conclusão da Análise
A análise SQL revelou um comportamento contraditório e valioso:

A média do valor da fraude (R$ 122) é alta.

A maioria dos casos de fraude (56,7%) ocorre em valores baixos (abaixo de R$ 50).

Isso significa que a média é "puxada para cima" por algumas poucas fraudes de valor extremo (o grupo "Acima de R$ 500"). No entanto, a tática mais comum dos fraudadores parece ser testar os cartões com valores pequenos, talvez para verificar se estão ativos antes de um golpe maior.
