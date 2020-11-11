# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:account)).to be_valid
  end

  describe 'account creation' do
    before do
      @account = FactoryBot.create(:account)
    end
    
    it 'should set the current balance to the starting balance' do
      expect(@account.current_balance).to_not eq nil
      expect(@account.current_balance).to eq @account.starting_balance
    end

    it 'should create initial transaction' do
      expect(@account.transactions.first.account_id).to eq @account.id
    end

    it 'sets the initial transaction locked flag to true' do
      expect(@account.transactions.first.locked).to be true
    end
  end

  describe 'transaction amount totals' do
    before do
      @account = FactoryBot.create(:account)
      
      amt1 = 20
      amt2 = 140
      amt3 = 500
      @total_pending = amt1 + amt2 + amt3

      amt4 = 120
      amt5 = 80
      amt6 = 900
      @total_non_pending = amt4 + amt5 + amt6 + @account.current_balance

      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt1, pending: true)
      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt2, pending: true)
      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt3, pending: true)
      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt4)
      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt5)
      FactoryBot.create(:transaction, :credit_transaction, account: @account, amount: amt6)
    end

    context 'pending balance' do
      it 'returns the balance of pending transactions' do
        puts @account.pending_balance
        expect(@account.pending_balance).to eq @total_pending
      end
    end

    context 'non-pending balance' do
      it 'returns the balance of non-pending transactions' do
        puts @account.non_pending_balance
        expect(@account.non_pending_balance).to eq @total_non_pending
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starting_balance) }
    it { should allow_value(150.51).for(:starting_balance) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should allow_value('My Account').for(:name) }
    it { should_not allow_value('A').for(:name) }
    it { should_not allow_value('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA').for(:name) }
    it { should allow_value('1234').for(:last_four) }
    it { should allow_value(nil).for(:last_four) }
    it { should_not allow_value('12').for(:last_four) }
    it { should_not allow_value('12345').for(:last_four) }
    it { should_not allow_value('ASDF').for(:last_four) }
  end

  it { should belong_to(:user) }
  it { should have_many(:transactions) }
  it { should have_many(:stashes) }
end
