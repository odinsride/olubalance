class TransactionBalance < ApplicationRecord
	self.primary_key = "transaction_id"

	belongs_to :user_transaction, class_name: "Transaction"
end
