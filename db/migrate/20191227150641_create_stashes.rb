class CreateStashes < ActiveRecord::Migration[6.0]
  def change
    create_table :stashes do |t|
      t.string :name
      t.string :description
      t.decimal :balance, default: 0.00
      t.decimal :goal
      t.boolean :active, default: true
      t.references :account, foreign_key: true
      
      t.timestamps
    end
  end
end
