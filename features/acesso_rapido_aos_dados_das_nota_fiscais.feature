Feature: Acesso rápido aos dados das notas fiscais
  Como gerente
  De forma que eu possa declarar mais facilmente o imposto devido
  Eu quero ter acesso a todos os dados das notas fiscais de um período

  Scenario: Gerente acessa todos os dados das notas fiscais de um período específico
    Given que eu estou autenticado
    And existem as seguintes notas fiscais:
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      | Cliente Teste Ltda  | 1520.75  | 35250512345678000123550010000012341000012345 | Venda de Mercadoria | Loja Exemplo   | Cliente Teste Ltda | Produto A - 2x, Produto B - 3x | 1520.75        | 230.12   | 5102 | 060 | 84713012 | TransFácil     | 2025-10-05  |
      | Beta Comércio       | 820.30   | 35250512345678000123550010000012341000054321 | Venda de Serviço    | Loja Exemplo   | Beta Comércio      | Serviço de instalação           | 820.30         | 123.04   | 5101 | 050 | 99999999 | EntregExpress  | 2025-10-10  |
    When eu clico em notas fiscais na home page
    And eu filtro as notas fiscais pelo período de "2025-10-01" até "2025-10-31"
    Then eu devo ver todos os dados das notas fiscais listadas:
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      | Cliente Teste Ltda  | 1520.75  | 35250512345678000123550010000012341000012345 | Venda de Mercadoria | Loja Exemplo   | Cliente Teste Ltda | Produto A - 2x, Produto B - 3x | 1520.75        | 230.12   | 5102 | 060 | 84713012 | TransFácil     | 2025-10-05  |
      | Beta Comércio       | 820.30   | 35250512345678000123550010000012341000054321 | Venda de Serviço    | Loja Exemplo   | Beta Comércio      | Serviço de instalação           | 820.30         | 123.04   | 5101 | 050 | 99999999 | EntregExpress  | 2025-10-10  |
Scenario: Gerente tenta acessar notas fiscais de um período que não tem notas fiscais e não vê resultados
    Given que eu estou autenticado
    And existem as seguintes notas fiscais:
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      | Cliente Teste Ltda  | 1520.75  | 35250512345678000123550010000012341000012345 | Venda de Mercadoria | Loja Exemplo   | Cliente Teste Ltda | Produto A - 2x, Produto B - 3x | 1520.75        | 230.12   | 5102 | 060 | 84713012 | TransFácil     | 2025-10-05  |
    When eu clico em notas fiscais na home page
    And eu filtro as notas fiscais pelo período de "2025-11-01" até "2025-11-30"
    Then eu não devo ver nenhuma nota fiscal listada
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      |                     |          |                                     |                      |                |                     |                                |                |          |       |     |          |                 |              |
    
Scenario: Gerente acessa notas fiscais de um unico dia
    Given que eu estou autenticado
    And existem as seguintes notas fiscais:
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      | Cliente Teste Ltda  | 1520.75  | 35250512345678000123550010000012341000012345 | Venda de Mercadoria | Loja Exemplo   | Cliente Teste Ltda | Produto A - 2x, Produto B - 3x | 1520.75        | 230.12   | 5102 | 060 | 84713012 | TransFácil     | 2025-10-05  |
        | Beta Comércio       | 820.30   | 35250512345678000123550010000012341000054321 | Venda de Serviço    | Loja Exemplo   | Beta Comércio      | Serviço de instalação           | 820.30         | 123.04   | 5101 | 050 | 99999999 | EntregExpress  | 2025-10-10  |
    When eu clico em notas fiscais na home page
    And eu filtro as notas fiscais pelo período de "2025-10-05" até "2025-10-05"
    Then eu devo ver todos os dados da nota fiscal listada:
      | cliente             | valor    | chave_acesso                         | natureza_operacao    | remetente      | destinatario       | descricao_produtos              | valores_totais | impostos | cfop  | cst | ncm      | transportadora | data_saida  |
      | Cliente Teste Ltda  | 1520.75  | 35250512345678000123550010000012341000012345 | Venda de Mercadoria | Loja Exemplo   | Cliente Teste Ltda | Produto A - 2x, Produto B - 3x | 1520.75        | 230.12   | 5102 | 060 | 84713012 | TransFácil     | 2025-10-05  |
    
Scenario: Gerente filtra notas fiscais com data de saída inválida e vê mensagem de erro
    Given que eu estou autenticado
    When eu clico em notas fiscais na home page
    And eu filtro as notas fiscais pelo período de "2025-13-01" até "2025-10-31"
    Then eu devo ver uma mensagem de erro indicando que a data é inválida
      | mensagem_erro                          |
      | Data de saída inválida. Por favor, insira uma data válida no formato AAAA-MM-DD. |
    
Scenario: Gerente filtra notas fiscais com data inicial posterior à data final e vê mensagem de erro
    Given que eu estou autenticado
    When eu clico em notas fiscais na home page
    And eu filtro as notas fiscais pelo período de "2025-11-01" até "2025-10-31"
    Then eu devo ver uma mensagem de erro indicando que a data inicial é posterior à data final
      | mensagem_erro                                      |
      | A data inicial não pode ser posterior à data final. Por favor, corrija as datas. |
    
