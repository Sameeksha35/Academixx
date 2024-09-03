class Course < ApplicationRecord
  belongs_to :teacher, class_name: 'User',foreign_key: 'teacher_id'#foreign key added
  has_many :enrollments
  has_many :students, through: :enrollments, class_name: 'User'#uncommented after testing all
  has_many :grades
  validates :title, uniqueness: { scope: :description, message: "A course with this title and description already exists." },on: :create

  
end
