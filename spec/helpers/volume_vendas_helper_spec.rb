require "rails_helper"

RSpec.describe VolumeVendasHelper, type: :helper do
  describe "#formatar_moeda_br" do
    it "formata valores positivos no padrão brasileiro" do
      expect(helper.formatar_moeda_br(1234.5)).to eq("R$ 1.234,50")
    end

    it "retorna R$ 0,00 quando o valor é nulo" do
      expect(helper.formatar_moeda_br(nil)).to eq("R$ 0,00")
    end
  end
end
