require 'rails_helper'

RSpec.feature "Logins", type: :feature do
  scenario "user logs in successfully" do
    user = FactoryBot.create(:user)

    visit root_path
    within "header" do
      click_link "Login"
    end
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    within ".olubalance" do
      click_button "Login"
    end

    expect(page).to have_content("Accounts")
  end

  scenario "user logs in unsuccessfully" do
    user = FactoryBot.create(:user)

    visit root_path
    within "header" do
      click_link "Login"
    end
    fill_in "user_email", with: user.email
    fill_in "user_password", with: 'asdfasdf'
    within ".olubalance" do
      click_button "Login"
    end

    expect(page).to have_content("Login to olubalance")
  end
end
