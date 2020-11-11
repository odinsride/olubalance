# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:name) { |n| 'Test Account #{n}' }
    starting_balance { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    last_four { 1234 }
    active { true }
    association :user
  end
end
