# A running balance which is contained in a DB view. Belongs to one transaction.
class TransactionBalance < ApplicationRecord
  self.primary_key = 'transaction_id'

  belongs_to :user_transaction, class_name: 'Transaction'
end
