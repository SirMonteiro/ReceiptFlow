# frozen_string_literal: true

require 'action_view'
require 'date'
World(ActionView::Helpers::NumberHelper, ActionView::Helpers::DateHelper)

Given("que eu estou autenticado") do
  # Use @user (variável de instância) em vez de user (local)
  @user = User.create!(nome: "Gerente", email: "gerente@exemplo.com", password: "senha123")
  
  visit new_session_path
  fill_in "E-mail", with: @user.email  # Use @user aqui também
  fill_in "Senha", with: "senha123"
  click_button "Entrar"

  # Adicione uma verificação para garantir que o login funcionou
  expect(page).to have_content("Bem-vindo, #{@user.nome}")
end

Given('existem as seguintes notas fiscais:') do |table|
  table.hashes.each do |row|
    Danfe.create!(
      user_id: User.first.id,
      cliente: row['cliente'],
      valor: row['valor'].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      chave_acesso: row['chave_acesso'],
      natureza_operacao: row['natureza_operacao'],
      remetente: row['remetente'],
      destinatario: row['destinatario'],
      descricao_produtos: row['descricao_produtos'],
      valores_totais: row['valores_totais'].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      impostos: row['impostos'].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      cfop: row['cfop'],
      cst: row['cst'],
      ncm: row['ncm'],
      transportadora: row['transportadora'],
      data_saida: Date.strptime(row['data_saida'], '%d/%m/%Y')
    )
  end
end

When('eu clico em notas fiscais na home page') do
  click_link 'DANFEs por período'
end

When(/^eu filtro as notas fiscais pelo período de "([^"]+)" até "([^"]+)"$/) do |data_inicial, data_final|
  fill_in 'data_inicial', with: data_inicial
  fill_in 'data_final', with: data_final
  click_button 'Filtrar'
end

Then(/^eu devo ver todos os dados das notas fiscais listadas:$/) do |table|
  table.hashes.each do |expected|
    expect(page).to have_content(expected['chave_acesso'])
  end
end

Then('eu devo ver todos os dados da nota fiscal listada:') do |table|
  step 'eu devo ver todos os dados das notas fiscais listadas:', table
end

Then('eu não devo ver nenhuma nota fiscal listada') do
  expect(page).to have_content('Nenhum resultado encontrado')
end
