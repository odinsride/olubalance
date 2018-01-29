class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.datetime :trx_date
      t.string :description
      t.decimal :amount

      t.timestamps
    end
  end
end
