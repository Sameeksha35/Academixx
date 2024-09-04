class Grade < ApplicationRecord
  belongs_to :course
  belongs_to :student, class_name: 'User',foreign_key: 'student_id'#added foreign key
  belongs_to :teacher, class_name: 'User',foreign_key: 'teacher_id'#added foreign key

  # validates :grade, presence: { message: "Grade must be provided!" }
  validates :student_id, :course_id, :grade, presence: true
  validates :course_id, uniqueness: { scope: :student_id, message: "This student is already graded for this course.you can update grade!" },on: :create #ensure that a student can only have one grade per course.
  validate :student_must_be_enrolled_in_course

  private

  def student_must_be_enrolled_in_course
    enrollment = Enrollment.find_by(course_id: course_id, student_id: student_id)
    unless enrollment
      errors.add(:student_id, "is not enrolled in this course")
    end
  end
end
