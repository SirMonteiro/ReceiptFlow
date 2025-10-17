Feature: Cálculo de Faturamento
    Como gestor financeiro
    Eu quero visualizar o faturamento baseado nos pedidos
    Para que eu possa analisar o desempenho financeiro do negócio

  Scenario: Visualizar faturamento mensal
    Given que existem pedidos em diferentes meses
    When eu acesso a página de faturamento
    Then eu devo ver o faturamento total agrupado por mês

  Scenario: Visualizar faturamento por cliente
    Given que existem pedidos de diferentes clientes
    When eu acesso a página de faturamento
    And eu seleciono a visualização "Por Cliente"
    Then eu devo ver o faturamento total agrupado por cliente

  Scenario: Filtrar faturamento por período
    Given que existem pedidos em diferentes períodos
    When eu acesso a página de faturamento
    And eu seleciono o período de "01/01/2025" a "31/03/2025"
    Then eu devo ver apenas o faturamento desse período

  Scenario: Exportar relatório de faturamento
    Given que existem pedidos cadastrados no sistema
    When eu acesso a página de faturamento
    And eu clico em "Exportar Relatório"
    Then eu devo receber um arquivo "faturamento.csv"
    And o arquivo deve conter os dados de faturamento

  Scenario: Nenhum pedido cadastrado
    Given que não existem pedidos cadastrados no sistema
    When eu acesso a página de faturamento
    Then eu devo ver a mensagem "Não há dados de faturamento disponíveis"