class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end

    add_index :courses, :name
  end
end
