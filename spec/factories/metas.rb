FactoryBot.define do
  factory :meta do
    mes { Date.today.month }
    valor_meta { 6000.0 }
  end
end