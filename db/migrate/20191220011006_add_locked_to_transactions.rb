class AddLockedToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :locked, :boolean, default: false
  end
end
