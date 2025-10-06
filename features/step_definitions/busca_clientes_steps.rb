# features/step_definitions/busca_clientes_steps.rb

Given("que existem clientes cadastrados no sistema") do
  @clientes = [
    FactoryBot.create(:cliente, codigo: "CLI001", descricao: "Restaurante Bom Sabor"),
    FactoryBot.create(:cliente, codigo: "CLI002", descricao: "Padaria Central"),
    FactoryBot.create(:cliente, codigo: "CLI003", descricao: "Supermercado Grande Rede"),
    FactoryBot.create(:cliente, codigo: "CLI004", descricao: "Bar e Lanchonete do João"),
    FactoryBot.create(:cliente, codigo: "CLI005", descricao: "Restaurante Fino Paladar")
  ]
end

Given("que existem clientes com diferentes descrições cadastrados") do
  @cliente_restaurante = FactoryBot.create(:cliente, codigo: "CLI001", descricao: "Restaurante Bom Sabor")
  @cliente_padaria = FactoryBot.create(:cliente, codigo: "CLI002", descricao: "Padaria Central")
  @cliente_supermercado = FactoryBot.create(:cliente, codigo: "CLI003", descricao: "Supermercado Grande Rede")
end

Given("que não existem clientes cadastrados no sistema") do
  Cliente.delete_all
end

When("eu acesso a página de busca de clientes") do
  visit busca_path
end

When("eu busco por {string}") do |termo_busca|
  fill_in 'query', with: termo_busca
  click_button 'Pesquisar'
end

When("eu realizo uma busca sem preencher o campo") do
  visit busca_path
  click_button 'Pesquisar'
end

Then("devo ver {int} resultado(s)") do |quantidade|
  expect(page).to have_content("Foram encontrados #{quantidade} resultado")
end

Then("devo ver o cliente {string}") do |descricao|
  expect(page).to have_content(descricao)
end

Then("não devo ver o cliente {string}") do |descricao|
  expect(page).not_to have_content(descricao)
end

Then("devo ver todos os clientes do tipo {string}") do |tipo|
  clientes_filtrados = @clientes.select { |c| c.descricao.downcase.include?(tipo.downcase) }
  clientes_filtrados.each do |cliente|
    expect(page).to have_content(cliente.descricao)
  end
end

Then("deve exibir o texto {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("não devo ver resultados de busca") do
  expect(page).to have_content("Nenhum resultado encontrado")
end

Then("devo ver o campo de busca vazio") do
  expect(find_field('query').value).to be_blank
end

Then("devo ver o termo {string} no campo de busca") do |termo|
  expect(find_field('query').value).to eq(termo)
end

Then("os resultados devem conter o texto {string} na descrição") do |texto|
  within('.search-results') do
    all('.result-item').each do |item|
      expect(item.text.downcase).to include(texto.downcase)
    end
  end
end
