require "rails_helper"

RSpec.describe "Stash management", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @account = FactoryBot.create(:account, name: "Stash Management Test", starting_balance: 5000, user: @user)
    @account_starting_balance = "$5,000.00"
    @stash_goal = 3000
    @stash = FactoryBot.create(:stash, goal: @stash_goal, account: @account)
  end

  it "displays a list of the user's stashes" do
    sign_in @user
    get account_stashes_path(account_id: @account.id)
    expect(response).to be_successful
    expect(response.body).to include(@stash.name)
    expect(response.body).to include(@stash_goal.to_s)
  end

  it "doesn't show another account's stashes" do
    account2 = FactoryBot.create(:account, name: "Account 2", user: @user)
    stash2 = FactoryBot.create(:stash, name: "Stash 2", account: account2)

    sign_in @user
    get account_stashes_path(account_id: @account.id)
    expect(response).to be_successful
    expect(response.body).to_not include("Stash 2")
  end

  it "creates a new stash and redirects to the transactions page" do
    sign_in @user
    get new_account_stashes_path(@account.id)
    expect(response.body).to include("New Stash")

    post "/accounts/#{@account.id}/stashes", params: { 
      stash: { 
        name: "Test Create Stash", 
        goal: 3500, 
        account: @account.id
      }
    }
    expect(response).to redirect_to(account_transactions_path(@account))
    follow_redirect!

    expect(response.body).to include("Test Create Stash")
  end

  it "updates an existing stash and redirects to the transactions page" do
    sign_in @user
    get edit_account_stash_path(@account.id, @stash.id)
    expect(response.body).to include("Edit Stash")

    patch "/accounts/#{@account.id}/stash/#{@stash.id}", params: { 
      stash: { 
        name: "Stash Management Test Edited", 
        goal: 10000 
      }
    }
    expect(response).to redirect_to(account_transactions_path(@account))
    follow_redirect!

    expect(response.body).to include("Stash Management Test Edited")
  end

  # it "deactivates an existing account and activates an inactive account" do
  #   sign_in @user

  #   # Deactivate the account and check that it is not present on main accounts page
  #   get deactivate_account_path(id: @account.id)

  #   expect(response).to redirect_to(accounts_path)
  #   follow_redirect!

  #   expect(response.body).to_not include(@account.name)
  #   expect(response.body).to_not include(@account_starting_balance)

  #   # Visit the inactive accounts page and check that the inactive account is present
  #   get accounts_inactive_path
  #   expect(response.body).to include(@account.name)
  #   expect(response.body).to include(@account_starting_balance)

  #   # Reactivate the account and check that the account appears back on the main accounts page
  #   get activate_account_path(id: @account.id)

  #   expect(response).to redirect_to(accounts_path)
  #   follow_redirect!

  #   expect(response.body).to include(@account.name)
  #   expect(response.body).to include(@account_starting_balance)

  #   # Go back to the inactive accounts page and ensure the reactivated account is not listed
  #   get accounts_inactive_path
  #   expect(response.body).to_not include(@account.name)
  #   expect(response.body).to_not include(@account_starting_balance)
  # end
end
