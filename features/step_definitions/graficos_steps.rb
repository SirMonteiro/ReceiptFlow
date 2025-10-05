Given("que existem notas fiscais cadastradas no sistema") do
  # DANFE são notas fiscais, aqui criamos objetos fake
  @notas = FactoryBot.create_list(:grafico_nota, 5, valor: 1000.0, emitida_em: Date.today)
end

Given("que existem notas fiscais e despesas cadastradas no sistema") do
  @notas = FactoryBot.create_list(:grafico_nota,, 5, valor: 1000.0, emitida_em: Date.today)
  @despesas = FactoryBot.create_list(:despesa, 3, valor: 500.0, data: Date.today)
end

Given("que existem notas fiscais cadastradas em certo mês no sistema e o valor meta mensal") do
  @notas = FactoryBot.create_list(:grafico_nota,, 5, valor: 1000.0, emitida_em: Date.today.beginning_of_month)
  @meta = FactoryBot.create(:meta, mes: Date.today.month, valor_meta: 6000.0)
end

Given("que não existem notas cadastradas no sistema") do
  NotaFiscal.delete_all
end

Given("que não existe valor meta") do
  Meta.delete_all
  FactoryBot.create_list(:grafico_nota,, 5, valor: 1000.0, emitida_em: Date.today)
end

When("eu acesso a página de gráficos") do
  visit graficos_path
end

Then("devo visualizar um gráfico de barras mostrando o total de vendas por mês") do
  expect(page).to have_css('#grafico_vendas_mensais')
end


Then("devo visualizar um gráfico de barras com os valores de despesas e ganhos por mês") do
  expect(page).to have_css('#grafico_despesas_ganhos')
end

Then("devo visualizar um gráfico de pizza com o valor total arrecadado no mês e o valor meta") do
  expect(page).to have_css('#grafico_vendas_meta')
end

Then("devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("não devo ver gráficos") do
  expect(page).not_to have_css('canvas') # ou ids dos gráficos
end

Then("devo ver a mensagem {string} no gráfico de vendas/meta") do |mensagem|
  within('#grafico_vendas_meta') do
    expect(page).to have_content(mensagem)
  end
end
