class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :shared_projects, :update, :modify
    rename_column :shared_projects, :delete, :destroy
  end
end
