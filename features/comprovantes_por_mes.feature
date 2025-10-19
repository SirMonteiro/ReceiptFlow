# language: pt

Funcionalidade: Visualizar Comprovantes por Mês
  Como contador
  Para que eu possa contabilizar mais facilmente o fluxo de caixa e agilizar a contabilidade
  Eu quero poder acessar todos os comprovantes e separá-los por mês

  Contexto:
    Dado que existe um usuário com nome "João Contador", email "joao@contador.com" e senha "senha123"
    E que eu estou logado como "joao@contador.com" com senha "senha123"

  Cenário: Visualizar comprovantes de um mês específico
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-10-15 |
      | Cliente B  | 2500.00 | 2025-10-20 |
      | Cliente C  | 1000.00 | 2025-10-25 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Outubro" e ano "2025"
    Então eu devo ver "Comprovantes de Outubro de 2025"
    E eu devo ver "3 comprovante(s) encontrado(s)"
    E eu devo ver "Cliente A" na tabela
    E eu devo ver "Cliente B" na tabela
    E eu devo ver "Cliente C" na tabela
    E eu devo ver o total "R$ 5.000,00"

  Cenário: Visualizar mês sem comprovantes
    Dado que não existem DANFEs para março de 2025
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Março" e ano "2025"
    Então eu devo ver "Nenhum comprovante encontrado"
    E eu devo ver "Não há DANFEs registradas para Março de 2025"
    E eu devo ver "Por favor, selecione outro mês"
    E eu não devo ver uma tabela de comprovantes

  Cenário: Filtrar comprovantes por diferentes meses
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-01-15 |
      | Cliente B  | 2500.00 | 2025-02-20 |
      | Cliente C  | 1000.00 | 2025-01-25 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Janeiro" e ano "2025"
    Então eu devo ver "Cliente A" na tabela
    E eu devo ver "Cliente C" na tabela
    E eu não devo ver "Cliente B" na tabela
    E eu devo ver o total "R$ 2.500,00"

  Cenário: Alternar entre meses usando o seletor
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-01-15 |
      | Cliente B  | 2500.00 | 2025-02-20 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Janeiro" e ano "2025"
    Então eu devo ver "Cliente A" na tabela
    Quando eu seleciono o mês "Fevereiro" e ano "2025"
    Então eu devo ver "Cliente B" na tabela
    E eu não devo ver "Cliente A" na tabela

  Cenário: Visualizar detalhes da DANFE
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-10-15 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Outubro" e ano "2025"
    E eu clico em "Ver" para "Cliente A"
    Então eu devo ser redirecionado para a página de detalhes da DANFE

  Cenário: Visualizar comprovantes ordenados por data
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-10-05 |
      | Cliente B  | 2500.00 | 2025-10-25 |
      | Cliente C  | 1000.00 | 2025-10-15 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Outubro" e ano "2025"
    Então a primeira linha da tabela deve conter "Cliente B"
    E a segunda linha da tabela deve conter "Cliente C"
    E a terceira linha da tabela deve conter "Cliente A"

  Cenário: Visualizar comprovantes do mês atual por padrão
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2025-10-15 |
    E que hoje é "2025-10-19"
    Quando eu visito a página de comprovantes por mês
    Então eu devo ver "Comprovantes de Outubro de 2025"
    E o seletor de mês deve estar em "Outubro"
    E o campo de ano deve estar em "2025"

  Cenário: Visualizar dados completos na tabela
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | chave_acesso                                  | data_saida |
      | Cliente A  | 1500.00 | 12345678901234567890123456789012345678901234  | 2025-10-15 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Outubro" e ano "2025"
    Então eu devo ver "15/10/2025" na tabela
    E eu devo ver "12345678901234567890" na tabela
    E eu devo ver "Cliente A" na tabela
    E eu devo ver "R$ 1.500,00" na tabela

  Cenário: Navegação entre anos
    Dado que existem DANFEs cadastradas no sistema:
      | cliente    | valor   | data_saida |
      | Cliente A  | 1500.00 | 2024-12-15 |
      | Cliente B  | 2500.00 | 2025-01-15 |
    Quando eu visito a página de comprovantes por mês
    E eu seleciono o mês "Dezembro" e ano "2024"
    Então eu devo ver "Cliente A" na tabela
    E eu não devo ver "Cliente B" na tabela
    Quando eu seleciono o mês "Janeiro" e ano "2025"
    Então eu devo ver "Cliente B" na tabela
    E eu não devo ver "Cliente A" na tabela

  Cenário: Todos os meses em português no seletor
    Quando eu visito a página de comprovantes por mês
    Então o seletor de mês deve conter as opções:
      | Janeiro   |
      | Fevereiro |
      | Março     |
      | Abril     |
      | Maio      |
      | Junho     |
      | Julho     |
      | Agosto    |
      | Setembro  |
      | Outubro   |
      | Novembro  |
      | Dezembro  |
