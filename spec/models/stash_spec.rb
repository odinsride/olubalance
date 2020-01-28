require 'rails_helper'

RSpec.describe Stash, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:goal) }
    it { should validate_uniqueness_of(:name).scoped_to(:account_id) }
    it { should allow_value('My Stash').for(:name) }
    it { should_not allow_value('A').for(:name) }
    it { should_not allow_value('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA').for(:name) }
    it { should allow_value('10000.00').for(:goal) }
    it { should_not allow_value('ASDF').for(:goal) }
    it { should_not allow_value('-100.00').for(:goal) }
  end

  describe 'defaults' do
    subject { FactoryBot.create(:stash, account: FactoryBot.create(:account, user: FactoryBot.create(:user))) }
    it { expect(subject.active).to eq true }
    it { expect(subject.balance).to eq 0.00 }
  end

  it { should belong_to(:account) }
  it { should have_many(:stash_entries) }
end
