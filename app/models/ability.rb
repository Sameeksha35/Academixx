# class Ability
#   include CanCan::Ability

#   def initialize(user)
#     # Guest users have no access (unauthenticated users)
#     if user.nil?
#       can :read, Course # Example: Allow read access to courses for all users
#     else
#       # Admin users have full access
#       if user.has_role?(:admin)
#         can :manage, :all # Admin can perform any action on any model
  
#       # Teacher users have restricted access
#       elsif user.has_role?(:teacher)
#         can :manage, Course, teacher_id: user.id # Teachers can manage their own courses
#         # can :read, Course # Teachers can read all courses
#         # can :manage, Enrollment, student_id: user.id # Teachers can manage their own enrollments commented while checking teacher enroll management and added below three
#         # can :create, Enrollment, course: { teacher_id: user.id } # Teachers can enroll students in their own courses used nested conditions joins inefficient instead use below
#         can :create, Enrollment, course_id: user.courses.pluck(:id)
#         can :read, Enrollment, course: { teacher_id: user.id } # Teachers can view enrollments in their own courses
#         # can :read, Student, id: Enrollment.where(course_id: Course.where(teacher_id: user.id).pluck(:id)).pluck(:student_id) # Teachers can view students in their courses
#         can :read, User, roles: { name: 'student' } 
#         # can :manage, Grade, teacher_id: user.id it only checks if the teacher_id matches, without considering the relationship between the teacher and the course.comment while teacherr can grade for their course and added below
#         # Teachers can manage grades for students in courses they own
#         can :manage, Grade do |grade|
#           grade.course.teacher_id == user.id
#         end

#         # Other permissions for teachers can be added here
  
#       # Student users have the least access
#       elsif user.has_role?(:student)
#         can :read, Course, id: Enrollment.where(student_id: user.id).pluck(:course_id)  # Students can read their enrolled courses
#         can :read, Grade, student_id: user.id # Students can read their own grades
#         can :read, User, id: user.id # Students can read their own details
  
#         # Other permissions for students can be added here
  
#       else
#         # Default permissions for users with no role or unknown roles
#         can :read, :all
#       end

#       cannot :create, User unless user.has_role?(:admin)
#     end
#   end
  
# end

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :read, Course
      return
    elsif user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:teacher)
      teacher_permissions(user)
    elsif user.has_role?(:student)
      student_permissions(user)
    else
      can :read, :all
    end

    cannot [:create, :update, :destroy ,:index], User unless user.has_role?(:admin)
    
  end

  private

  def teacher_permissions(user)
    can :manage, Course, teacher_id: user.id
    can :create, Enrollment, course_id: user.courses.pluck(:id)
    can :manage, Enrollment, course_id: user.courses.pluck(:id)#added managing enrollment by teacher for their courses
    can :read, Enrollment, course: { teacher_id: user.id }
    can :read, User, roles: { name: 'student' }
    # can :manage, Grade do |grade|
    #   # grade.course.teacher_id == user.id
    #   grade.course.present? && grade.course.teacher_id == user.id
    # end comment when checking grade get for teacher
    can :manage, Grade, course_id: user.courses.pluck(:id) # Direct permission for grades
  end

  def student_permissions(user)
    can :read, Course, id: Enrollment.where(student_id: user.id).pluck(:course_id)
    can :read, Grade, student_id: user.id
    can :read, User, id: user.id
    can :read, Enrollment, student_id: user.id#added while student can view enrolled courses
  end

  # def current_user_role
  #   return :guest if @user.nil?
  #   return :admin if @user.has_role?(:admin)
  #   return :teacher if @user.has_role?(:teacher)
  #   return :student if @user.has_role?(:student)
  #   :guest
  # end
end




