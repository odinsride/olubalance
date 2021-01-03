class AddTypeToAccounts < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE account_types AS ENUM ('checking', 'savings', 'credit', 'cash')
    SQL
    add_column :accounts, :account_type, :account_types, default: 'checking'
  end

  def def down 
    remove_column :accounts, :account_type
    execute <<-SQL
      DROP TYPE account_types
    SQL
  end
end
