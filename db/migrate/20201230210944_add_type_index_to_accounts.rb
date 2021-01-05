class AddTypeIndexToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_index :accounts, :account_type
  end
end
