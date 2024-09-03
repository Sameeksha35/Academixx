class Grade < ApplicationRecord
  belongs_to :course
  belongs_to :student, class_name: 'User',foreign_key: 'student_id'#added foreign key
  belongs_to :teacher, class_name: 'User',foreign_key: 'teacher_id'#added foreign key
  validates :grade, presence: { message: "Grade must be provided!" }
  validates :course_id, uniqueness: { scope: :student_id, message: "This student is already graded for this course." },on: :create
  
end
