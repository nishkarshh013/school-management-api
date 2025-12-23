# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

# Cleanup (safe order)
Enrollment.delete_all
Batch.delete_all
Course.delete_all
User.delete_all
School.delete_all

# Create School
school = School.create!(
  name: "Konnector Academy"
)

puts "School created"

# Create Users

admin = User.create!(
  email: "admin@konnector.ai",
  name: "admin",
  password: "password",
  password_confirmation: "password",
  role: :admin
)

school_admin = User.create!(
  name: "school admin",
  email: "schooladmin@konnector.ai",
  password: "password",
  password_confirmation: "password",
  role: :school_admin,
  school: school
)

student_1 = User.create!(
  name: "student 1",
  email: "student1@konnector.ai",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school
)

student_2 = User.create!(
  name: "student 2",
  email: "student2@konnector.ai",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school
)

puts "Users created"

# Create Course
course = Course.create!(
  name: "Ruby on Rails",
  school: school
)

puts "Course created"

# Create Batch
batch = Batch.create!(
  name: "Rails Jan 2025",
  course: course
)

puts "Batch created"

# Enrollments

Enrollment.create!(
  student: student_1,
  batch: batch,
  status: :approved,
  progress: 70
)

Enrollment.create!(
  student: student_2,
  batch: batch,
  status: :pending,
  progress: 0
)

puts "Enrollments created"

puts "Seeding completed successfully!"
