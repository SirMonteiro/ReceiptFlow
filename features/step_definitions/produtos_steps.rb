# frozen_string_literal: true

Given('que não existem danfes cadastradas no sistema para produtos') do
  Danfe.destroy_all
  user = User.create!(
    nome: 'Teste Vazio',
    email: 'teste@vazio.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )
  fazer_login(user)
end

def criar_danfe(user, chave_acesso, descricao, valor, ncm, data_saida, cliente_nome = 'Cliente Teste')
  Danfe.create!(
    user: user,
    chave_acesso: chave_acesso,
    natureza_operacao: 'Venda',
    remetente: 'Tech Store LTDA - CNPJ: 12.345.678/0001-95 - Rua Tech, 100',
    destinatario: "#{cliente_nome} - CNPJ: 98.765.432/0001-95 - Rua Cliente, 200",
    cliente: cliente_nome,
    descricao_produtos: descricao,
    valores_totais: valor,
    valor: valor,
    impostos: { icms: (valor * 0.18).round(2), ipi: (valor * 0.05).round(2) }.to_json,
    cfop: '5102',
    cst: '060',
    ncm: ncm,
    transportadora: 'TransTech LTDA - CNPJ: 11.222.333/0001-44',
    data_saida: data_saida
  )
end

def fazer_login(user)
  visit '/login'
  fill_in 'email', with: user.email
  fill_in 'password', with: 'senha123'
  click_button 'Entrar'
end

# Scenario: Visualizar produtos mais vendidos
Given('que existem danfes com diferentes produtos cadastradas') do
  user = User.create!(
    nome: 'Teste Produtos',
    email: 'teste@produtos.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  # Produto A - Notebook (mais vendido)
  criar_danfe(user, '11111111111111111111111111111111111111111111', 'Notebook Dell Inspiron', 3500.00, '84713012', Date.new(2025, 3, 15), 'Cliente A')
  criar_danfe(user, '22222222222222222222222222222222222222222222', 'Notebook Dell Inspiron', 3500.00, '84713012', Date.new(2025, 3, 18), 'Cliente B')

  # Produto B - Mouse (valor médio)
  criar_danfe(user, '33333333333333333333333333333333333333333333', 'Mouse Logitech MX Master', 450.00, '84716060', Date.new(2025, 3, 20), 'Cliente C')

  # Produto C - Teclado (menor valor)
  criar_danfe(user, '44444444444444444444444444444444444444444444', 'Teclado Mecânico Keychron', 350.00, '84716070', Date.new(2025, 4, 5), 'Cliente D')

  fazer_login(user)
end

# Scenario: Visualizar produtos agrupados por NCM
Given('que existem danfes com produtos de mesmo NCM') do
  user = User.create!(
    nome: 'Teste NCM',
    email: 'teste@ncm.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  criar_danfe(user, '55555555555555555555555555555555555555555555', 'Notebook Dell XPS', 5000.00, '84713012', Date.new(2025, 5, 1), 'Cliente E')
  criar_danfe(user, '66666666666666666666666666666666666666666666', 'Notebook Lenovo ThinkPad', 4500.00, '84713012', Date.new(2025, 5, 5), 'Cliente F')

  criar_danfe(user, '77777777777777777777777777777777777777777777', 'Mouse Gamer', 350.00, '84716060', Date.new(2025, 5, 10), 'Cliente G')
  criar_danfe(user, '88888888888888888888888888888888888888888888', 'Mousepad Grande', 150.00, '84716060', Date.new(2025, 5, 12), 'Cliente H')

  fazer_login(user)
end

Given('que existem danfes com produtos em diferentes períodos') do
  user = User.create!(
    nome: 'Teste Período',
    email: 'teste@periodo.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  criar_danfe(user, '11111111111111111111111111111111111111111111', 'Monitor LG 27"', 1800.00, '85285210', Date.new(2025, 1, 15), 'Cliente A')
  criar_danfe(user, '22222222222222222222222222222222222222222222', 'Monitor Samsung 24"', 1200.00, '85285210', Date.new(2025, 2, 10), 'Cliente B')

  criar_danfe(user, '33333333333333333333333333333333333333333333', 'Webcam Logitech', 600.00, '85258020', Date.new(2025, 4, 5), 'Cliente C')
  criar_danfe(user, '44444444444444444444444444444444444444444444', 'Headset HyperX', 450.00, '85182200', Date.new(2025, 5, 20), 'Cliente D')

  criar_danfe(user, '55555555555555555555555555555555555555555555', 'SSD Kingston 1TB', 700.00, '84717050', Date.new(2025, 7, 10), 'Cliente E')

  criar_danfe(user, '10101010101010101010101010101010101010101010', 'SSD Samsung 1TB', 800.00, '84717050', Date.new(2025, 11, 10), 'Cliente J')

  fazer_login(user)
end

# Scenario: Exportar estatísticas de produtos
Given('que existem danfes com produtos cadastradas') do
  user = User.create!(
    nome: 'Teste Export',
    email: 'teste@export.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  criar_danfe(user, '33333333333333333333333333333333333333333333', 'Mouse Logitech', 150.00, '84716060', Date.new(2025, 4, 20), 'Cliente Export')

  fazer_login(user)
end

When('eu acesso a página de estatísticas de produtos') do
  visit produtos_path
end

When('eu seleciono a visualização de produtos {string}') do |visualizacao|
  select visualizacao, from: 'visualizacao'
  click_button 'Filtrar'
end

When('eu seleciono o período de produtos de {string} a {string}') do |data_inicio, data_fim|
  fill_in 'data_inicio', with: data_inicio
  fill_in 'data_fim', with: data_fim
  click_button 'Filtrar'
end

When('eu clico no link {string}') do |nome_link|
  click_link nome_link
end

Then('eu devo ver a lista de produtos ordenados por valor total') do
  produtos = page.all('tbody tr')
  expect(produtos.count).to be > 0

  expect(produtos.first).to have_content('Notebook Dell Inspiron')
  expect(produtos.first).to have_content('7.000,00')
end

Then('eu devo ver o valor total de cada produto') do
  expect(page).to have_content('Total')
  expect(page).to have_content('R$')
end

Then('eu devo ver a quantidade de vendas de cada produto') do
  expect(page).to have_content('Quantidade')
end

Then('eu devo ver os produtos agrupados por código NCM') do
  expect(page).to have_content('84713012') 
  expect(page).to have_content('84716060') 
end

Then('eu devo ver o valor total por NCM') do
  expect(page).to have_content('Total')
  expect(page).to have_content('R$')
end

Then('eu devo ver apenas produtos vendidos nesse período') do
  expect(page).to have_content('Monitor')
  expect(page).to have_content('Webcam')
  expect(page).to have_content('Headset')

  expect(page).not_to have_content('SSD Kingston')
end

Then('eu devo fazer download do arquivo {string}') do |nome_arquivo|
  expect(page.response_headers['Content-Disposition']).to include(nome_arquivo)
end

Then('o arquivo deve conter os dados de produtos') do
  csv_content = page.body
  expect(csv_content).to include('Produto')
  expect(csv_content).to include('NCM')
  expect(csv_content).to include('Quantidade')
  expect(csv_content).to include('Total')
end
