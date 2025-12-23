class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, default: 0, null: false
      t.references :school, foreign_key: true
      t.timestamps
    end
    add_index :users, :name
    add_index :users, :email, unique: true
  end
end
