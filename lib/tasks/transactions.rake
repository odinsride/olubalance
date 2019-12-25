# frozen_string_literal: true

namespace :transactions do
  desc 'Sets the locked flag to true for all Starting Balance transactions'
  task lock_starting_balance: :environment do
    Transaction.where(description: 'Starting Balance').each do |t|
      t.update_attribute :locked, true
    end
  end
end
