class Transaction < ApplicationRecord
	belongs_to :account
	after_create :update_account_balance_new
	after_update :update_account_balance_edit
	after_destroy :update_account_balance_destroy

	attr_accessor :trx_type
	
	def update_account_balance_new
		@account = Account.find(account_id)
		@account.update_attributes(current_balance: @account.current_balance - amount)
	end

	def update_account_balance_edit
		@account = Account.find(account_id)
		if amount_changed?
			@account.update_attributes(current_balance: @account.current_balance + amount_was - amount)
		end
	end

	def update_account_balance_destroy
		@account = Account.find(account_id)
		@account.update_attributes(current_balance: @account.current_balance + amount_was)
	end
end
