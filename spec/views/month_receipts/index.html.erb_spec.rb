require 'rails_helper'

RSpec.describe "month_receipts/index", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:selected_month, Date.new(2025, 10, 1))
    assign(:mes_pt, "Outubro")
    assign(:ano, "2025")
    assign(:selected_month_num, 10)
    assign(:available_months, [Date.new(2025, 10, 1), Date.new(2025, 9, 1)])
  end

  context "when danfes exist" do
    let(:danfe1) do
      create(:danfe,
        user: user,
        data_saida: Date.new(2025, 10, 15),
        chave_acesso: "12345678901234567890123456789012345678901234",
        cliente: "Cliente A",
        valor: 1500.00
      )
    end

    let(:danfe2) do
      create(:danfe,
        user: user,
        data_saida: Date.new(2025, 10, 20),
        chave_acesso: "98765432109876543210987654321098765432109876",
        cliente: "Cliente B",
        valor: 2500.00
      )
    end

    before(:each) do
      assign(:danfes, [danfe2, danfe1])
    end

    it "renders the page title" do
      render
      expect(rendered).to match(/Comprovantes por Mês/i)
    end

    it "renders the month selector form" do
      render
      expect(rendered).to have_selector("form")
      expect(rendered).to have_selector("select[name='month']")
      expect(rendered).to have_selector("input[name='year']")
    end

    it "renders Portuguese month names in the dropdown" do
      render
      expect(rendered).to match(/Janeiro/)
      expect(rendered).to match(/Fevereiro/)
      expect(rendered).to match(/Março/)
      expect(rendered).to match(/Dezembro/)
    end

    it "pre-selects the current month in the dropdown" do
      render
      expect(rendered).to have_select('month', selected: 'Outubro')
    end

    it "displays the year input field with current value" do
      render
      expect(rendered).to have_field('year', with: '2025')
    end

    it "renders the table with danfes" do
      render
      expect(rendered).to have_selector("table")
      expect(rendered).to have_selector("thead")
      expect(rendered).to have_selector("tbody")
    end

    it "displays table headers" do
      render
      expect(rendered).to match(/Data Saída/)
      expect(rendered).to match(/Chave de Acesso/)
      expect(rendered).to match(/Cliente/)
      expect(rendered).to match(/Remetente/)
      expect(rendered).to match(/Destinatário/)
      expect(rendered).to match(/Valor/)
      expect(rendered).to match(/Ações/)
    end

    it "displays danfe data in the table" do
      render
      expect(rendered).to match(/Cliente A/)
      expect(rendered).to match(/Cliente B/)
      expect(rendered).to match(/15\/10\/2025/)
      expect(rendered).to match(/20\/10\/2025/)
    end

    it "displays danfe values formatted as currency" do
      render
      expect(rendered).to match(/R\$.*1\.500,00/)
      expect(rendered).to match(/R\$.*2\.500,00/)
    end

    it "displays the total value in the footer" do
      render
      expect(rendered).to match(/Total:/)
      expect(rendered).to match(/R\$.*4\.000,00/)
    end

    it "displays the count of comprovantes" do
      render
      expect(rendered).to match(/2 comprovante\(s\) encontrado\(s\)/)
    end

    it "displays the selected month and year in the header" do
      render
      expect(rendered).to match(/Comprovantes de Outubro de 2025/)
    end

    it "renders 'Ver' link for each danfe" do
      render
      expect(rendered).to have_link("Ver", count: 2)
    end

    it "truncates long chave_acesso" do
      render
      # The view should truncate to 20 characters
      expect(rendered).to match(/12345678901234567890/)
    end

    it "does not display the empty state warning" do
      render
      expect(rendered).not_to match(/Nenhum comprovante encontrado/)
    end
  end

  context "when no danfes exist" do
    before(:each) do
      assign(:danfes, [])
    end

    it "renders the month selector form" do
      render
      expect(rendered).to have_selector("form")
      expect(rendered).to have_selector("select[name='month']")
    end

    it "displays the empty state warning" do
      render
      expect(rendered).to match(/Nenhum comprovante encontrado/i)
    end

    it "displays the correct month in the warning message" do
      render
      expect(rendered).to match(/Outubro de 2025/)
    end

    it "displays a message to select another month" do
      render
      expect(rendered).to match(/Por favor, selecione outro mês/)
    end

    it "does not render the table" do
      render
      expect(rendered).not_to have_selector("table tbody tr")
    end

    it "displays the alert warning style" do
      render
      expect(rendered).to have_selector(".alert.alert-warning")
    end
  end

  context "form behavior" do
    before(:each) do
      assign(:danfes, [])
    end

    it "submits the form on month change" do
      render
      expect(rendered).to have_selector("select[onchange='this.form.submit()']")
    end

    it "submits the form on year change" do
      render
      expect(rendered).to have_selector("input[onchange='this.form.submit()']")
    end

    it "uses GET method for the form" do
      render
      expect(rendered).to have_selector("form[method='get']")
    end

    it "submits to month_receipts_path" do
      render
      expect(rendered).to have_selector("form[action='#{month_receipts_path}']")
    end
  end

  context "responsive design" do
    before(:each) do
      assign(:danfes, [])
    end

    it "uses Bootstrap grid classes" do
      render
      expect(rendered).to have_selector(".col-md-3")
      expect(rendered).to have_selector(".col-md-2")
    end

    it "uses table-responsive wrapper" do
      danfe = create(:danfe, user: user, data_saida: Date.new(2025, 10, 15))
      assign(:danfes, [danfe])

      render
      expect(rendered).to have_selector(".table-responsive")
    end

    it "uses Bootstrap table classes" do
      danfe = create(:danfe, user: user, data_saida: Date.new(2025, 10, 15))
      assign(:danfes, [danfe])

      render
      expect(rendered).to have_selector(".table.table-striped.table-hover")
    end
  end
end
