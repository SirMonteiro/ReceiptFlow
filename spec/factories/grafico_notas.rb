# frozen_string_literal: true

FactoryBot.define do
  factory :nota_grafico do
    valor { 1000.0 }
    data { Time.zone.today }
  end
end
