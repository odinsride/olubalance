class Transaction < ApplicationRecord
	belongs_to :account
	has_one :transaction_balance

	#has_attached_file :attachment, styles: { large: "1000x1000>", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	#validates_attachment_content_type :attachment, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']

	has_attached_file :attachment,
	    # In order to determine the styles of the image we want to save
	    # e.g. a small style copy of the image, plus a large style copy
	    # of the image, call the check_file_type method
	    styles: { large: ["1000x1000>", :png], medium: ["300x300>", :png], thumb: ["100x100>", :png] }

	# Validate that we accept the type of file the user is uploading
	# by explicitly listing the mimetypes we are willing to accept
	validates_attachment_content_type :attachment,
		content_type: [
		  "image/jpg", 
		  "image/jpeg", 
		  "image/png", 
		  "image/gif",
		  "application/pdf",

		  "file/txt",
		  "text/plain",

		  "application/doc",
		  "application/msword", 

		  "application/vnd.ms-excel",     
		  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
		  ],
		message: "Sorry! We do not accept the attached file type"

	# Link running_balance to view
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

	scope :with_balance, -> { includes(:transaction_balance).references(:transaction_balance) }
	scope :desc, -> { order('trx_date DESC, id DESC') }

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
