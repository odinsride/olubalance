class UpdateTransactionBalancesView < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
	      CREATE OR REPLACE VIEW transaction_balances AS (
	        SELECT id AS transaction_id,
       		       SUM(amount) OVER(PARTITION BY account_id ORDER BY pending, trx_date, id) AS running_balance
			  FROM transactions
	      )
    SQL
  end

  def down
    execute('DROP VIEW transaction_balances')
  end
end