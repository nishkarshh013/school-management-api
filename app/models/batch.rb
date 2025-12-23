class Batch < ApplicationRecord
  belongs_to :course

  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student

  validates :name, presence: true
end
