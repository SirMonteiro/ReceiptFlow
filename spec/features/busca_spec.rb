# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Busca', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:arara_azul) { create(:cliente, descricao: 'Azuis') }
  let!(:flamingo_vermelho) { create(:cliente, descricao: 'Vermelhos') }

  describe 'pesquisando por notas' do
    it 'mostra o formulário de pesquisa' do
      visit busca_path

      expect(page).to have_content('Busca')
      expect(page).to have_field('query')
      expect(page).to have_button('Pesquisar')
    end

    it 'encontra notas por descricao' do
      visit busca_path

      fill_in 'query', with: 'Azuis'
      click_button 'Pesquisar'

      expect(page).to have_content('Resultados para "Azuis"')
      expect(page).to have_content(arara_azul.descricao)
      expect(page).not_to have_content(flamingo_vermelho.descricao)
    end

    it 'exibe a quantidade de resultados' do
      visit busca_path

      fill_in 'query', with: 'Vermelhos'
      click_button 'Pesquisar'

      expect(page).to have_content('Foram')
    end

    it 'não mostra nenhum resultado para pesquisa não existente' do
      visit busca_path

      fill_in 'query', with: 'nonexistent'
      click_button 'Pesquisar'

      expect(page).to have_content('Nenhum resultado encontrado.')
    end

    it 'lida com pesquisa vazia' do
      visit busca_path

      click_button 'Pesquisar'

      expect(page).not_to have_content('Resultados para')
      expect(page).not_to have_content(arara_azul.descricao)
    end
  end
end
