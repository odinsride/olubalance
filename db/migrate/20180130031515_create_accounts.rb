class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :starting_balance
      t.decimal :current_balance

      t.timestamps
    end
  end
end
