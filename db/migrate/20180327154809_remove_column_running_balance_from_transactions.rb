class RemoveColumnRunningBalanceFromTransactions < ActiveRecord::Migration[5.1]
  def change
  	remove_column :transactions, :running_balance
  end
end
