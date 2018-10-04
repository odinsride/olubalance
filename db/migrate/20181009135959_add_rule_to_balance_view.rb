class AddRuleToBalanceView < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE RULE tb_ins_protect AS ON INSERT TO transaction_balances
        DO INSTEAD NOTHING;
      CREATE RULE tb_upd_protect AS ON UPDATE TO transaction_balances
        DO INSTEAD NOTHING;
      CREATE RULE tb_del_protect AS ON DELETE TO transaction_balances
        DO INSTEAD NOTHING;
    SQL
  end

  def down
    execute <<-SQL
      DROP RULE tb_ins_protect;
      DROP RULE tb_upd_protect;
      DROP RULE tb_del_protect;
    SQL
  end
end
