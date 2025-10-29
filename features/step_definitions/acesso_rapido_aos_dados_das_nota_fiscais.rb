Given("que eu estou autenticado") do
  user = User.create!(nome: "Gerente", email: "gerente@exemplo.com", password: "senha123")
  visit new_session_path
  fill_in "E-mail", with: user.email
  fill_in "Senha", with: "senha123"
  click_button "Entrar"
end

Given("existem as seguintes notas fiscais:") do |table|
  table.hashes.each do |row|
    Danfe.create!(
      user_id: User.first.id,
      cliente: row["cliente"],
      valor: row["valor"],
      chave_acesso: row["chave_acesso"],
      natureza_operacao: row["natureza_operacao"],
      remetente: row["remetente"],
      destinatario: row["destinatario"],
      descricao_produtos: row["descricao_produtos"],
      valores_totais: row["valores_totais"],
      impostos: row["impostos"],
      cfop: row["cfop"],
      cst: row["cst"],
      ncm: row["ncm"],
      transportadora: row["transportadora"],
      data_saida: row["data_saida"]
    )
  end
end

When("eu clico em notas fiscais na home page") do
  click_link "DANFEs"
end

When(
  /^eu filtro as notas fiscais pelo período de "([^"]+)" até "([^"]+)"$/
) do |data_inicial, data_final|
  fill_in "Data inicial", with: data_inicial
  fill_in "Data final", with: data_final
  click_button "Filtrar"
end

Then(/^eu devo ver todos os dados da(?:s)? nota(?:s)? fiscal(?:is)? listada(?:s)?:$/) do |table|
  table.hashes.each do |row|
    row.each_value do |valor|
      expect(page).to have_content(valor)
    end
  end
end

Then("eu não devo ver nenhuma nota fiscal listada") do
  expect(page).to have_content("Nenhuma nota fiscal encontrada")
end

Then("eu devo ver uma mensagem de erro indicando que a data é inválida") do |table|
  expect(page).to have_content(table.rows_hash["mensagem_erro"])
end

Then("eu devo ver uma mensagem de erro indicando que a data inicial é posterior à data final") do |table|
  expect(page).to have_content(table.rows_hash["mensagem_erro"])
end
