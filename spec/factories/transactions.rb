# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    trx_date { Date.today }
    description { 'Transaction API Factory Test' }
    amount { 50 }
    trx_type { 'debit' }
    memo { 'Sample Memo' }
  end
end
