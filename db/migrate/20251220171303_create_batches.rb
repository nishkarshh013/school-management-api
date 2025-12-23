class CreateBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :batches do |t|
      t.string :name
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end

    add_index :batches, :name
  end
end
