class CreateSharedProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_projects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.boolean :read
      t.boolean :write
      t.boolean :update
      t.boolean :delete

      t.timestamps
    end
  end
end
