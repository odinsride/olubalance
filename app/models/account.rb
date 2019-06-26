# frozen_string_literal: true

# An account which will store many transactions and belongs to one user
class Account < ApplicationRecord
  # Define Constants
  NO_ACCOUNT_DESC = "It looks like you don't have any accounts added. To add an account, \
                     click the add account button at the top of the page :)"

  NO_INACTIVE_DESC = 'You have no inactive accounts :)'

  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50, minimum: 2 }
  validates :starting_balance, presence: true
  validates :last_four, length: { maximum: 4 }

  after_create :create_initial_transaction

  def create_initial_transaction
    update(current_balance: 0.00)
    # rubocop:disable Metrics/LineLength
    Transaction.create(trx_type: 'credit', trx_date: Time.current, account_id: id, description: 'Starting Balance', amount: starting_balance)
    # rubocop:enable Metrics/LineLength
  end
end
