# frozen_string_literal: true

Given('que estou na página de cadastro') do
  visit new_user_path
end

When('eu preencho {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

When('eu confirmo o cadastro') do
  click_button 'Cadastrar'
end

Then('devo ser redirecionado para a tela de login') do
  expect(page).to have_current_path(new_session_path)
  expect(page).to have_content('Login')
end
