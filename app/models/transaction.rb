class Transaction < ApplicationRecord
	belongs_to :account
	has_one :transaction_balance

	delegate :running_balance, to: :transaction_balance
	
	attr_accessor :trx_type

	#default_scope { order('trx_date, id DESC') }
	validates_presence_of :trx_type, :message => "Please select debit or credit"
	validates :trx_date, presence: true
	validates :description, presence: true, length: { maximum: 150 }
	validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :memo, length: { maximum: 500 }

	before_save :convert_amount
	after_create :update_account_balance_new
	after_update :update_account_balance_edit
	after_destroy :update_account_balance_destroy

	scope :desc, -> { order('trx_date, id DESC') }

	# Determine the transaction_type for existing records based on amount
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

private
		
	def convert_amount
		if self.trx_type == "debit"
			self.amount = -self.amount.abs
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
