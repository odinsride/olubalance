class AddInterestCreditLimitToAccount < ActiveRecord::Migration[6.0]
  def up
    change_table :accounts, bulk: true do |t|
      t.decimal :interest_rate
      t.decimal :credit_limit
    end
  end
end
