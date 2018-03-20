class ChangeTrxdateToDateInTransactions < ActiveRecord::Migration[5.1]
  def change
  	change_column :transactions, :trx_date, :date
  end
end
