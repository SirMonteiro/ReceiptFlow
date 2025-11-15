# Requerimentos e helpers do seu modelo
require 'action_view'
require 'date'
World(ActionView::Helpers::NumberHelper, ActionView::Helpers::DateHelper)

# --- SETUP (Given) ---
# Este step foi copiado do seu modelo, mas armazena o usuário em @user
# para que outros steps possam criar DANFEs para ele.

# Este step foi adaptado do seu modelo para usar @user.id
Given("existem as seguintes notas fiscais para o usuário atual:") do |table|
  table.hashes.each do |row|
    Danfe.create!(
      user_id: @user.id, # Usa o ID do usuário logado
      cliente: row["cliente"],
      valor: row["valor"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      chave_acesso: row["chave_acesso"],
      natureza_operacao: row["natureza_operacao"],
      remetente: row["remetente"],
      destinatario: row["destinatario"],
      descricao_produtos: row["descricao_produtos"],
      valores_totais: row["valores_totais"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      impostos: row["impostos"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      cfop: row["cfop"],
      cst: row["cst"],
      ncm: row["ncm"],
      transportadora: row["transportadora"],
      data_saida: Date.strptime(row["data_saida"], "%d/%m/%Y")
    )
  end
end

# Step novo para o teste de segurança (scoping)
Given("existe uma nota fiscal para outro usuário:") do |table|
  outro_usuario = User.create!(nome: "Outro Usuario", email: "outro@exemplo.com", password: "senha123")
  
  table.hashes.each do |row|
    Danfe.create!(
      user_id: outro_usuario.id, # Usa o ID do *outro* usuário
      cliente: row["cliente"],
      valor: row["valor"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      chave_acesso: row["chave_acesso"],
      natureza_operacao: row["natureza_operacao"],
      remetente: row["remetente"],
      destinatario: row["destinatario"],
      descricao_produtos: row["descricao_produtos"],
      valores_totais: row["valores_totais"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      impostos: row["impostos"].gsub(/[R$\s]/, '').tr(',', '.').to_f,
      cfop: row["cfop"],
      cst: row["cst"],
      ncm: row["ncm"],
      transportadora: row["transportadora"],
      data_saida: Date.strptime(row["data_saida"], "%d/%m/%Y")
    )
  end
end

Given("que eu filtrei por {string}") do |operacao|
  # O 'select_tag :operacao' na view gera um campo com id/name "operacao"
  select(operacao, from: "operacao")
  click_button "Filtrar"
end


# --- ACTIONS (When) ---

When('eu clico em {string} na home page') do |link_text|
  # Baseado no link_to da sua view home.html.erb
  click_link link_text
end

When('eu seleciono {string} no campo {string}') do |option, field_name|
  # 'field_name' será "operacao", que é o name/id do select_tag
  # Isto segue o seu modelo que usa o ID/name do campo (ex: "data_inicial")
  select(option, from: field_name)
end




# --- ASSERTIONS (Then) ---

Then('eu devo ver o título {string}') do |title|
  # Baseado no <h1> da sua view operacoes/index.html.erb
  expect(page).to have_css('h1', text: title)
end

Then('eu devo ver a nota com chave {string} na tabela') do |chave|
  # Verifica se a chave está presente dentro do <tbody> da tabela
  within('table tbody') do
    expect(page).to have_content(chave)
  end
end

Then('eu não devo ver a nota com chave {string} na tabela') do |chave|
  # Verifica se a chave NÃO está presente dentro do <tbody>
  within('table tbody') do
    expect(page).to_not have_content(chave)
  end
end

But('eu não devo ver a nota com chave {string} na página') do |chave|
  # 'But' é um sinônimo de 'Then'
  # Este step verifica a página inteira, garantindo o escopo do controller
  expect(page).to_not have_content(chave)
end

