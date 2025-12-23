class CreateProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :progresses do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.integer :percentage

      t.timestamps
    end
  end
end
