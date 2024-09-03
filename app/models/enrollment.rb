class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student, class_name: 'User',foreign_key: 'student_id'#added foreign key
  validates :course_id, uniqueness: { scope: :student_id, message: "This student is already enrolled in the course." },on: :create
  # validates :grade, presence: true
  
end
