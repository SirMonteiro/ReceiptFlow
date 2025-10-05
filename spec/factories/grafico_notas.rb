FactoryBot.define do
  factory :nota_grafico do
    valor { 1000.0 }
    emitida_em { Date.today }
  end
end
