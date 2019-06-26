# frozen_string_literal: true

# A transaction record which belongs to one account. Can have one attached file
class Transaction < ApplicationRecord
  belongs_to :account
  has_one :transaction_balance, dependent: :destroy

  has_one_attached :attachment
  
  # has_attached_file :attachment,
  #                   # In order to determine the styles of the image we want to save
  #                   # e.g. a small style copy of the image, plus a large style copy
  #                   # of the image, call the check_file_type method
  #                   styles: { large: ['1000x1000>', :png], medium: ['300x300>', :png], thumb: ['100x100>', :png] }

  # # Validate that we accept the type of file the user is uploading
  # # by explicitly listing the mimetypes we are willing to accept
  # validates_attachment_content_type :attachment,
  #                                   content_type: [
  #                                     'image/jpg',
  #                                     'image/jpeg',
  #                                     'image/png',
  #                                     'image/gif',
  #                                     'application/pdf',

  #                                     'file/txt',
  #                                     'text/plain',

  #                                     'application/doc',
  #                                     'application/msword',

  #                                     'application/vnd.ms-excel',
  #                                     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  #                                   ],
  #                                   message: 'Sorry! We do not accept the attached file type'

  # Link running_balance to view
  delegate :running_balance, to: :transaction_balance

  attr_accessor :trx_type

  # default_scope { order('trx_date, id DESC') }
  validates :trx_type, presence: { message: 'Please select debit or credit' }
  validates :trx_date, presence: true
  validates :description, presence: true, length: { maximum: 150 }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :memo, length: { maximum: 500 }

  # before_post_process :rename_file

  before_save :convert_amount
  after_create :update_account_balance_new
  after_update :update_account_balance_edit
  after_destroy :update_account_balance_destroy

  scope :with_balance, -> { includes(:transaction_balance).references(:transaction_balance) }
  scope :desc, -> { order('trx_date DESC, id DESC') }

  # Determine the transaction_type for existing records based on amount
  def transaction_type
    # new_record? is checked first to prevent a nil class error
    return %w[Credit credit] if !new_record? && amount >= 0

    %w[Debit debit]
  end

  private

  def convert_amount
    self.amount = -amount.abs if trx_type == 'debit'
  end

  def update_account_balance_new
    @account = Account.find(account_id)
    @account.update(current_balance: @account.current_balance + amount)
  end

  def update_account_balance_edit
    @account = Account.find(account_id)
    @account.update(current_balance: @account.current_balance - amount_before_last_save + amount) \
      if saved_change_to_amount?
  end

  def update_account_balance_destroy
    @account = Account.find(account_id)
    # Rails 5.2 - amount_was is still valid in after_destroy callbacks
    @account.update(current_balance: @account.current_balance - amount_was)
  end

  # def rename_file
  #   extension = File.extname(attachment_file_name).downcase
  #   file_description = description.squish.tr(' ', '_')
  #   attachment.instance_write :file_name, "#{trx_date}_#{file_description}#{extension}"
  # end
end
