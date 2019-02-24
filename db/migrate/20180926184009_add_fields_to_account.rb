class AddFieldsToAccount < ActiveRecord::Migration[5.2]
  def up
    change_table :accounts, bulk: true do |t|
      t.integer :last_four
      t.boolean :active, default: true
    end
  end
end
