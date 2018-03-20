class Transaction < ApplicationRecord
	belongs_to :account
	after_create :update_account_balance_new
	after_update :update_account_balance_edit
	after_destroy :update_account_balance_destroy

	attr_accessor :trx_type

	before_save do
		puts "CALLING BEFORE_SAVE"
		if self.trx_type == "debit"
			puts "TRX_TYPE IS DEBIT"
			self.amount = self.amount * -1
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
end
