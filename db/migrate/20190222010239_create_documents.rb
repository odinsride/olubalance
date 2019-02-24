class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :account, foreign_key: true
      t.datetime   :document_date
      t.timestamps
    end
  end
end
