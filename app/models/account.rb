class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions, dependent: :destroy
	after_create :create_initial_transaction

	def create_initial_transaction
		Transaction.create(trx_date: DateTime.now, account_id: self.id, description: "Starting Balance", amount: self.current_balance)
	end
end
