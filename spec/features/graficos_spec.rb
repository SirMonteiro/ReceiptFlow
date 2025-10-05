require 'rails_helper'

RSpec.describe "Visualização de gráficos", type: :feature do
  # Cenário: Exibir gráfico de vendas mensais
  context "quando existem notas fiscais cadastradas" do
    before do
      create_list(:nota_grafico, 5, valor: 1000.0, data: Date.today)
      visit graficos_path
    end

    it "mostra o gráfico de vendas mensais" do
      expect(page).to have_css('#grafico_vendas_mensais')
    end
  end

  # Cenário: Exibir gráfico de despesas/ganhos
  context "quando existem notas e despesas cadastradas" do
    before do
      create_list(:nota_grafico, 5, valor: 1000.0, data: Date.today)
      create_list(:despesa, 3, valor: 500.0, data: Date.today)
      visit graficos_path
    end

    it "mostra o gráfico de despesas e ganhos" do
      expect(page).to have_css('#grafico_despesas_ganhos')
    end
  end

  # Cenário: Exibir gráfico de vendas/meta
  context "quando existe meta mensal" do
    before do
      create_list(:nota_grafico, 5, valor: 1000.0, data: Date.today.beginning_of_month)
      create(:meta_mensal, mes: Date.today.month, valor_meta: 6000.0)
      visit graficos_path
    end

    it "mostra gráfico de vendas/meta" do
      expect(page).to have_css('#grafico_vendas_meta')
    end
  end

  # Cenário: Nenhum dado cadastrado
  context "quando não há notas cadastradas" do
    before do
      NotaGrafico.delete_all
      visit graficos_path
    end

    it "exibe mensagem de nenhum dado disponível e não mostra gráficos" do
      expect(page).to have_content("Nenhum dado disponível para exibição")
      expect(page).not_to have_css('canvas')
    end
  end

  # Cenário: Não há valor meta
  context "quando não há meta estabelecida" do
    before do
      MetaMensal.delete_all
      create_list(:nota_grafico, 5, valor: 1000.0, data: Date.today)
      visit graficos_path
    end

    it "exibe mensagem de meta não estabelecida no gráfico de vendas/meta" do
      within('#grafico_vendas_meta') do
        expect(page).to have_content("Não há uma meta estabelecida")
      end
    end
  end
end
