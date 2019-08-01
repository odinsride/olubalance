# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { FactoryBot.create(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name).with_message('Please enter your First Name') }
    it { should validate_presence_of(:last_name).with_message('Please enter your Last Name') }
    it { should validate_presence_of(:timezone).with_message('Please select a Time Zone') }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@gmail.com').for(:email) }
    it { should_not allow_value('asdf').for(:email) }
  end

  describe 'password missing' do
    subject { FactoryBot.build(:user, password: nil, password_confirmation: nil) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
  end

  describe 'password too short' do
    subject { FactoryBot.build(:user, password: 'asdf') }
    it { should validate_length_of(:password) }
  end

  it { should have_many(:accounts) }
end
