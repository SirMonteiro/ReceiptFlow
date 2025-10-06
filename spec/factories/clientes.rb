FactoryBot.define do
  factory :cliente do
    codigo { Faker::Number.number(digits: 10) }
    descricao { Faker::Lorem.paragraph }

    trait :blue do
      codigo { "#{Faker::Number.number(digits: 10)}" }
      descricao { "20 Araras Azuis" }
    end

    trait :red do
      codigo { "#{Faker::Number.number(digits: 10)}" }
      descricao { "20 Flamingos Vermelhos" }
    end
  end
end
