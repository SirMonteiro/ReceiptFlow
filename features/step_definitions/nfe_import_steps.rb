# features/step_definitions/nfe_import_steps.rb

# --- ESTE É O NOVO PASSO DE LOGIN ---
Given("I am logged in as a user") do
  # 1. Cria um usuário de teste
  @user = User.create!(
    nome: "Usuário de Teste",
    email: "teste@cucumber.com", # Email de teste
    password: "password123",
    password_confirmation: "password123"
  )

  # 2. Visita a página de login (dos seus 'routes.rb')
  visit '/login'

  # 3. Preenche os campos (do seu HTML de login)
  fill_in "E-mail", with: @user.email
  fill_in "Senha", with: "password123"

  # 4. Clica no botão (do seu HTML de login)
  click_button "Entrar"
  
  # 5. Verifica a mensagem de sucesso (do seu SessionsController)
  expect(page).to have_content("Login realizado com sucesso!")
end
# --- FIM DO NOVO PASSO ---


# --- SEUS PASSOS EXISTENTES ---
Given("I am on the NF-e Importer page") do
  visit notas_fiscais_path
end

When("I attach the file {string} to the {string} field") do |file_name, field|
  attach_file(field, Rails.root.join('spec/fixtures/files', file_name))
end

When("I press {string}") do |button_name|
  click_button(button_name)
end

Then("I should see a success message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see {string}") do |content|
  expect(page).to have_content(content)
end

Then("I should see {string} in the items table") do |content|
  within("table") do
    expect(page).to have_content(content)
  end
end

Then("the database should contain {int} NotaFiscal") do |count|
  expect(NotaFiscal.count).to eq(count)
end

Then("the database should contain {int} ItemNotas") do |count|
  expect(ItemNota.count).to eq(count)
end