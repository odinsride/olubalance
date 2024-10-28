# frozen_string_literal: true

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = FactoryBot.build(:account)
    @account_with_transactions = FactoryBot.create(:account)
  end

  test 'has a valid factory' do
    assert @account.valid?
  end

  test 'account creation sets the current balance to the starting balance' do
    assert_not_nil @account_with_transactions.current_balance
    assert_equal @account_with_transactions.current_balance, @account_with_transactions.starting_balance
  end

  test 'initial transaction is created' do
    assert_equal @account_with_transactions.transactions.first.account_id, @account_with_transactions.id
  end

  test 'initial transaction locked flag is set to true' do
    assert @account_with_transactions.transactions.first.locked
  end

  test 'returns the balance of pending transactions' do
    pending_amts = [20, 140, 500]
    total_pending = pending_amts.sum

    pending_amts.each do |amt|
      FactoryBot.create(:transaction, :credit_transaction, account: @account_with_transactions, amount: amt, pending: true)
    end

    assert_equal @account_with_transactions.pending_balance, total_pending
  end

  test 'returns the balance of non-pending transactions' do
    non_pending_amts = [120, 80, 900]
    total_non_pending = non_pending_amts.sum + @account_with_transactions.current_balance

    non_pending_amts.each do |amt|
      FactoryBot.create(:transaction, :credit_transaction, account: @account_with_transactions, amount: amt)
    end

    assert_equal @account_with_transactions.non_pending_balance, total_non_pending
  end

  test 'validates presence of name' do
    @account.name = nil
    refute @account.valid?
    assert_includes @account.errors[:name], "can't be blank"
  end

  test 'validates presence of starting balance' do
    @account.starting_balance = nil
    refute @account.valid?
    assert_includes @account.errors[:starting_balance], "can't be blank"
  end

  test 'allows valid starting balance' do
    @account.starting_balance = 150.51
    assert @account.valid?
  end

  test 'validates uniqueness of name scoped to user' do
    # Create a user with a unique email
    user1 = FactoryBot.create(:user, email: 'unique_user1@example.com')
    FactoryBot.create(:account, name: 'Test Account', user: user1)

    # Create a new account with the same name but for the same user
    @account.name = 'Test Account'
    @account.user = user1

    refute @account.valid?
    assert_includes @account.errors[:name], 'has already been taken'
  end

  test 'validates format of name' do
    @account.name = 'A'
    refute @account.valid?
    assert_includes @account.errors[:name], 'is too short (minimum is 2 characters)'
    
    @account.name = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    refute @account.valid?
    assert_includes @account.errors[:name], 'is too long (maximum is 50 characters)' 
  end

  test 'validates format of last four' do
    @account.last_four = '12'
    refute @account.valid?
    assert_includes @account.errors[:last_four], 'is too short (minimum is 4 characters)'

    @account.last_four = '12345'
    refute @account.valid?
    assert_includes @account.errors[:last_four], 'is too long (maximum is 4 characters)'
    
    @account.last_four = 'ASDF'
    refute @account.valid?
    assert_includes @account.errors[:last_four], 'Numbers only.'
    
    @account.last_four = '1234'
    assert @account.valid?
  end

  test 'validates enum for account type' do
    expected_account_types = %w[checking credit cash savings]
    actual_account_types = Account.account_types.keys
    assert_equal expected_account_types.sort, actual_account_types.sort
  end

  test 'validates interest rate for credit accounts' do
    credit_account = FactoryBot.build(:account, :credit)
    credit_account.interest_rate = nil
    refute credit_account.valid?
    assert_includes credit_account.errors[:interest_rate], "can't be blank"

    credit_account.interest_rate = -10.00
    refute credit_account.valid?
    assert_includes credit_account.errors[:interest_rate], 'must be greater than or equal to 0'
  end

  test 'validates credit limit for credit accounts' do
    credit_account = FactoryBot.build(:account, :credit)
    credit_account.credit_limit = nil
    refute credit_account.valid?
    assert_includes credit_account.errors[:credit_limit], "can't be blank"
    
    credit_account.credit_limit = -5000.00
    refute credit_account.valid?
    assert_includes credit_account.errors[:credit_limit], 'must be greater than or equal to 0'
  end

  test 'validates presence of interest rate for savings accounts' do
    savings_account = FactoryBot.build(:account, :savings)
    savings_account.interest_rate = nil
    refute savings_account.valid?
    assert_includes savings_account.errors[:interest_rate], "can't be blank"
  end

  test 'associations' do
    assert_respond_to @account, :user
    assert_respond_to @account, :transactions
    assert_respond_to @account, :stashes
  end
end
