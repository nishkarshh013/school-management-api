class School < ApplicationRecord
  has_many :users
  has_many :courses, dependent: :destroy

  validates :name, presence: true
end
