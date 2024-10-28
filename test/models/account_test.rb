# test/models/account_test.rb

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @user = FactoryBot.create(:user) # Assuming you have a User factory
    @account = FactoryBot.build(:account, user: @user)
  end

  test 'valid factory' do
    assert @account.valid?
  end

  test 'validates presence of name' do
    @account.name = nil
    refute @account.valid?
    assert_includes @account.errors[:name], "can't be blank"
  end

  test 'validates length of name' do
    @account.name = 'A' * 51
    refute @account.valid?
    assert_includes @account.errors[:name], 'is too long (maximum is 50 characters)'

    @account.name = 'A' # Too short
    refute @account.valid?
    assert_includes @account.errors[:name], 'is too short (minimum is 2 characters)'
  end

  test 'validates uniqueness of name scoped to user' do
    existing_account = FactoryBot.create(:account, name: 'Test Account', user: @user)
    @account.name = 'Test Account'
    refute @account.valid?
    assert_includes @account.errors[:name], 'has already been taken'
  end

  test 'validates presence of starting_balance' do
    @account.starting_balance = nil
    refute @account.valid?
    assert_includes @account.errors[:starting_balance], "can't be blank"
  end

  test 'validates last_four format' do
    @account.last_four = '123'
    refute @account.valid?
    assert_includes @account.errors[:last_four], 'Numbers only.'

    @account.last_four = 'abcd'
    refute @account.valid?
    assert_includes @account.errors[:last_four], 'Numbers only.'
  end

  test 'validates interest_rate presence and numericality' do
    @account.interest_rate = nil
    refute @account.valid?
    assert_includes @account.errors[:interest_rate], "can't be blank"

    @account.interest_rate = -1
    refute @account.valid?
    assert_includes @account.errors[:interest_rate], 'must be greater than or equal to 0'
  end

  test 'validates credit_limit presence and numericality' do
    @account.account_type = 'credit'
    @account.credit_limit = nil
    refute @account.valid?
    assert_includes @account.errors[:credit_limit], "can't be blank"

    @account.credit_limit = -1
    refute @account.valid?
    assert_includes @account.errors[:credit_limit], 'must be greater than or equal to 0'
  end

  test 'validates account_type inclusion' do
    @account.account_type = 'invalid_type'
    refute @account.valid?
    assert_includes @account.errors[:account_type], 'is not included in the list'
  end

  test 'pending_balance calculates correctly' do
    @account.save
    FactoryBot.create(:transaction, account: @account, amount: 100, pending: true)
    FactoryBot.create(:transaction, account: @account, amount: 50, pending: false)
    assert_equal 100, @account.pending_balance
  end

  test 'non_pending_balance calculates correctly' do
    @account.save
    FactoryBot.create(:transaction, account: @account, amount: 100, pending: false)
    FactoryBot.create(:transaction, account: @account, amount: 50, pending: false)
    assert_equal 150, @account.non_pending_balance
  end

  test 'available_credit calculates correctly' do
    @account.credit_limit = 1000.0
    @account.current_balance = -500.0
    assert_equal 500.0, @account.available_credit

    @account.current_balance = -1500.0
    assert_equal 0, @account.available_credit
  end

  test 'credit_utilization calculates correctly' do
    @account.credit_limit = 1000.0
    @account.current_balance = -500.0
    assert_equal 50.0, @account.credit_utilization

    @account.current_balance = -1000.0
    assert_equal 100.0, @account.credit_utilization
  end

  test 'initial transaction is created after account creation' do
    assert_difference('Transaction.count', 1) do
      @account.save
    end
    assert_equal "Starting Balance", @account.transactions.first.description
  end
end
