Feature: Exportação de dados para planilha
    Como dono da loja
    Eu quero exportar os dados para uma planilha
    Para que eu possa analisá-los de forma centralizada

    Scenario: Dono da loja exporta os dados existentes
        Given que existem pedidos cadastrados no sistema
        When eu acesso a página de exportação de dados
        And clico em "Exportar para Excel"
        Then devo receber um arquivo "dados.xlsx"
        And o arquivo deve conter os pedidos cadastrados

    Scenario: Dono da loja tenta exportar sem dados cadastrados
        Given que não existem pedidos cadastrados no sistema
        When eu acesso a página de exportação de dados
        And clico em "Exportar para Excel"
        Then devo receber um arquivo "dados.xlsx"
        And o arquivo deve conter apenas o cabeçalho sem pedidos

    Scenario: Usuário não autorizado tenta exportar
        Given que eu estou logado como cliente comum
        When eu acesso a página de exportação de dados
        Then devo ver a mensagem "Acesso negado"

    Scenario: Ocorre um erro inesperado durante a exportação
        Given que existe um pedido cadastrado no sistema
        And ocorre uma falha na geração da planilha
        When eu tento exportar os dados
        Then devo ver a mensagem "Erro ao gerar planilha. Tente novamente mais tarde."
        
    Scenario: Dono da loja tenta exportar em formato não suportado
        Given que existem pedidos cadastrados no sistema
        When eu tento exportar no formato "csv"
        Then devo ver um erro de formato não suportado