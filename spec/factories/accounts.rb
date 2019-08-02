# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'PNC Bank Account' }
    starting_balance { 1000 }
    last_four { 1234 }
    active { true }
  end
end
