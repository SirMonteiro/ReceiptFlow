FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    nome { "Usuário Teste" }
    password { "senha123" }
  end
end
