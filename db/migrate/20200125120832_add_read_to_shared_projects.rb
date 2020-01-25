class AddReadToSharedProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_projects, :read, :boolean
  end
end
