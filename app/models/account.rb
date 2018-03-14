class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions, dependent: :destroy
	after_create :create_initial_transaction

	def create_initial_transaction
		@initbalance = self.current_balance
		Transaction.create(trx_date: DateTime.now, account_id: self.id, description: "Starting Balance", amount: self.current_balance)
		self.update_attributes(current_balance: @initbalance)
	end
end
