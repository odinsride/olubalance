class AddPendingToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :pending, :boolean, default: false
  end
end
