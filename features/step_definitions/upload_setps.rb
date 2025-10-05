# encoding: utf-8

Dado("que eu estou na página de novo upload") do
    visit new_upload_path
  end
  
  Quando("eu anexo um arquivo XML válido ao formulário") do
    # Ajuste "upload[xml_file]" se o nome do campo de arquivo no seu formulário for diferente.
    attach_file("upload[xml_file]", Rails.root.join('spec', 'fixtures', 'files', 'receipt.xml'))
  end
  
  Quando("eu pressiono {string}") do |texto_do_botao|
    click_button(texto_do_botao)
  end
  
  Então("eu devo estar na página inicial") do
    expect(current_path).to eq(root_path)
  end
  
  Então("eu devo estar na página de novo upload") do
    expect(current_path).to eq(new_upload_path)
  end
  
  Então("eu devo ver a mensagem de sucesso {string}") do |mensagem|
    expect(page).to have_css('.flash-notice', text: mensagem)
  end
  
  Então("eu devo ver a mensagem de alerta {string}") do |mensagem|
    expect(page).to have_css('.flash-alert', text: mensagem)
  end