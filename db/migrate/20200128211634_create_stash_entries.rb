class CreateStashEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :stash_entries do |t|
      t.datetime :stash_entry_date
      t.string :description
      t.decimal :amount
      t.references :stash, foreign_key: true
      
      t.timestamps
    end
  end
end
