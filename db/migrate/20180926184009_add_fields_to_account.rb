class AddFieldsToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :last_four, :integer
    add_column :accounts, :active, :boolean, default: true
  end
end
