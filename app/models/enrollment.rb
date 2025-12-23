class Enrollment < ApplicationRecord
  belongs_to :student, class_name: "User", foreign_key: :student_id
  belongs_to :batch

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  validates :student_id, uniqueness: { scope: :batch_id }
end
