Given("que existem pedidos cadastrados no sistema") do
  @user = User.find_or_create_by!(email: "teste@teste.com") do |user| 
    user.nome = "Usuarilson" 
    user.password = "123456" 
  end 
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

  @danfes = [
    Danfe.create!(
      number: 1,
      user: @user, cliente: "Usuarilson",
      valor: 100.50,
      chave_acesso: "12345678901234567890123456789012345678901234",
      natureza_operacao: "Venda",
      remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
      destinatario: { razao_social: "Cliente Y", cnpj: "98765432000195", endereco: "Rua B, 456" },
      descricao_produtos: [{ nome: "Produto 1", quantidade: 2, valor_unitario: 50.25 }],
      valores_totais: 100.50,
      impostos: { icms: 18.0, ipi: 5.0 },
      cfop: "5102",
      cst: "060",
      ncm: "12345678",
      transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
      data_saida: Time.now)
  ]

  Pedido.create!(
    cliente: "Usuarilson",
    valor: 100.50,
    chave_acesso: "12345678901234567890123456789012345678901234",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente Y", cnpj: "98765432000195", endereco: "Rua B, 456" },
    descricao_produtos: [{ nome: "Produto 1", quantidade: 2, valor_unitario: 50.25 }],
    valores_totais: 100.50,
    impostos: { icms: 18.0, ipi: 5.0 },
    cfop: "5102",
    cst: "060",
    ncm: "12345678",
    transportadora: { razao_social: "Transportadora Z", cnpj: "11222333000144" },
    data_saida: Time.now
  )

  Pedido.create!(
    cliente: "André Jun Hirata",
    valor: 250.00,
    chave_acesso: '98765432109876543210987654321098765432109876',
    natureza_operacao: 'Venda',
    remetente: { razao_social: 'Empresa X', cnpj: '12345678000195', endereco: 'Rua A, 123' }.to_json,
    destinatario: { razao_social: 'Cliente Z', cnpj: '98765432000195', endereco: 'Rua C, 789' }.to_json,
    descricao_produtos: [{ nome: 'Produto 2', quantidade: 5, valor_unitario: 50.00 }].to_json,
    valores_totais: 250.00,
    impostos: { icms: 45.0, ipi: 12.5 }.to_json,
    cfop: '5102',
    cst: '060',
    ncm: '87654321',
    transportadora: { razao_social: 'Transportadora W', cnpj: '22334455000166' }.to_json,
    data_saida: Time.zone.now
  )
end

When('eu acesso a página de exportação de dados') do
  visit exportacoes_path
  puts "Current page URL: #{current_url}"
end

When('clico em {string}') do |_botao|
  visit exportar_exportacoes_path(format: 'csv')
end

Then('devo receber um arquivo {string}') do |nome_arquivo|
  puts "Response headers: #{page.response_headers}"
  expect(page.response_headers['Content-Disposition']).to be_present
  expect(page.response_headers['Content-Disposition'].downcase).to include(nome_arquivo.downcase)
end

Then('o arquivo deve conter as danfes cadastradas') do
  # Verifica se o arquivo contém os cabeçalhos esperados
  expect(page.body).to include('Chave de Acesso')
  expect(page.body).to include('Natureza da Operação')

  expect(page.body).to match(/1234567890/)

  expect(page.body).to include('Venda')

  expect(page.body).to include('Empresa X')
  expect(page.body).to include('12345678000195')

  expect(page.body).to include('Cliente')
  expect(page.body).to include('987654320')

  expect(page.body).to include('5102') # CFOP
  expect(page.body).to include('060')  # CST
  expect(page.body).to include('1234') # Parte do NCM

  expect(page.body).to include('Transportadora')
  expect(page.body).to include('Produto')

  puts "Conteúdo do CSV: #{page.body}"
end

Given("que não existem pedidos cadastrados no sistema") do
  @user = User.find_or_create_by!(email: "teste@teste.com") do |user| 
    user.nome = "Usuarilson" 
    user.password = "123456" 
  end 
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  Danfe.delete_all
end

Then('o arquivo deve conter apenas o cabeçalho sem danfes') do
  expect(page.body).to include('Chave de Acesso')
  expect(page.body).to include('Natureza da Operação')
  expect(page.body).to include('Remetente')
  expect(page.body).to include('Destinatário')
  expect(page.body).to include('Descrição dos Produtos')
  expect(page.body).to include('Valores Totais')
  expect(page.body).to include('Impostos')
  expect(page.body).to include('CFOP')
  expect(page.body).to include('CST')
  expect(page.body).to include('NCM')
  expect(page.body).to include('Transportadora')
  expect(page.body).to include('Data de Saída')

  expect(page.body).not_to match(/Usuarilson|André Jun Hirata/)
end

Given("que eu estou logado como cliente comum") do
  user = User.create!(email: "cliente@teste.com", password: "123456", role: "cliente")
  login_as(user, scope: :user)
end

Then('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Given('ocorre uma falha na geração da planilha') do
  allow(Danfe).to receive(:all).and_raise(StandardError.new('Falha'))
end

Then('devo ver um erro de formato não suportado') do
  expect(page.status_code).to eq(406)
end

When('eu tento exportar no formato {string}') do |formato|
  visit exportar_exportacoes_path(format: formato)
end

Given('que existe um pedido cadastrado no sistema') do
  @user = User.find_or_create_by!(email: 'teste@teste.com') do |user|
    user.nome = 'Usuarilson'
    user.password = '123456'
  end
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  FactoryBot.create(:danfe, user: @user, cliente: 'Cliente Teste', valor: 100.0)
end

When('eu tento exportar os dados') do
  visit exportar_exportacoes_path(format: 'csv')
end
