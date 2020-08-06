# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  it "is valid with required fields populated" do
    user = User.new(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@gmail.com',
      password: 'topsecret',
      timezone: 'Eastern Time (US & Canada)'
    )
    expect(user).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name).with_message('Please enter your First Name') }
    it { is_expected.to validate_presence_of(:last_name).with_message('Please enter your Last Name') }
    it { is_expected.to validate_presence_of(:timezone).with_message('Please select a Time Zone') }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('test@gmail.com').for(:email) }
    it { is_expected.to_not allow_value('asdf').for(:email) }
  end

  it { should have_many(:accounts) }
end
