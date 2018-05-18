class AddAttachmentAttachmentToTransactions < ActiveRecord::Migration[5.1]
  def self.up
    change_table :transactions do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :transactions, :attachment
  end
end
