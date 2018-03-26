class Transaction < ApplicationRecord
	belongs_to :account
	attr_accessor :trx_type

	#default_scope { order('trx_date, id DESC') }
	validates_presence_of :trx_type, :message => "Please select debit or credit"
	validates :trx_date, presence: true
	validates :description, presence: true, length: { maximum: 150 }
	validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :memo, length: { maximum: 500 }

	before_save :convert_amount, :set_running_balance
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
		

=begin
		@account = Account.find(account_id)
		if new_record?
			self.running_balance = @account.current_balance + self.amount
		else
			self.running_balance = @account.current_balance - self.amount_was + self.amount
		end
=end

	def set_running_balance
		previous_balance = previous_transaction_for_user.try(:running_balance) || 0
		self.running_balance = previous_balance + amount
	end

	def previous_transaction_for_user
		scope = Transaction.where(account: account).order(:id)
		scope = scope.where('id < ?', id) if persisted?

		scope.last
	end

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
