class TransactionBalance < ApplicationRecord
	self.primary_key = "transaction_id"

	#belongs_to :transaction
	belongs_to :user_transaction, foreign_key: "id", class_name: "Transaction"
end
