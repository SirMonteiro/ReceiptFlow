Feature: Login de usuário
  Como um usuário cadastrado
  Quero realizar login com meu e-mail e senha
  Para acessar as funcionalidades restritas da plataforma com os dados da minha empresa

  Background:
    # Cenário inicial: o usuário precisa existir no sistema
    Given que existe um usuário com nome "João Silva", email "joao@example.com" e senha "senha123"

  Scenario: Login com sucesso
    When eu acesso a página de login
    And eu preencho o campo "E-mail" com "joao@example.com"
    And eu preencho o campo "Senha" com "senha123"
    And eu clico em "Entrar"
    Then devo estar na página inicial

  Scenario: Login com senha incorreta
    When eu acesso a página de login
    And eu preencho o campo "E-mail" com "joao@example.com"
    And eu preencho o campo "Senha" com "senha_errada"
    And eu clico em "Entrar"
    Then devo ver "Email ou senha inválidos"
    And devo permanecer na página de login

  Scenario: Login com usuário inexistente
    When eu acesso a página de login
    And eu preencho o campo "E-mail" com "inexistente@example.com"
    And eu preencho o campo "Senha" com "senha123"
    And eu clico em "Entrar"
    Then devo ver "Email ou senha inválidos"
    And devo permanecer na página de login
