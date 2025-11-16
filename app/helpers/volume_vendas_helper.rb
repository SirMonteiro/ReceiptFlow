# frozen_string_literal: true

module VolumeVendasHelper
  def formatar_moeda_br(valor)
    number_to_currency(valor || 0, unit: 'R$ ', separator: ',', delimiter: '.', precision: 2)
  end
end
