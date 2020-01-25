class DropSharedProjects < ActiveRecord::Migration[6.0]
  def change
    drop_table :shared_projects
  end
end
