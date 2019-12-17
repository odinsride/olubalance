class ChangeLastFourToBeStringInAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :last_four, :string
  end
end
