Feature: Classificação de Notas Fiscais por Tipo de Operação
  Como gerente de loja
  Para organizar as notas fiscais
  Eu quero visualizar e filtrar DANFEs por tipo de operação

  Background:
    Given que eu estou autenticado
    And existem as seguintes notas fiscais para o usuário atual:
      | cliente           | valor     | chave_acesso | natureza_operacao | remetente    | destinatario      | descricao_produtos | valores_totais | impostos  | cfop | cst | ncm      | transportadora | data_saida |
      | Cliente Venda A   | R$ 100,00 | VDA-001      | Venda             | Loja Exemplo | Cliente Venda A   | Produto Venda A    | R$ 100,00      | R$ 10,00  | 5102 | 000 | 12345678 | TransA         | 01/11/2025 |
      | Cliente Venda B   | R$ 200,00 | VDA-002      | Venda             | Loja Exemplo | Cliente Venda B   | Produto Venda B    | R$ 200,00      | R$ 20,00  | 5102 | 000 | 12345678 | TransA         | 02/11/2025 |
      | Cliente Devolução | R$ 50,00  | DEV-001      | Devolução         | Loja Exemplo | Cliente Devolução | Produto Devolução  | R$ 50,00       | R$ 5,00   | 1202 | 000 | 12345678 | TransB         | 03/11/2025 |
    And existe uma nota fiscal para outro usuário:
      | cliente           | valor     | chave_acesso | natureza_operacao | remetente    | destinatario      | descricao_produtos | valores_totais | impostos  | cfop | cst | ncm      | transportadora | data_saida |
      | Cliente Outro     | R$ 999,00 | OUTRO-001    | Venda             | Outra Loja   | Cliente Outro     | Produto Outro      | R$ 999,00      | R$ 99,00  | 5102 | 000 | 87654321 | TransC         | 04/11/2025 |
    When eu clico em "Classificação por Tipo de Operação" na home page

  Scenario: Visualizar todas as operações ao carregar a página
    Then eu devo ver o título "Classificação de Notas por Tipo de Operação"
    And eu devo ver a nota com chave "VDA-001" na tabela
    And eu devo ver a nota com chave "VDA-002" na tabela
    And eu devo ver a nota com chave "DEV-001" na tabela
    But eu não devo ver a nota com chave "OUTRO-001" na página

  Scenario: Filtrar por um tipo de operação específico
    When eu seleciono "Venda" no campo "operacao"
    And eu clico em "Filtrar"
    Then eu devo ver a nota com chave "VDA-001" na tabela
    And eu devo ver a nota com chave "VDA-002" na tabela
    But eu não devo ver a nota com chave "DEV-001" na tabela

  Scenario: Filtrar por um tipo de operação sem resultados
    When eu seleciono "Serviço" no campo "operacao"
    And eu clico em "Filtrar"
    Then eu não devo ver a nota com chave "VDA-001" na tabela
    And eu não devo ver a nota com chave "DEV-001" na tabela
    And eu devo ver a mensagem "Nenhuma nota encontrada para esse filtro."

  Scenario: Filtrar e depois selecionar "Todas"
    Given que eu filtrei por "Venda"
    When eu seleciono "Todas" no campo "operacao"
    And eu clico em "Filtrar"
    Then eu devo ver a nota com chave "VDA-001" na tabela
    And eu devo ver a nota com chave "VDA-002" na tabela
    And eu devo ver a nota com chave "DEV-001" na tabela