# frozen_string_literal: true

class AddManagementColumnsToDataImports < ActiveRecord::Migration[8.1]
  def change
    add_column :data_imports, :log, :text
    add_column :data_imports, :job_id, :string
    add_column :data_imports, :cancel_requested, :boolean, null: false, default: false
  end
end
