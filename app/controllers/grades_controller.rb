#not optimise working
# class GradesController < ApplicationController
#     before_action :authorize_request
#     before_action :set_grade, only: [:show, :update, :destroy]
#     load_and_authorize_resource

#     # def index
#     #   if @course
#     #     @grades = @course.grades
#     #   elsif @student
#     #     @grades = @student.grades
#     #   else
#     #     @grades = Grade.all
#     #   end
  
#     #   render json: @grades
#     # end
#     # def index
#     #   if current_user.has_role?(:student)
#     #     @grades = Grade.where(student_id: current_user.id)
#     #   elsif current_user.has_role?(:teacher)
#     #     # Assuming you want teachers to see all grades for their courses
#     #     @grades = Grade.joins(course: :teacher).where(teachers: { id: current_user.id })
#     #   else
#     #     @grades = Grade.all
#     #   end
  
#     #   render json: @grades
#     # end


#     def index
#       @grades = Grade.all 
#       @grades = @grades.accessible_by(current_ability)

#       render json: {
#         message: "Grades retrieved successfully.",
#         grades: @grades.map do |grade|
#           {
#             id: grade.id,
#             course_id: grade.course_id,
#             student_id: grade.student_id,
#             teacher_id: grade.teacher_id,  
#             course_title: grade.course.title,  
#             student_name: grade.student.name,  
#             teacher_name: grade.teacher.name,  
#             grade: grade.grade,
#             created_at: grade.created_at.strftime('%B %d, %Y'),
#             updated_at: grade.updated_at.strftime('%B %d, %Y')
#           }
#         end
#       }, status: :ok
#     end

#     # def show
#     #   # Admins have access to all grades
#     #   if current_user.has_role?(:admin)
#     #     render json: @grade
#     #   else
#     #     # Teachers can only access grades for their own courses
#     #     if @grade.course.teacher_id == current_user.id
#     #       render json: @grade
#     #     else
#     #       render json: { error: "You are not authorized to view this grade." }, status: :forbidden
#     #     end
#     #   end
#     # end

#     def show
     
#       authorize! :read, @grade
#       @grades = @grades.accessible_by(current_ability)
#       render json: {
#         message: "Grade details retrieved successfully.",
#         grade: {
#           id: @grade.id,
#           student_id: @grade.student_id,
#           student_name: @grade.student.name, 
#           course_id: @grade.course_id,
#           course_title: @grade.course.title, 
#           teacher_id: @grade.teacher_id,
#           teacher_name: @grade.teacher.name, 
#           grade: @grade.grade,
#           created_at: @grade.created_at.strftime('%B %d, %Y'),
#           updated_at: @grade.updated_at.strftime('%B %d, %Y')
#         }
#       }, status: :ok
#     rescue CanCan::AccessDenied
#       render json: { error: "You are not authorized to view this grade." }, status: :forbidden
#     end

#     def create
#       @grade = Grade.new(grade_params)
    
#       if @grade.save
#         student = User.find(@grade.student_id) # Assuming student is a User
#         course = Course.find(@grade.course_id)
    
#         render json: {
#           message: "Student successfully graded for the course!",
#           enrollment: {
#             id: @grade.id,
#             student_id: @grade.student_id,
#             student_name: student.name, # Use the 'student' object to get the name
#             course_id: @grade.course_id,
#             course_title: course.title, # Use the 'course' object to get the title
#             teacher_id: @grade.teacher_id,
#             teacher_name: current_user.name,
#             grade: @grade.grade,
#             created_at: @grade.created_at.strftime("%d %B %Y"),
#             updated_at: @grade.updated_at.strftime("%d %B %Y")
#           }
#         }, status: :created
#       else
#         render json: {
#             message: "Failed to create grade",
#             errors: @grade.errors
#           }, status: :unprocessable_entity
#       end
#     end
    
#     def update
#       if @grade.update(grade_params)
#         render json: {
#           message: "Grade updated successfully.",
#           grade: {
#             id: @grade.id,
#             student_id: @grade.student_id,
#             course_id: @grade.course_id,
#             teacher_id: @grade.teacher_id,
#             grade: @grade.grade,
#             created_at: @grade.created_at.strftime('%B %d, %Y'),
#             updated_at: @grade.updated_at.strftime('%B %d, %Y') # Updated timestamp
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to update grade.",
#           errors: @grade.errors.full_messages
#         }, status: :unprocessable_entity
#       end
#     end

#     def destroy
#       if @grade.destroy
#         render json: {
#           message: "Grade deleted successfully.",
#           grade: {
#             id: @grade.id,
#             student_id: @grade.student_id,
#             course_id: @grade.course_id,
#             teacher_id: @grade.teacher_id,
#             grade: @grade.grade,
#             created_at: @grade.created_at.strftime('%B %d, %Y'),
#             updated_at: @grade.updated_at.strftime('%B %d, %Y') 
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to delete grade.",
#           errors: @grade.errors.full_messages
#         }, status: :unprocessable_entity
#       end
#     end
    
    

#     private

#     def grade_params
#       params.permit(:student_id, :course_id, :teacher_id,:grade)
#     end
#     def set_grade
#       @grade = Grade.find(params[:id])
#     end

  
# end
#not optimise working
  
class GradesController < ApplicationController
  before_action :authorize_request
  before_action :set_grade, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @grades = Grade.accessible_by(current_ability)
    
    render json: {
      message: "Grades retrieved successfully.",
      grades: @grades.map { |grade| grade_details(grade) }
    }, status: :ok
  end

  def show
    render json: {
      message: "Grade details retrieved successfully.",
      grade: grade_details(@grade)
    }, status: :ok
  rescue CanCan::AccessDenied
    render json: { error: "You are not authorized to view this grade." }, status: :forbidden
  end

  def create
    # if extra_params_present?
    #   render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
    #   return
    # end
    @grade = Grade.new(grade_params)
    @grade.teacher = current_user
    if @grade.save
      render json: {
        message: "Student successfully graded for the course!",
        grade: grade_details(@grade)
      }, status: :created
    else
      render json: {
        message: "Failed to create grade.",
        errors: @grade.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # def update
  #   if extra_params_present?
  #     render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
  #     return
  #   end
  #   if @grade.update(grade_params)
  #     render json: {
  #       message: "Grade updated successfully.",
  #       grade: grade_details(@grade)
  #     }, status: :ok
  #   else
  #     render json: {
  #       message: "Failed to update grade.",
  #       errors: @grade.errors.full_messages
  #     }, status: :unprocessable_entity
  #   end
  # end

  def update
    # if extra_params_present?
    #   render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
    #   return
    # end

    changes = grade_params.reject { |key, value| value == @grade.send(key) }
    
    if changes.empty?
      render json: { message: "No changes detected. Nothing to update." }, status: :ok
      return
    end

    if @grade.update(changes)
      render json: {
        message: "Grade updated successfully.",
        updated_attributes: changes,
        grade: grade_details(@grade)
      }, status: :ok
    else
      render json: {
        message: "Failed to update grade.",
        errors: @grade.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @grade.destroy
      render json: {
        message: "Grade deleted successfully.",
        grade: grade_summary(@grade)
      }, status: :ok
    else
      render json: {
        message: "Failed to delete grade.",
        errors: @grade.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  # def grade_params
  #     params.require(:grade).permit(:student_id, :course_id, :grade)
  # end
  
  
  def grade_params
    params.permit(:student_id, :course_id,:grade)
  end
  

  def set_grade
    @grade = Grade.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Grade not found." }, status: :not_found
  end

  # def extra_params_present?
  #   permitted_keys = grade_params.keys.map(&:to_s)
  #   grade_params_keys = params[:grade].keys.map(&:to_s) if params[:grade].present?
  #   top_level_keys = params.keys.map(&:to_s) - ['controller', 'action', 'grade','id']
  #   all_keys = (grade_params_keys || []) + top_level_keys
  #   extra_keys = all_keys - permitted_keys
  #   extra_keys.any?
  # end
  
  def grade_details(grade)
    {
      id: grade.id,
      student_id: grade.student_id,
      student_name: grade.student.name,
      course_id: grade.course_id,
      course_title: grade.course.title,
      teacher_id: grade.teacher_id,
      teacher_name: grade.teacher.name,
      grade: grade.grade,
      created_at: grade.created_at.strftime('%B %d, %Y'),
      updated_at: grade.updated_at.strftime('%B %d, %Y')
    }
  end

  def grade_summary(grade)
    {
      id: grade.id,
      student_id: grade.student_id,
      course_id: grade.course_id,
      teacher_id: grade.teacher_id,
      grade: grade.grade
    }
  end
end
