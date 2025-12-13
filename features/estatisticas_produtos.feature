Feature: Estatísticas de Produtos
    Como gestor do negócio
    Eu quero visualizar estatísticas dos produtos vendidos
    Para identificar quais produtos são mais importantes para o negócio

  Scenario: Visualizar produtos mais vendidos
    Given que existem danfes com diferentes produtos cadastradas
    When eu acesso a página de estatísticas de produtos
    Then eu devo ver a lista de produtos ordenados por valor total
    And eu devo ver o valor total de cada produto
    And eu devo ver a quantidade de vendas de cada produto

  Scenario: Visualizar produtos agrupados por NCM
    Given que existem danfes com produtos de mesmo NCM
    When eu acesso a página de estatísticas de produtos
    And eu seleciono a visualização "Por NCM"
    Then eu devo ver os produtos agrupados por código NCM
    And eu devo ver o valor total por NCM

  Scenario: Filtrar produtos por período
    Given que existem danfes com produtos em diferentes períodos
    When eu acesso a página de estatísticas de produtos
    And eu seleciono o período de produtos de "01/01/2025" a "30/06/2025"
    Then eu devo ver apenas produtos vendidos nesse período

  Scenario: Exportar estatísticas de produtos
    Given que existem danfes com produtos cadastradas
    When eu acesso a página de estatísticas de produtos
    And eu clico no botão "Exportar Estatísticas"
    Then eu devo receber um arquivo "produtos.csv"
    And o arquivo deve conter os dados de produtos

  Scenario: Nenhum produto cadastrado
    Given que não existem danfes cadastradas no sistema
    When eu acesso a página de estatísticas de produtos
    Then eu devo ver a mensagem "Não há dados de produtos disponíveis"
