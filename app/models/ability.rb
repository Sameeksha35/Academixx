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
    cannot :destroy,Course
  end
end




