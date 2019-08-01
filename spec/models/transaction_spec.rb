# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @account = FactoryBot.create(:account, user: @user)
  end

  describe 'validations' do
    it { should validate_presence_of(:trx_type).with_message('Please select debit or credit') }
    it { should validate_inclusion_of(:trx_type).in_array(%w[credit debit]) }
    it { should validate_presence_of(:trx_date) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_length_of(:memo) }
  end

  describe '#convert_amount' do
    let(:debit) { FactoryBot.create(:transaction, account: @account) }
    let(:credit) { FactoryBot.create(:transaction, trx_type: 'credit', account: @account) }

    it 'should be negative for debit transactions' do
      expect(debit.amount).to be <= 0
    end

    it 'should be positive for credit transactions' do
      expect(credit.amount).to be >= 0
    end
  end

  describe 'callbacks' do
    it 'should update the account balance on create' do
      old_balance = @account.current_balance
      transaction = FactoryBot.create(:transaction, description: 'Test Create', account: @account)
      @account.reload
      expect(@account.current_balance).to eq old_balance + transaction.amount
    end

    it 'should update the account balance on update' do
      transaction = FactoryBot.create(:transaction, description: 'Test Create', account: @account)
      @account.reload
      old_balance = @account.current_balance
      old_amount = transaction.amount
      transaction.update(amount: 25, trx_type: 'debit')
      @account.reload
      expect(@account.current_balance).to eq old_balance - old_amount + transaction.amount
    end

    it 'should update the account balance on destroy' do
      transaction = FactoryBot.create(:transaction, description: 'Test Create', account: @account)
      @account.reload
      old_balance = @account.current_balance
      old_amount = transaction.amount
      transaction.destroy
      @account.reload
      expect(@account.current_balance).to eq old_balance - old_amount
    end
  end

  it { is_expected.to belong_to(:account) }
  # it { is_expected.to have_one(:transaction_balance) }
end
