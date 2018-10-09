class AddMemoAndRunningBalanceToTransactions < ActiveRecord::Migration[5.1]
  def up
    change_table :transactions, bulk: true do |t|
      t.string  :memo
      t.decimal :running_balance
    end
  end
end
