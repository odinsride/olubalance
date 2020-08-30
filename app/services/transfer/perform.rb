# frozen_string_literal: true

# Transfer money between accounts by creating a
# debit transaction in the originating account,
# and a credit transaction in the target acccount
class PerformTransfer
  def self.call(source_account, target_account, amount)
    source_transaction = Transaction.new
    source_transaction.trx_type = 'debit'
    source_transaction.trx_date = Time.current
    source_transaction.account_id = source_account.id
    source_transaction.description = 'Transfer to ' + target_account.name
    source_transaction.amount = amount.abs
    source_transaction.locked = true
    source_transaction.transfer = true
    source_transaction.save

    target_transaction = Transaction.new
    target_transaction.trx_type = 'credit'
    target_transaction.trx_date = Time.current
    target_transaction.account_id = target_account.id
    target_transaction.description = 'Transfer from ' + source_account.name
    target_transaction.amount = amount.abs
    target_transaction.locked = true
    target_transaction.transfer = true
    target_transaction.save
  end
end
