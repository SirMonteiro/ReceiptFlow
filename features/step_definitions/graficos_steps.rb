
Given("existe o valor meta 800") do
  MetaMensal.create!(
    user: @user,
    valor_meta: 800,
    mes: Date.today.month,
    ano: Date.today.year
  )
end

Given("que não existe valor meta") do
end

When("eu acesso a página de gráficos") do
  visit graficos_path
end

Then("devo visualizar o gráfico de Vendas X Despesas X Orçamento") do
  expect(page).to have_css('#grafico_vendas_despesas_orcamento_div')
end

Then("devo visualizar o gráfico de Metas X Vendas") do
  expect(page).to have_css('#grafico_vendas_metas_div')
end


Then("devo visualizar o gráfico de pizza de Meta X Vendas") do
  expect(page).to have_css('#grafico_pizza_meta')
end

Then("devo visualizar um gráfico de pizza com o valor total arrecadado no mês e o valor meta") do
  expect(page).to have_css('#grafico_vendas_meta')
end

Then("devo ver a mensagem {string} no gráfico de vendas meta") do |mensagem|
  expect(page).to have_content(mensagem)
end

