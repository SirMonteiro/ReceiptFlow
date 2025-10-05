Feature: Visualização de gráficos
    Como gerente de vendas
    Eu quero visualizar gráficos sobre notas fiscais e metas
    Para que eu possa analisar as vendas em tempo real

    Scenario: Exibir gráfico de vendas mensais
        Given que existem notas fiscais cadastradas no sistema
        When eu acesso a página de gráficos
        Then devo visualizar um gráfico de barras mostrando o valor total de vendas por mês
        
    Scenario: Exibir gráfico de despesas/ganhos
        Given que existem notas fiscais e o valor de despesas cadastrados no sistema
        When eu acesso a página de gráficos
        Then devo visualizar um gráfico de barras com os valores de despesas e ganhos por mês

    Scenario: Exibir gráfico de vendas/meta
        Given que existem notas fiscais cadastradas em certo mês no sistema e o valor meta mensal
        When eu acesso a página de gráficos
        Then devo visualizar um gráfico de pizza com o valor total arrecadado no mês e o valor meta

    Scenario: Nenhum dado cadastrado
        Given que não existem notas cadastradas no sistema
        When eu acesso a página de gráficos
        Then devo ver a mensagem "Nenhum dado disponível para exibição" nos gráficos
        And não devo ver gráficos

    Scenario: Não há valor meta
        Given que não existe valor meta
        When eu acesso a página de gráficos
        Then devo ver a mensagem "Não há uma meta estabelecida" no gráfico de vendas meta
        
