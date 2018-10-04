class AddNameToUser < ActiveRecord::Migration[5.1]
  def up
    change_table :users, bulk: true do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
