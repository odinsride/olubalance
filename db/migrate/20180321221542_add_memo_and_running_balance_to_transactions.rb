class AddMemoAndRunningBalanceToTransactions < ActiveRecord::Migration[5.1]
  def change
  	add_column :transactions, :memo, :string
  	add_column :transactions, :running_balance, :decimal
  end
end
