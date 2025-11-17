# frozen_string_literal: true

Given('que existem DANFEs cadastradas no sistema:') do |table|
  @user ||= User.find_by(email: 'joao@contador.com') || create(:user, email: 'joao@contador.com')

  @danfes = []
  table.hashes.each do |row|
    danfe = Danfe.create!(
      user: @user,
      cliente: row['cliente'],
      valor: row['valor'].to_f,
      chave_acesso: row['chave_acesso'] || '12345678901234567890123456789012345678901234',
      natureza_operacao: 'Venda',
      remetente: { razao_social: 'Empresa Remetente LTDA', cnpj: '12345678000195', endereco: 'Rua A, 123' },
      destinatario: { razao_social: "#{row['cliente']} LTDA", cnpj: '98765432000195', endereco: 'Rua B, 456' },
      descricao_produtos: [{ nome: 'Produto 1', quantidade: 1, valor_unitario: row['valor'].to_f }],
      valores_totais: row['valor'].to_f,
      impostos: { icms: 18.0, ipi: 5.0 },
      cfop: '5102',
      cst: '060',
      ncm: '12345678',
      transportadora: { razao_social: 'Transportadora XYZ', cnpj: '11222333000144' },
      data_saida: Date.parse(row['data_saida'])
    )
    @danfes << danfe
  end
end

Given('que não existem DANFEs para março de {int}') do |ano|
  # Ensure no DANFEs exist for March of the given year
  Danfe.where('EXTRACT(MONTH FROM data_saida) = ? AND EXTRACT(YEAR FROM data_saida) = ?', 3, ano).destroy_all
end

Given('que hoje é {string}') do |data|
  travel_to Date.parse(data)
end

Quando('eu visito a página de comprovantes por mês') do
  visit month_receipts_path
end

Quando('eu seleciono o mês {string} e ano {string}') do |mes, ano|
  meses_map = {
    'Janeiro' => 1, 'Fevereiro' => 2, 'Março' => 3, 'Abril' => 4,
    'Maio' => 5, 'Junho' => 6, 'Julho' => 7, 'Agosto' => 8,
    'Setembro' => 9, 'Outubro' => 10, 'Novembro' => 11, 'Dezembro' => 12
  }

  month_num = meses_map[mes]
  select mes, from: 'month'
  fill_in 'year', with: ano

  # The form should auto-submit, but let's ensure it
  visit month_receipts_path(month: month_num, year: ano)
end

Então('eu devo ver {string}') do |texto|
  expect(page).to have_content(texto)
end

Então('eu devo ver {string} na tabela') do |texto|
  within('table') do
    expect(page).to have_content(texto)
  end
end

Então('eu não devo ver {string} na tabela') do |texto|
  within('table') do
    expect(page).not_to have_content(texto)
  end
end

Então('eu devo ver o total {string}') do |valor|
  within('tfoot') do
    expect(page).to have_content(valor)
  end
end

Então('eu não devo ver uma tabela de comprovantes') do
  expect(page).not_to have_selector('table tbody tr')
end

Quando('eu clico em {string} para {string}') do |botao, cliente|
  within('tr', text: cliente) do
    click_link botao
  end
end

Então('eu devo ser redirecionado para a página de detalhes da DANFE') do
  expect(current_path).to match(%r{/danfes/\d+})
end

Então('a primeira linha da tabela deve conter {string}') do |texto|
  within('table tbody tr:first-child') do
    expect(page).to have_content(texto)
  end
end

Então('a segunda linha da tabela deve conter {string}') do |texto|
  within('table tbody tr:nth-child(2)') do
    expect(page).to have_content(texto)
  end
end

Então('a terceira linha da tabela deve conter {string}') do |texto|
  within('table tbody tr:nth-child(3)') do
    expect(page).to have_content(texto)
  end
end

Então('o seletor de mês deve estar em {string}') do |mes|
  expect(page).to have_select('month', selected: mes)
end

Então('o campo de ano deve estar em {string}') do |ano|
  expect(page).to have_field('year', with: ano)
end

Então('o seletor de mês deve conter as opções:') do |table|
  table.raw.flatten.each do |mes|
    expect(page).to have_select('month', with_options: [mes])
  end
end

Given('que eu estou logado como {string} com senha {string}') do |email, senha|
  visit new_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: senha
  click_button 'Entrar'
end
