require 'rails_helper'

RSpec.describe StashEntry, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:stash_entry_date) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:amount) }
    it { should allow_value('10000.00').for(:amount) }
    it { should_not allow_value('ASDF').for(:amount) }
    it { should_not allow_value('-100.00').for(:amount) }
  end

  describe 'defaults' do
    subject { FactoryBot.create(:stash_entry, stash: FactoryBot.create(:stash, account: FactoryBot.create(:account, user: FactoryBot.create(:user)))) }
    it { expect(subject.description).to eq "Stash funded" }
    it { expect(subject.amount).to eq 100.0 }
  end

  it { should belong_to(:stash) }
end
