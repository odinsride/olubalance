class AddTransferFieldsToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :transfer, :boolean, default: false
    add_column :transactions, :parent_transaction_id, :integer, foreign_key: true 
  end
end
