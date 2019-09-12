# frozen_string_literal: true

# An account which will store many transactions and belongs to one user
class Account < ApplicationRecord
  # Define Constants
  NO_ACCOUNT_DESC = "It looks like you don't have any accounts added. To add an account, \
                     click the add account button at the top of the page :)"

  NO_INACTIVE_DESC = 'You have no inactive accounts :)'

  DISPLAY_NAME_LIMIT = 24

  belongs_to :user
  has_many :transactions, dependent: :delete_all

  validates :name, presence: true,
                   length: { maximum: 50, minimum: 2 },
                   uniqueness: { scope: :user_id }

  validates :starting_balance, presence: true
  validates :last_four, length: { minimum: 4, maximum: 4 },
                        allow_blank: true

  before_create :set_current_balance
  after_create :create_initial_transaction

  private

  def set_current_balance
    self.current_balance = starting_balance
  end

  def create_initial_transaction
    Transaction.skip_callback(:create, :after, :update_account_balance_create)
    init_trx = Transaction.new
    init_trx.trx_type = 'credit'
    init_trx.trx_date = Time.current
    init_trx.account_id = id
    init_trx.description = 'Starting Balance'
    init_trx.amount = starting_balance
    init_trx.save
    Transaction.set_callback(:create, :after, :update_account_balance_create)
  end
end
