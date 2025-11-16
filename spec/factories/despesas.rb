# frozen_string_literal: true

FactoryBot.define do
  factory :despesa do
    valor { 500.0 }
    data { Time.zone.today }
  end
end
