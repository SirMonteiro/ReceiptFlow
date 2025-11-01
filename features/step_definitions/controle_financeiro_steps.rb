Given("que eu estou logado no sistema") do
  @user = User.find_or_create_by!(email: "teste@teste.com") do |user|
    user.nome = "Usuarilson"
    user.password = "123456"
  end

  # visita a página de login e faz login "real"
  visit new_session_path
  fill_in "E-mail", with: @user.email
  fill_in "Senha", with: "123456"
  click_button "Entrar"  # ou o texto correto do botão
end

Given("não existe uma meta para o mês atual") do
end

Given("existe uma meta para o mês atual") do
  @meta = MetaMensal.create!(user: @user, mes: Date.today.month, ano: Date.today.year, valor_meta: 1000)
end

Given("não existe um orçamento para o mês atual") do
end

Given("existe um orçamento para o mês atual") do
  @orcamento = OrcamentoMensal.create!(user: @user, mes: Date.today.month, ano: Date.today.year, valor: 1000)
end

Given("existe uma despesa cadastrada") do
  @despesa = Despesa.create!(
    user: @user,
    valor: 500,
    data: Date.new(2025, 8, 11),
    descricao: "dinheiro não é problema que dinheiro a gente faz"
  )
end

When("eu acesso a página de controle financeiro") do
  visit controle_financeiro_path
end

When("preencho o campo {string} com {string}") do |campo, valor|
  fill_in campo, with: valor
end

When("clico em {string} em controle financeiro") do |texto|
  click_on texto
end

Then("devo ver em controle financeiro {string}") do |text|
  #puts page.body
  expect(page).to have_content(text)

end
