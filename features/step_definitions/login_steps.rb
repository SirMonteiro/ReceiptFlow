Given("que existe um usuário com nome {string}, email {string} e senha {string}") do |nome, email, senha|
  User.create!(nome: nome, email: email, password: senha, password_confirmation: senha)
end

When("eu acesso a página de login") do
  visit new_session_path
end

When("eu preencho o campo {string} com {string}") do |campo, valor|
  fill_in campo, with: valor
end

When("eu clico em {string}") do |botao|
  click_button botao
end

Then("devo ver {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("devo estar na página inicial") do
  expect(current_path).to eq(danfes_path)
end

Then("devo permanecer na página de login") do
  expect(current_path).to eq(sessions_path)
end
