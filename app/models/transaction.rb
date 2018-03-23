class Transaction < ApplicationRecord
	belongs_to :account
	attr_accessor :trx_type

	validates_presence_of :trx_type, :message => "Please select debit or credit"
	validates :trx_date, presence: true
	validates :description, presence: true, length: { maximum: 150 }
	validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :memo, length: { maximum: 500 }

	after_create :update_account_balance_new
	after_update :update_account_balance_edit
	after_destroy :update_account_balance_destroy



	before_save do
		if self.trx_type == "debit"
			self.amount = -self.amount.abs
		end

		@account = Account.find(account_id)
		if new_record?
			self.running_balance = @account.current_balance + self.amount
		else
			self.running_balance = @account.current_balance - self.amount_was + self.amount
		end
	end

	def update_account_balance_new
		@account = Account.find(account_id)
		@account.update_attributes(current_balance: @account.current_balance + amount)
	end

	def update_account_balance_edit
		@account = Account.find(account_id)
		if saved_change_to_amount?
			@account.update_attributes(current_balance: @account.current_balance - amount_was + amount)
		end
	end

	def update_account_balance_destroy
		@account = Account.find(account_id)
		@account.update_attributes(current_balance: @account.current_balance - amount_was)
	end

	def transaction_type
		if !new_record?
			if self.amount >= 0
				return ['Credit', 'credit']
			else
				return ['Debit', 'debit']
			end
		else
			return ['Debit', 'debit']
		end
	end
end
