class SmashColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :shared_projects, :destroy, :trash
  end
end
