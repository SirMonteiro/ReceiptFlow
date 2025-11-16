Feature: Volume de vendas por loja
  Como dono da rede de lojas
  Eu quero consultar o volume de vendas por loja
  Para analisar o desempenho financeiro de cada unidade

  Scenario: Consultar volume de vendas por loja em um período
    Given que eu estou logado no sistema
    And existem notas fiscais emitidas para as lojas:
      | number | loja        | cnpj           | valor | data       |
      | 1      | Loja Centro | 12345678000195 | 1500  | 2025-01-05 |
      | 2      | Loja Centro | 12345678000195 | 500   | 2025-01-15 |
      | 3      | Loja Norte  | 98765432000195 | 2500  | 2025-01-20 |
    When eu acesso a página de volume de vendas
    And eu filtro o período de "2025-01-01" até "2025-01-31"
    Then devo ver no relatório de volume de vendas a loja "Loja Centro" com total "R$ 2.000,00" e notas "2"
    And devo ver no relatório de volume de vendas a loja "Loja Norte" com total "R$ 2.500,00" e notas "1"
    And devo ver no relatório de volume de vendas o total geral "R$ 4.500,00"