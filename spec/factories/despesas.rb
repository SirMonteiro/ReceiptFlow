FactoryBot.define do
  factory :despesa do
    valor { 500.0 }
    data { Date.today }
  end
end