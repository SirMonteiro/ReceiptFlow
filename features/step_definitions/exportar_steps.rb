Given("que existem pedidos cadastrados no sistema") do
    @pedido1 = Pedido.create!(cliente: "Usuarilson", valor: 100.50)
    @pedido2 = Pedido.create!(cliente: "André Jun Hirata", valor: 250.00)
end

When("eu acesso a página de exportação de dados") do
  visit root_path
end

When("clico em {string}") do |botao|
    click_link botao
end

Then("devo receber um arquivo {string}") do |nome_arquivo|
  expect(page.response_headers['Content-Disposition']).to include(nome_arquivo)
end

Then("o arquivo deve conter os pedidos cadastrados") do
    expect(page.body).to include("Usuarilson")
    expect(page.body).to include("André Jun Hirata")
end

Given("que não existem pedidos cadastrados no sistema") do
  Pedido.delete_all
end

Then("o arquivo deve conter apenas o cabeçalho sem pedidos") do
    expect(page.body).to include("Cliente")
    expect(page.body).to include("Valor")
    expect(page.body).not_to match(/Usuarilson|André Jun Hirata/)
end

Given("que eu estou logado como cliente comum") do
  user = User.create!(email: "cliente@teste.com", password: "123456", role: "cliente")
  login_as(user, scope: :user) # Usar o método login_as para simular login com Warden
end

Then("devo ver a mensagem {string}") do |mensagem|
    expect(page).to have_content(mensagem)
end

Given("ocorre uma falha na geração da planilha") do
  allow(Pedido).to receive(:all).and_raise(StandardError.new("Falha"))
end

Then("devo ver um erro de formato não suportado") do
  expect(page.status_code).to eq(406)
end

When("eu tento exportar no formato {string}") do |formato|
    visit exportar_exportacoes_path(format: formato)
end

Given("que existe um pedido cadastrado no sistema") do
  FactoryBot.create(:pedido, cliente: "Cliente Teste", valor: 100.0)
end

When("eu tento exportar os dados") do
  visit exportar_exportacoes_path(format: 'csv')
end