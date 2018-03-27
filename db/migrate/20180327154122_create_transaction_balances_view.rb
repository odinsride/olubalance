class CreateTransactionBalancesView < ActiveRecord::Migration[5.1]
	def up
		execute <<-SQL
	      CREATE VIEW transaction_balances AS (
	        SELECT id AS transaction_id,
       		       SUM(amount) OVER(PARTITION BY account_id ORDER BY trx_date, id) AS running_balance
			  FROM transactions
	      )
	    SQL
	end

	def down
		execute("DROP VIEW transaction_balances")
	end
end
