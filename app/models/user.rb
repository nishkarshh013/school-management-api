class User < ApplicationRecord
  has_secure_password

  enum :role, {admin: 0, school_admin: 1, student: 2}

  validates :name, :email, :role, presence: true
  validates :email, uniqueness: true

  belongs_to :school, optional: true
end
