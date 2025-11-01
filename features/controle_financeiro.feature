Feature: Controle Financeiro
    Como gerente de vendas
    Eu quero adicionar metas, despesas e orçamentos
    Para que eu possa ter o controle financeiro da minha empresa

    Scenario: Criar uma nova meta de vendas mensal
        Given que eu estou logado no sistema
        And não existe uma meta para o mês atual
        When eu acesso a página de controle financeiro
        And preencho o campo "Valor de meta" com "1000"
        And clico em "Criar meta" em controle financeiro
        Then devo ver em controle financeiro "Meta criada com sucesso!"
        
    Scenario: Atualizar uma meta de vendas mensal
        Given que eu estou logado no sistema
        And existe uma meta para o mês atual
        When eu acesso a página de controle financeiro
        And preencho o campo "Valor de meta" com "2000"
        And clico em "Atualizar meta" em controle financeiro
        Then devo ver em controle financeiro "Meta atualizada!"

    Scenario: Excluir uma meta de vendas mensal
        Given que eu estou logado no sistema
        And existe uma meta para o mês atual
        When eu acesso a página de controle financeiro
        And clico em "Excluir meta" em controle financeiro
        Then devo ver em controle financeiro "Meta excluída!"
    
    Scenario: Criar um novo orçamento mensal
        Given que eu estou logado no sistema
        And não existe um orçamento para o mês atual
        When eu acesso a página de controle financeiro
        And preencho o campo "Valor do orçamento" com "1000"
        And clico em "Criar orçamento" em controle financeiro
        Then devo ver em controle financeiro "Orçamento criado!"

    Scenario: Atualizar um orçamento mensal
        Given que eu estou logado no sistema
        And existe um orçamento para o mês atual
        When eu acesso a página de controle financeiro
        And preencho o campo "Valor do orçamento" com "2000"
        And clico em "Atualizar orçamento" em controle financeiro
        Then devo ver em controle financeiro "Orçamento atualizado!"

    Scenario: Excluir um orçamento mensal
        Given que eu estou logado no sistema
        And existe um orçamento para o mês atual
        When eu acesso a página de controle financeiro
        And clico em "Excluir orçamento" em controle financeiro
        Then devo ver em controle financeiro "Orçamento excluído!"

    Scenario: Adicionar uma despesa
        Given que eu estou logado no sistema
        When eu acesso a página de controle financeiro
        And preencho o campo "Valor" com "500"
        And preencho o campo "Data" com "2025-08-11"
        And preencho o campo "Descrição" com "dinheiro não é problema que dinheiro a gente faz"
        And clico em "Adicionar" em controle financeiro
        Then devo ver em controle financeiro "Despesa adicionada!"

    Scenario: Excluir uma despesa
        Given que eu estou logado no sistema
        And existe uma despesa cadastrada
        When eu acesso a página de controle financeiro
        And clico em "Excluir despesa" em controle financeiro
        Then devo ver em controle financeiro "Despesa excluída!"
        
