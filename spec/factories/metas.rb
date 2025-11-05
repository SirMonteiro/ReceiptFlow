# frozen_string_literal: true

FactoryBot.define do
  factory :meta do
    mes { Time.zone.today.month }
    valor_meta { 6000.0 }
  end
end
