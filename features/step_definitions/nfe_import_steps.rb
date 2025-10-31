# Given steps
Given("I am on the NF-e Importer page") do
    visit notas_fiscais_path
  end
  
  # When steps
  When("I attach the file {string} to the {string} field") do |file_name, field|
    attach_file(field, Rails.root.join('spec/fixtures/files', file_name))
  end
  
  When("I press {string}") do |button_name|
    click_button(button_name)
  end
  
  # Then steps
  Then("I should see a success message {string}") do |message|
    expect(page).to have_content(message)
  end
  
  Then("I should see {string}") do |content|
    expect(page).to have_content(content)
  end
  
  Then("I should see {string} in the items table") do |content|
    within("table") do
      expect(page).to have_content(content)
    end
  end
  
  Then("the database should contain {int} NotaFiscal") do |count|
    expect(NotaFiscal.count).to eq(count)
  end
  
  Then("the database should contain {int} ItemNotas") do |count|
    expect(ItemNota.count).to eq(count)
  end