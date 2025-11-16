Feature: Visualização de gráficos
    Como gerente de vendas
    Eu quero visualizar gráficos sobre notas fiscais e metas
    Para que eu possa analisar as vendas em tempo real

    Scenario: Exibir gráfico de vendas, despesas e orçamento
        Given que eu estou logado no sistema
        When eu acesso a página de gráficos
        Then devo visualizar o gráfico de Vendas X Despesas X Orçamento
        
    Scenario: Exibir gráfico de metas e vendas
        Given que eu estou logado no sistema
        When eu acesso a página de gráficos
        Then devo visualizar o gráfico de Metas X Vendas

    Scenario: Exibir gráfico de pizza de metas e vendas
        Given que eu estou logado no sistema
        And existe o valor meta 800
        When eu acesso a página de gráficos
        Then devo visualizar o gráfico de pizza de Meta X Vendas
        And devo ver a mensagem "Ainda restam R$800,00 para atingir a meta!" no gráfico de vendas meta

    Scenario: Não há valor meta no mês atual
        Given que eu estou logado no sistema
        Given que não existe valor meta
        When eu acesso a página de gráficos
        Then devo ver a mensagem "Você ainda não registrou nenhuma meta de vendas para o mês atual :(" no gráfico de vendas meta
        
        