class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :email
      t.string :password_digest
      t.string :userid
      t.boolean :role

      t.timestamps
    end
  end
end
