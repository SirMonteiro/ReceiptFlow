Feature: Cadastro de usuário
  Como visitante da plataforma
  Quero me cadastrar informando meus dados
  Para ter acesso à plataforma

  Scenario: Cadastro realizado com sucesso
    Given que estou na página de cadastro
    When eu preencho "Nome" com "Matheus Costa"
    And eu preencho "Email" com "matheus@example.com"
    And eu preencho "Senha" com "senha1234"
    And eu preencho "Confirmação de Senha" com "senha1234"
    And eu confirmo o cadastro
    Then devo ser redirecionado para a tela de login
