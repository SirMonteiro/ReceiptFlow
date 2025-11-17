Given("que existem danfes com impostos em diferentes meses") do
  @user = User.first || FactoryBot.create(:user) # Garante que o usuário exista
  Danfe.create!(
    number: 1, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Janeiro",
    valor: 1000.00,
    chave_acesso: '12345678901234567890123456789012345678901234',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Janeiro', cnpj: '98765432000195', endereco: 'Rua B, 456' },
    descricao_produtos: [{ nome: 'Produto 1', quantidade: 2, valor_unitario: 500.00 }],
    valores_totais: 1000.00,
    impostos: { icms: 180.0, ipi: 50.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Date.parse("15/01/2025"),
    user: @user # Garante que o usuário está associado
  )

  Danfe.create!(
    number: 2, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Fevereiro",
    valor: 1500.00,
    chave_acesso: '98765432109876543210987654321098765432109876',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Fevereiro', cnpj: '98765432000195', endereco: 'Rua C, 789' },
    descricao_produtos: [{ nome: 'Produto 2', quantidade: 3, valor_unitario: 500.00 }],
    valores_totais: 1500.00,
    impostos: { icms: 270.0, ipi: 75.0 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Date.parse("10/02/2025"),
    user: @user
  )

  Danfe.create!(
    number: 3, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Março",
    valor: 2000.00,
    chave_acesso: '11111111111111111111111111111111111111111111',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Março', cnpj: '98765432000195', endereco: 'Rua D, 101' },
    descricao_produtos: [{ nome: 'Produto 3', quantidade: 4, valor_unitario: 500.00 }],
    valores_totais: 2000.00,
    impostos: { icms: 360.0, ipi: 100.0 },
    cfop: "5102",
    cst: "060",
    ncm: "11223344",
    transportadora: { razao_social: "Transportadora Y", cnpj: "33445566000177" },
    data_saida: Date.parse("20/03/2025"),
    user: @user
  )
end

Given("que existem danfes de diferentes clientes com impostos") do
  @user = User.first || FactoryBot.create(:user)
  Danfe.create!(
    number: 4, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Empresa Alpha",
    valor: 5000.00,
    chave_acesso: '12345678901234567890123456789012345678901234',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Empresa Alpha', cnpj: '11111111000195', endereco: 'Av. Principal, 100' },
    descricao_produtos: [{ nome: 'Produto A', quantidade: 10, valor_unitario: 500.00 }],
    valores_totais: 5000.00,
    impostos: { icms: 900.0, ipi: 250.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Time.now,
    user: @user
  )

  Danfe.create!(
    number: 5, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Empresa Beta",
    valor: 3000.00,
    chave_acesso: '98765432109876543210987654321098765432109876',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Empresa Beta', cnpj: '22222222000195', endereco: 'Rua Secundária, 200' },
    descricao_produtos: [{ nome: 'Produto B', quantidade: 6, valor_unitario: 500.00 }],
    valores_totais: 3000.00,
    impostos: { icms: 540.0, ipi: 150.0 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Time.now,
    user: @user
  )

  Danfe.create!(
    number: 6, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Empresa Gamma",
    valor: 2000.00,
    chave_acesso: '11111111111111111111111111111111111111111111',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Empresa Gamma', cnpj: '33333333000195', endereco: 'Rua Terciária, 300' },
    descricao_produtos: [{ nome: 'Produto C', quantidade: 4, valor_unitario: 500.00 }],
    valores_totais: 2000.00,
    impostos: { icms: 360.0, ipi: 100.0 },
    cfop: "5102",
    cst: "060",
    ncm: "11223344",
    transportadora: { razao_social: "Transportadora Y", cnpj: "33445566000177" },
    data_saida: Time.now,
    user: @user
  )
end

Given("que existem danfes com impostos em diferentes períodos") do
  @user = User.first || FactoryBot.create(:user)
  Danfe.create!(
    number: 7, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Q1",
    valor: 1200.00,
    chave_acesso: '12345678901234567890123456789012345678901234',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Q1', cnpj: '98765432000195', endereco: 'Rua B, 456' },
    descricao_produtos: [{ nome: 'Produto Q1', quantidade: 2, valor_unitario: 600.00 }],
    valores_totais: 1200.00,
    impostos: { icms: 216.0, ipi: 60.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Date.parse("15/02/2025"),
    user: @user
  )

  Danfe.create!(
    number: 8, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Q2",
    valor: 1800.00,
    chave_acesso: '98765432109876543210987654321098765432109876',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Q2', cnpj: '98765432000195', endereco: 'Rua C, 789' },
    descricao_produtos: [{ nome: 'Produto Q2', quantidade: 3, valor_unitario: 600.00 }],
    valores_totais: 1800.00,
    impostos: { icms: 324.0, ipi: 90.0 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Date.parse("25/06/2025"),
    user: @user
  )
end

Given("que existem danfes cadastradas com impostos") do
  @user = User.first || FactoryBot.create(:user)
  Danfe.create!(
    number: 9, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Export",
    valor: 2500.00,
    chave_acesso: '12345678901234567890123456789012345678901234',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Export', cnpj: '98765432000195', endereco: 'Rua B, 456' },
    descricao_produtos: [{ nome: 'Produto Export', quantidade: 5, valor_unitario: 500.00 }],
    valores_totais: 2500.00,
    impostos: { icms: 450.0, ipi: 125.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Time.now,
    user: @user
  )
end

Given("que existem danfes com valores e impostos") do
  @user = User.first || FactoryBot.create(:user)
  Danfe.create!(
    number: 10, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Margem A",
    valor: 10000.00,
    chave_acesso: "12345678901234567890123456789012345678901234",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente Margem A", cnpj: "98765432000195", endereco: "Rua B, 456" },
    descricao_produtos: [{ nome: "Produto Margem", quantidade: 20, valor_unitario: 500.00 }],
    valores_totais: 10000.00,
    impostos: { icms: 1800.0, ipi: 500.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Time.now,
    user: @user
  )

  Danfe.create!(
    number: 11, # <-- CORREÇÃO: Adicionado 'number'
    cliente: "Cliente Margem B",
    valor: 8000.00,
    chave_acesso: '98765432109876543210987654321098765432109876',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' },
    destinatario: { razao_social: 'Cliente Margem B', cnpj: '98765432000195', endereco: 'Rua C, 789' },
    descricao_produtos: [{ nome: 'Produto Margem 2', quantidade: 16, valor_unitario: 500.00 }],
    valores_totais: 8000.00,
    impostos: { icms: 1440.0, ipi: 400.0 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Time.now,
    user: @user
  )
end

Given('que não existem danfes cadastradas no sistema') do
  Danfe.destroy_all
end

When('eu acesso a página de cálculo de impostos') do
  visit impostos_path
end

When('eu seleciono a visualização de impostos {string}') do |visualizacao|
  select visualizacao, from: 'visualizacao'
  click_button 'Filtrar' if visualizacao != 'Por Mês'
end

When('eu seleciono o período para impostos de {string} a {string}') do |data_inicio, data_fim|
  fill_in 'data_inicio', with: Date.strptime(data_inicio, '%d/%m/%Y').strftime('%Y-%m-%d')
  fill_in 'data_fim', with: Date.strptime(data_fim, '%d/%m/%Y').strftime('%Y-%m-%d')
  click_button 'Filtrar'
end

When('eu clico no botão de impostos {string}') do |botao|
  if botao == 'Exportar Relatório de Impostos'
    click_link botao
  else
    click_button botao
  end
end

Then('eu devo ver o total de impostos agrupado por mês') do
  expect(page).to have_content('Impostos por Mês')
  expect(page).to have_content('Janeiro/2025')
  expect(page).to have_content('Fevereiro/2025')
  expect(page).to have_content('Março/2025')
end

Then('eu devo ver o percentual de impostos sobre as vendas') do
  expect(page).to have_content('%')
  expect(page).to have_content('Percentual de Impostos')
end

Then('eu devo ver a carga tributária de cada cliente') do
  expect(page).to have_content('Impostos por Cliente')
  expect(page).to have_content('Empresa Alpha')
  expect(page).to have_content('Empresa Beta')
  expect(page).to have_content('Empresa Gamma')
end

Then('eu devo ver o percentual de impostos sobre o faturamento por cliente') do
  expect(page).to have_content('% sobre Faturamento')
end

Then('eu devo ver apenas os impostos desse período') do
  expect(page).to have_content('Período: 01/01/2025 a 31/03/2025')
  expect(page).to have_content('Total')
end

Then('o total deve corresponder às danfes do período selecionado') do
  expect(page).to have_content('1.035,00')
end

Then('eu devo receber um arquivo de impostos {string}') do |nome_arquivo|
  expect(page.response_headers['Content-Type']).to eq('text/csv')
  expect(page.response_headers['Content-Disposition'].downcase).to include(nome_arquivo.downcase)
end

Then('o arquivo deve conter os dados detalhados de impostos por danfe') do
  expect(page.body).to include('Cliente')
  expect(page.body).to include('ICMS')
  expect(page.body).to include('IPI')
  expect(page.body).to include('Total Impostos')
end

Then('eu devo ver o valor total das vendas') do
  expect(page).to have_content('Total de Vendas')
  expect(page).to have_content('18.000,00')
end

Then('eu devo ver o valor total dos impostos') do
  expect(page).to have_content('Total de Impostos')
  expect(page).to have_content('4.140,00')
end

Then('eu devo ver a margem líquida \\(vendas - impostos)') do
  expect(page).to have_content('Margem Líquida')
  expect(page).to have_content('13.860,00')
end

Then('eu devo ver o percentual de margem líquida') do
  expect(page).to have_content('Margem Líquida (%)')
  expect(page).to have_content(/77[.,]00?%/)
end

Then('eu devo ver a mensagem de impostos {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end