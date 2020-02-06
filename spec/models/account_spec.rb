# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starting_balance) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should allow_value('My Account').for(:name) }
    it { should_not allow_value('A').for(:name) }
    it { should_not allow_value('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA').for(:name) }
    it { should allow_value('1234').for(:last_four) }
    it { should_not allow_value('12').for(:last_four) }
    it { should_not allow_value('12345').for(:last_four) }
    it { should_not allow_value('ASDF').for(:last_four) }
  end

  describe '#set_current_balance' do
    subject { FactoryBot.create(:account, user: FactoryBot.create(:user)) }
    it { expect(subject.current_balance).to_not eq nil }
    it { expect(subject.current_balance).to eq subject.starting_balance }
  end

  describe '#create_initial_transaction' do
    it 'creates a new transaction record for the starting balance' do
      expect do
        FactoryBot.create(:account, user: FactoryBot.create(:user))
      end.to change(Transaction, :count).by(1)
    end

    it 'sets the initial transaction locked flag to true' do
      account = FactoryBot.create(:account, user: FactoryBot.create(:user))
      expect(account.transactions.first.locked).to be true
    end
  end

  it { should belong_to(:user) }
  it { should have_many(:transactions) }
  it { should have_many(:stashes) }
end
