# Passos para dados existentes
Given("que existem pedidos em diferentes meses") do
  # Cria pedidos em Janeiro/2025
  Pedido.create!(
    cliente: "Cliente A",
    valor: 500.75,
    chave_acesso: "12345678901234567890123456789012345678901234",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente A Corp", cnpj: "11111111000111", endereco: "Av B, 456" },
    descricao_produtos: [{ nome: "Produto 1", quantidade: 5, valor_unitario: 100.15 }],
    valores_totais: 500.75,
    impostos: { icms: 90.0, ipi: 25.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Time.new(2025, 1, 15)
  )

  # Cria pedidos em Fevereiro/2025
  Pedido.create!(
    cliente: "Cliente B",
    valor: 750.25,
    chave_acesso: "09876543210987654321098765432109876543210987",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente B Ltda", cnpj: "22222222000122", endereco: "Rua C, 789" },
    descricao_produtos: [{ nome: "Produto 2", quantidade: 3, valor_unitario: 250.08 }],
    valores_totais: 750.25,
    impostos: { icms: 135.0, ipi: 37.5 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Time.new(2025, 2, 10)
  )

  # Cria pedidos em Março/2025
  Pedido.create!(
    cliente: "Cliente C",
    valor: 1250.50,
    chave_acesso: "13579246801357924680135792468013579246801357",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente C S.A.", cnpj: "33333333000133", endereco: "Av D, 1010" },
    descricao_produtos: [{ nome: "Produto 3", quantidade: 10, valor_unitario: 125.05 }],
    valores_totais: 1250.50,
    impostos: { icms: 225.0, ipi: 62.5 },
    cfop: "5102",
    cst: "060",
    ncm: "23456789",
    transportadora: { razao_social: "Transportadora Y", cnpj: "33445566000177" },
    data_saida: Time.new(2025, 3, 5)
  )
end

Given("que existem pedidos de diferentes clientes") do
  step "que existem pedidos em diferentes meses"
end

Given("que existem pedidos em diferentes períodos") do
  step "que existem pedidos em diferentes meses"
  
  # Adicionar pedido em Junho/2025
  Pedido.create!(
    cliente: "Cliente D",
    valor: 875.30,
    chave_acesso: "24681357924681357924681357924681357924681357",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente D ME", cnpj: "44444444000144", endereco: "Rua E, 222" },
    descricao_produtos: [{ nome: "Produto 4", quantidade: 7, valor_unitario: 125.04 }],
    valores_totais: 875.30,
    impostos: { icms: 157.5, ipi: 43.8 },
    cfop: "5102",
    cst: "060",
    ncm: "34567890",
    transportadora: { razao_social: "Transportadora X", cnpj: "44556677000188" },
    data_saida: Time.new(2025, 6, 20)
  )
  
  # Adicionar pedido em Julho/2025
  Pedido.create!(
    cliente: "Cliente E",
    valor: 1500.00,
    chave_acesso: "35791357913579135791357913579135791357913579",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente E EIRELI", cnpj: "55555555000155", endereco: "Av F, 333" },
    descricao_produtos: [{ nome: "Produto 5", quantidade: 15, valor_unitario: 100.00 }],
    valores_totais: 1500.00,
    impostos: { icms: 270.0, ipi: 75.0 },
    cfop: "5102",
    cst: "060",
    ncm: "45678901",
    transportadora: { razao_social: "Transportadora V", cnpj: "55667788000199" },
    data_saida: Time.new(2025, 7, 15)
  )
end

# Passos para navegação
When("eu acesso a página de faturamento") do
  visit faturamento_path
end

When("eu seleciono a visualização {string}") do |visualizacao|
  select visualizacao, from: 'visualizacao'
end

When("eu seleciono o período de {string} a {string}") do |data_inicio, data_fim|
  fill_in 'data_inicio', with: data_inicio
  fill_in 'data_fim', with: data_fim
  click_button 'Filtrar'
end

When("eu clico em {string}") do |botao|
  click_button botao
end

Then("eu devo ver o faturamento total agrupado por mês") do
  expect(page).to have_content("Faturamento por Mês")
  expect(page).to have_content("Janeiro/2025")
  expect(page).to have_content("Fevereiro/2025")
  expect(page).to have_content("Março/2025")
  
  expect(page).to have_content("R$ 500,75") # Janeiro
  expect(page).to have_content("R$ 750,25") # Fevereiro
  expect(page).to have_content("R$ 1.250,50") # Março
end

Then("eu devo ver o faturamento total agrupado por cliente") do
  expect(page).to have_content("Faturamento por Cliente")
  expect(page).to have_content("Cliente A")
  expect(page).to have_content("Cliente B")
  expect(page).to have_content("Cliente C")
  
  expect(page).to have_content("R$ 500,75") # Cliente A
  expect(page).to have_content("R$ 750,25") # Cliente B
  expect(page).to have_content("R$ 1.250,50") # Cliente C
end

Then("eu devo ver apenas o faturamento desse período") do
  expect(page).to have_content("Faturamento: 01/01/2025 a 31/03/2025")
  expect(page).to have_content("Total: R$ 2.501,50") # soma dos três primeiros meses
  
  # Não deve mostrar os meses fora do período
  expect(page).not_to have_content("Junho/2025")
  expect(page).not_to have_content("Julho/2025")
end

Then("eu devo receber um arquivo {string}") do |nome_arquivo|
  expect(page.response_headers['Content-Disposition']).to be_present
  expect(page.response_headers['Content-Disposition'].downcase).to include(nome_arquivo.downcase)
end

Then("o arquivo deve conter os dados de faturamento") do
  expect(page.body).to include("Período")
  expect(page.body).to include("Cliente")
  expect(page.body).to include("Valor")
  
  # Verifica a presença de dados específicos
  expect(page.body).to include("Cliente A")
  expect(page.body).to include("500,75")
  expect(page.body).to include("Cliente B")
  expect(page.body).to include("750,25")
end

Then("eu devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end