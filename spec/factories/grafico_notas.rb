FactoryBot.define do
  factory :grafico_nota do
    valor { 1000.0 }
    emitida_em { Date.today }
  end
end