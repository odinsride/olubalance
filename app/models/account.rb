class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions, dependent: :destroy

	validates :name, presence: true, length: { maximum: 50, minimum: 2 }
	validates :starting_balance, presence: true
	validates :last_four, length: { maximum: 4 }
	
	#validates_associated :transactions

	after_create :create_initial_transaction

	def create_initial_transaction
		self.update_attributes(current_balance: 0.00)
		Transaction.create(trx_type: 'credit', trx_date: DateTime.now, account_id: self.id, description: "Starting Balance", amount: self.starting_balance)
		#self.update_attributes(current_balance: @initbalance)
	end

end
