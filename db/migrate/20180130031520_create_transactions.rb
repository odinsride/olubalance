class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.datetime :trx_date
      t.string :description
      t.decimal :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
