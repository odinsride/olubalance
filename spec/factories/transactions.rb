# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    trx_date { Date.today }
    description { 'Test Transaction' }
    amount { 50 }
    trx_type { 'debit' }
    memo { 'Sample Memo' }
    association :account

    trait :credit_transaction do
      trx_type { 'credit' }
    end
  end
end
