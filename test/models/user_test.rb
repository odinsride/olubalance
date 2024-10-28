require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = FactoryBot.build(:user)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without first name' do
    @user.first_name = nil
    refute @user.valid?, 'saved user without a first name'
    assert_not_nil @user.errors[:first_name], 'no validation error for first name present'
  end

  test 'invalid without last name' do
    @user.last_name = nil
    refute @user.valid?, 'saved user without a last name'
    assert_not_nil @user.errors[:last_name], 'no validation error for last name present'
  end

  test 'invalid without email' do
    @user.email = nil
    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test '#accounts' do
    # Assuming you want the user to have 4 accounts
    @user.save!
    FactoryBot.create_list(:account, 4, user: @user)
    assert_equal 4, @user.accounts.size
  end
end
