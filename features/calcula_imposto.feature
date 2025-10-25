Feature: Cálculo de imposto 
    Como gestor do negócio 
    Eu quero saber quanto do valor das vendas foi de imposto
    Para avaliar estratégias de crescimento 

  Scenario: Calcular total de impostos por mês
    Given que existem danfes com impostos em diferentes meses
    When eu acesso a página de cálculo de impostos
    And eu seleciono a visualização de impostos "Por Mês"
    Then eu devo ver o total de impostos agrupado por mês
    And eu devo ver o percentual de impostos sobre as vendas

  Scenario: Comparar carga tributária por cliente
    Given que existem danfes de diferentes clientes com impostos
    When eu acesso a página de cálculo de impostos
    And eu seleciono a visualização de impostos "Por Cliente"
    Then eu devo ver a carga tributária de cada cliente
    And eu devo ver o percentual de impostos sobre o faturamento por cliente

  Scenario: Filtrar cálculo de impostos por período
    Given que existem danfes com impostos em diferentes períodos
    When eu acesso a página de cálculo de impostos
    And eu seleciono o período para impostos de "01/01/2025" a "31/03/2025"
    Then eu devo ver apenas os impostos desse período
    And o total deve corresponder às danfes do período selecionado

  Scenario: Exportar relatório de impostos
    Given que existem danfes cadastradas com impostos
    When eu acesso a página de cálculo de impostos
    And eu clico no botão de impostos "Exportar Relatório de Impostos"
    Then eu devo receber um arquivo de impostos "relatorio_impostos.csv"
    And o arquivo deve conter os dados detalhados de impostos por danfe

  Scenario: Visualizar margem líquida após impostos
    Given que existem danfes com valores e impostos
    When eu acesso a página de cálculo de impostos
    And eu seleciono a visualização de impostos "Análise de Margem"
    Then eu devo ver o valor total das vendas
    And eu devo ver o valor total dos impostos
    And eu devo ver a margem líquida (vendas - impostos)
    And eu devo ver o percentual de margem líquida

  Scenario: Nenhuma danfe com impostos cadastrada
    Given que não existem danfes cadastradas no sistema
    When eu acesso a página de cálculo de impostos
    Then eu devo ver a mensagem de impostos "Não há dados de impostos disponíveis" 