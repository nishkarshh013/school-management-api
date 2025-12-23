class AddProgressToEnrollment < ActiveRecord::Migration[8.1]
  def change
    add_column :enrollments, :progress, :integer
  end
end
