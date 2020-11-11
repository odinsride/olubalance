# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:name) { |n| 'Test Account #{n}' }
    starting_balance { 1000 }
    last_four { 1234 }
    active { true }
    association :user
  end
end
