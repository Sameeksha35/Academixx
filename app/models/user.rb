class User < ApplicationRecord
    has_secure_password

    has_many :grades, class_name: 'Grade', foreign_key: 'teacher_id',dependent: :destroy
    has_many :grades, class_name: 'Grade', foreign_key: 'student_id',dependent: :destroy
    has_many :courses, foreign_key: 'teacher_id'
    has_many :enrollments, foreign_key: 'student_id'#added 
  
  
    validates :name,:username,:email,:password,:password_confirmation, presence: true
    validates :email, presence: true, uniqueness: true,format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    validates :name, presence: true, format: { with: /\A[a-zA-Z]+(?:\s[a-zA-Z]+)?\z/, message: "should contain letters only and can include a single space between first and last name" }
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true,length: { minimum: 6 }, confirmation: true, on: :create

    rolify

end
  