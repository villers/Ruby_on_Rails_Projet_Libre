class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.timestamps
      t.string :remember_token
      t.string :slug
    end

    add_index :users, :email, unique: true
    add_index  :users, :remember_token
    add_index  :users, :slug, unique: true
  end
end
