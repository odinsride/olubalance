require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it "signs user in and out" do
    user = User.new(
      email: "john2525@gmail.com",
      password: 'topsecret',
      password_confirmation: 'topsecret',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      timezone: 'Eastern Time (US & Canada)',
      confirmed_at: DateTime.now
    )
    user.skip_confirmation!
    user.save!

    sign_in user
    get authenticated_root_path
    expect(controller.current_user).to eq(user)

    sign_out user
    get authenticated_root_path
    expect(controller.current_user).to be_nil
  end
end