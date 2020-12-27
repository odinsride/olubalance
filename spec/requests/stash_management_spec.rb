require "rails_helper"

RSpec.describe "Stash management", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @account = FactoryBot.create(:account, name: "Stash Management Test", starting_balance: 5000, user: @user)
    @account_starting_balance = "$5,000.00"
    @stash_goal = 3000
    @stash = FactoryBot.create(:stash, goal: @stash_goal, account: @account)
  end

  describe "stash create" do
    it "creates a new stash and redirects to the stashes page" do
      sign_in @user
      get new_account_stash_path(@account.id)
      expect(response.body).to include("New Stash")

      post "/accounts/#{@account.id}/stashes", params: { 
        stash: { 
          name: "Test Create Stash", 
          goal: 3500, 
          account: @account.id
        }
      }
      create_stash_id = Stash.last.id
      expect(response).to redirect_to(account_stash_path(id: create_stash_id))
      follow_redirect!

      expect(response.body).to include("Test Create Stash")
    end
  end

  describe "stash update" do
    it "updates an existing stash and redirects to the stashes page" do
      sign_in @user
      get edit_account_stash_path(@account.id, @stash.id)
      expect(response.body).to include("Edit Stash")

      patch "/accounts/#{@account.id}/stashes/#{@stash.id}", params: { 
        stash: { 
          name: "Stash Management Test Edited", 
          goal: 10000 
        }
      }
      expect(response).to redirect_to(account_stash_path(id: @stash.id))
      follow_redirect!

      expect(response.body).to include("Stash Management Test Edited")
    end
  end

  describe "stash delete" do
    it "deletes an existing stash and redirects to the stashes page" do
      sign_in @user

      get account_stash_path(@account.id, @stash.id)

      expect(response.body).to include(@stash.name)
      expect(response.body).to include("delete-stash-#{@stash.id}")
      
      delete "/accounts/#{@account.id}/stashes/#{@stash.id}"
      expect(response).to redirect_to(account_transactions_path(@account))
    end
  end
end
