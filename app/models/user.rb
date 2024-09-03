class User < ApplicationRecord
    has_secure_password

    has_many :grades, class_name: 'Grade', foreign_key: 'teacher_id',dependent: :destroy
    has_many :grades, class_name: 'Grade', foreign_key: 'student_id',dependent: :destroy
    has_many :courses, foreign_key: 'teacher_id'
    has_many :enrollments, foreign_key: 'student_id'#added 
  
  
    validates :name,:username,:email,presence: true
    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true,length: { minimum: 6 }, on: :create

    rolify


    # scope :with_role, ->(role) { joins(:roles).where(roles: { name: role }) }#way to define a custom query that can be called on a model. Scopes are used to encapsulate common queries and make them reusable

    # def generate_weekly_report
    #     # Get the student's courses and grades
    #     enrolled_courses = self.enrollments.includes(:course)
    #     course_grades = self.grades.includes(:course, :teacher)
    
    #     report_data = {
    #       student_name: self.name,
    #       courses: enrolled_courses.map do |enrollment|
    #         {
    #           course_title: enrollment.course.title,
    #           teacher_name: enrollment.course.teacher.name,
    #           grade: enrollment.grade
    #         }
    #       end,
    #       grades: course_grades.map do |grade|
    #         {
    #           course_title: grade.course.title,
    #           teacher_name: grade.teacher.name,
    #           grade: grade.grade
    #         }
    #       end,
    #       progress_summary: "You have completed #{completed_courses_count(enrolled_courses)} courses this week."
    #     }
    
    #     report_data
    #   end
    
    #   private
    
    #   def completed_courses_count(enrolled_courses)
    #     enrolled_courses.select { |enrollment| enrollment.grade != 'Not Graded' }.count
    #   end
end
  