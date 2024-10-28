# frozen_string_literal: true

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  def setup
    @account = FactoryBot.create(:account)
  end

  test 'has a valid factory' do
    assert FactoryBot.build(:transaction).valid?
    assert FactoryBot.build(:transaction, :credit_transaction).valid?
  end

  # Transaction values are stored in DB as positive (credit) or negative (debit)
  # The transaction type is not stored in DB
  test 'debit transaction converts amount to a negative value' do
    debit_transaction = FactoryBot.create(:transaction)
    assert_operator debit_transaction.amount, :<=, 0
  end

  test 'credit transaction leaves amount as a positive value' do
    credit_transaction = FactoryBot.create(:transaction, :credit_transaction)
    assert_operator credit_transaction.amount, :>=, 0
  end

  test 'create transaction updates account balance' do
    original_balance = @account.current_balance
    transaction = FactoryBot.create(:transaction, account: @account)
    @account.reload
    assert_equal original_balance + transaction.amount, @account.current_balance
  end

  test 'update transaction updates account balance' do
    original_balance = @account.current_balance
    transaction = FactoryBot.create(:transaction, account: @account, trx_type: 'credit')
    @account.reload

    # Initial balance log
    original_transaction_amount = transaction.amount
    # puts "Original Balance: #{original_balance}, Transaction Created Amount: #{original_transaction_amount}"

    # Expected balance after transaction creation
    expected_balance_after_creation = original_balance + original_transaction_amount
    assert_equal expected_balance_after_creation, @account.current_balance, "Balance mismatch after transaction creation"

    # Update the transaction and log the changes
    new_transaction_amount = Faker::Number.decimal(l_digits: 2, r_digits: 2).to_f
    transaction.update(amount: new_transaction_amount, trx_type: 'debit')
    @account.reload
    # puts "Updated Transaction Amount: #{new_transaction_amount}, Updated Type: #{transaction.trx_type}"

    # Calculate the expected balance after update and log it
    expected_balance_after_update = original_balance - new_transaction_amount
    # puts "Expected Balance After Update: #{expected_balance_after_update}"
    # puts "Actual Balance After Update: #{@account.current_balance}"
    assert_equal expected_balance_after_update, @account.current_balance, "Balance mismatch after transaction update"
  end


  test 'delete transaction updates account balance' do
    transaction = FactoryBot.create(:transaction, account: @account)
    original_balance = @account.current_balance
    transaction.destroy
    @account.reload
    assert_equal original_balance, @account.current_balance
  end

  test 'transaction type return value for debit transaction' do
    transaction = FactoryBot.create(:transaction)
    assert_includes transaction.transaction_type, 'debit'
  end

  test 'transaction type return value for credit transaction' do
    transaction = FactoryBot.create(:transaction, :credit_transaction)
    assert_includes transaction.transaction_type, 'credit'
  end

  test 'transaction search returns matching transactions' do
    transaction1 = FactoryBot.create(:transaction, account: @account, description: 'Test Transaction One')
    transaction2 = FactoryBot.create(:transaction, account: @account, description: 'Test Transaction Two')
    transaction3 = FactoryBot.create(:transaction, account: @account, description: 'Test Transaction Three')

    assert_includes Transaction.search('Test'), transaction1
    assert_includes Transaction.search('Test'), transaction2
    assert_includes Transaction.search('Test'), transaction3
    assert_includes Transaction.search('Two'), transaction2
  end

  # Validation tests
  test 'validates presence of trx_type' do
    transaction = FactoryBot.build(:transaction, trx_type: nil)
    refute transaction.valid?
    assert_includes transaction.errors[:trx_type], 'Please select debit or credit'
  end

  test 'validates inclusion of trx_type in [credit, debit]' do
    transaction = FactoryBot.build(:transaction, trx_type: 'invalid_type')
    refute transaction.valid?
    assert_includes transaction.errors[:trx_type], 'is not included in the list'
  end

  test 'validates presence of trx_date' do
    transaction = FactoryBot.build(:transaction, trx_date: nil)
    refute transaction.valid?
    assert_includes transaction.errors[:trx_date], "can't be blank"
  end

  test 'validates presence of description' do
    transaction = FactoryBot.build(:transaction, description: nil)
    refute transaction.valid?
    assert_includes transaction.errors[:description], "can't be blank"
  end

  test 'validates presence and numericality of amount' do
    transaction = FactoryBot.build(:transaction, amount: nil)
    refute transaction.valid?
    assert_includes transaction.errors[:amount], "can't be blank"

    transaction.amount = 'non-numeric'
    refute transaction.valid?
    assert_includes transaction.errors[:amount], 'is not a number'
  end

  test 'belongs to account' do
    transaction = FactoryBot.build(:transaction, account: @account)
    assert transaction.account
  end
end
