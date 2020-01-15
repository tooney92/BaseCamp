class RemoveUseridFromProjects < ActiveRecord::Migration[6.0]
  def change

    remove_column :projects, :userid, :string
  end
end
