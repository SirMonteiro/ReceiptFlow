Given("que existem pedidos cadastrados no sistema") do
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
    chave_acesso: "98765432109876543210987654321098765432109876",
    natureza_operacao: "Venda",
    remetente: { razao_social: "Empresa X", cnpj: "12345678000195", endereco: "Rua A, 123" },
    destinatario: { razao_social: "Cliente Z", cnpj: "98765432000195", endereco: "Rua C, 789" },
    descricao_produtos: [{ nome: "Produto 2", quantidade: 5, valor_unitario: 50.00 }],
    valores_totais: 250.00,
    impostos: { icms: 45.0, ipi: 12.5 },
    cfop: "5102",
    cst: "060",
    ncm: "87654321",
    transportadora: { razao_social: "Transportadora W", cnpj: "22334455000166" },
    data_saida: Time.now
  )
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
  expect(page.body).to include("Chave de Acesso")
  expect(page.body).to include("Natureza da Operação")
  expect(page.body).to include("Remetente - Razão Social")
  expect(page.body).to include("Remetente - CNPJ")
  expect(page.body).to include("Remetente - Endereço")
  expect(page.body).to include("Destinatário - Razão Social")
  expect(page.body).to include("Destinatário - CNPJ")
  expect(page.body).to include("Destinatário - Endereço")
  expect(page.body).to include("Descrição dos Produtos")
  expect(page.body).to include("Valores Totais")
  expect(page.body).to include("Impostos - ICMS")
  expect(page.body).to include("Impostos - IPI")
  expect(page.body).to include("CFOP")
  expect(page.body).to include("CST")
  expect(page.body).to include("NCM")
  expect(page.body).to include("Transportadora - Razão Social")
  expect(page.body).to include("Transportadora - CNPJ")
  expect(page.body).to include("Data de Saída")

  expect(page.body).to include("12345678901234567890123456789012345678901234")
  expect(page.body).to include("Venda")
  expect(page.body).to include("Empresa X")
  expect(page.body).to include("12345678000195")
  expect(page.body).to include("Rua A, 123")
  expect(page.body).to include("Cliente Y")
  expect(page.body).to include("98765432000195")
  expect(page.body).to include("Rua B, 456")
  expect(page.body).to include("Produto 1")
  expect(page.body).to include("100.5")
  expect(page.body).to include("18.0")
  expect(page.body).to include("5.0")
  expect(page.body).to include("5102")
  expect(page.body).to include("060")
  expect(page.body).to include("12345678")
  expect(page.body).to include("Transportadora Z")
  expect(page.body).to include("11222333000144")

  expect(page.body).to include("98765432109876543210987654321098765432109876")
  expect(page.body).to include("Cliente Z")
  expect(page.body).to include("Rua C, 789")
  expect(page.body).to include("Produto 2")
  expect(page.body).to include("250.0")
  expect(page.body).to include("45.0")
  expect(page.body).to include("12.5")
  expect(page.body).to include("87654321")
  expect(page.body).to include("Transportadora W")
  expect(page.body).to include("22334455000166")
end

Given("que não existem pedidos cadastrados no sistema") do
  Pedido.delete_all
end

Then("o arquivo deve conter apenas o cabeçalho sem pedidos") do
  expect(page.body).to include("Chave de Acesso")
  expect(page.body).to include("Natureza da Operação")
  expect(page.body).to include("Remetente")
  expect(page.body).to include("Destinatário")
  expect(page.body).to include("Descrição dos Produtos")
  expect(page.body).to include("Valores Totais")
  expect(page.body).to include("Impostos")
  expect(page.body).to include("CFOP")
  expect(page.body).to include("CST")
  expect(page.body).to include("NCM")
  expect(page.body).to include("Transportadora")
  expect(page.body).to include("Data de Saída")

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