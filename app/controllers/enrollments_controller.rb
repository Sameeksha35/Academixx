#working not optimise
# class EnrollmentsController < ApplicationController
#     before_action :authorize_request
#     load_and_authorize_resource

#     def index
#       @enrollments = Enrollment.accessible_by(current_ability)
#           if @enrollments.any?
#             render json: {
#               message: "Enrollments retrieved successfully.",
#               enrollments: @enrollments.map do |enrollment|
#                 {
#                   id: enrollment.id,
#                   course_id: enrollment.course_id,
#                   course_title: enrollment.course.title,
#                   student_id: enrollment.student_id,
#                   student_name: enrollment.student.name, 
#                   grade: enrollment.grade,
#                   created_at: enrollment.created_at.strftime('%B %d, %Y'),
#                   updated_at: enrollment.updated_at.strftime('%B %d, %Y')
#                 }
#               end
#             }, status: :ok
#           else
#             render json: {
#               message: "No enrollments found."
#             }, status: :ok
#           end
#     end

#     # def index 
#     #   @enrollments = if current_user.has_role?(:teacher)
#     #                    Enrollment.where(course_id: current_user.courses.pluck(:id))
#     #                  else
#     #                    Enrollment.all
#     #                  end
    
#     #   if @enrollments.any?
#     #     render json: {
#     #       message: "Enrollments retrieved successfully.",
#     #       enrollments: @enrollments.map do |enrollment|
#     #         {
#     #           id: enrollment.id,
#     #           course_id: enrollment.course_id,
#     #           course_title: enrollment.course.title, # Assuming the course has a `title` attribute
#     #           student_id: enrollment.student_id,
#     #           student_name: enrollment.student.name, # Assuming the student has a `name` attribute
#     #           grade: enrollment.grade,
#     #           created_at: enrollment.created_at.strftime('%B %d, %Y'),
#     #           updated_at: enrollment.updated_at.strftime('%B %d, %Y')
#     #         }
#     #       end
#     #     }, status: :ok
#     #   else
#     #     render json: {
#     #       message: "No enrollments found."
#     #     }, status: :ok
#     #   end
#     # end
    
  
#     def show
#       @enrollments = Enrollment.accessible_by(current_ability)
#       if @enrollment
#         render json: {
#           message: "Enrollment details retrieved successfully.",
#           enrollment: {
#             id: @enrollment.id,
#             course_id: @enrollment.course_id,
#             course_title: @enrollment.course.title, 
#             student_id: @enrollment.student_id,
#             student_name: @enrollment.student.name, 
#             grade: @enrollment.grade,
#             created_at: @enrollment.created_at.strftime('%B %d, %Y'),
#             updated_at: @enrollment.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :ok
#       else
#         render json: { 
#           message: "Enrollment not found." 
#         }, status: :not_found
#       end
#     end
    

#     def create
#       @enrollment = Enrollment.new(enrollment_params)
    
#       if @enrollment.save
#         render json: {
#           message: "Student successfully enrolled in the course!",
#           enrollment: {
#             id: @enrollment.id,
#             course_id: @enrollment.course_id,
#             course_title: @enrollment.course.title, 
#             student_id: @enrollment.student_id,
#             student_name: @enrollment.student.name, 
#             grade: @enrollment.grade,
#             created_at: @enrollment.created_at.strftime('%B %d, %Y'),
#             updated_at: @enrollment.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :created
#       else
#         render json: {
#           message: "Failed to enroll student in the course",
#           errors: @enrollment.errors
#         }, status: :unprocessable_entity
#       end
#     end
    
    
  
#     def update
#       if @enrollment.update(enrollment_params)
#         render json: {
#           message: "Enrollment updated successfully.",
#           enrollment: {
#             id: @enrollment.id,
#             course_id: @enrollment.course_id,
#             course_title: @enrollment.course.title, 
#             student_id: @enrollment.student_id,
#             student_name: @enrollment.student.name, 
#             grade: @enrollment.grade,
#             created_at: @enrollment.created_at.strftime('%B %d, %Y'),
#             updated_at: @enrollment.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to update enrollment.",
#           errors: @enrollment.errors.full_messages
#         }, status: :unprocessable_entity
#       end
#     end
    
  
#     def destroy
#       if @enrollment.destroy
#         render json: {
#           message: "Enrollment was successfully deleted.",
#           enrollment: {
#             id: @enrollment.id,
#             course_id: @enrollment.course_id,
#             student_id: @enrollment.student_id
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to delete enrollment.",
#           errors: @enrollment.errors.full_messages
#         }, status: :unprocessable_entity
#       end
#     end
    
  
#     private
  
#     def enrollment_params
#       params.require(:enrollment).permit(:course_id,:student_id,:grade)#added courseid,studentid while checking teacher can enroll
#     end

#     def set_course
#       @course = Course.find(params[:course_id]) if params[:course_id]
#     end
# end
#working not optimise

class EnrollmentsController < ApplicationController
  before_action :authorize_request
  load_and_authorize_resource

  def index
    if @enrollments.any?
      render json: {
        message: "Enrollments retrieved successfully.",
        enrollments: format_enrollments(@enrollments)
      }, status: :ok
    else
      render json: { message: "No enrollments found." }, status: :ok
    end
  end

  def show
    if @enrollment
      render json: {
        message: "Enrollment details retrieved successfully.",
        enrollment: format_enrollment(@enrollment)
      }, status: :ok
    else
      render json: { message: "Enrollment not found." }, status: :not_found#without this show is different from create and update here don't genrally deal with validation 
    end
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      render json: {
        message: "Student successfully enrolled in the course!",
        enrollment: format_enrollment(@enrollment)
      }, status: :created
    else
      render json: {
        message: "Failed to enroll student in the course.",
        errors: @enrollment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      render json: {
        message: "Enrollment updated successfully.",
        enrollment: format_enrollment(@enrollment)
      }, status: :ok
    else
      render json: {
        message: "Failed to update enrollment.",
        errors: @enrollment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @enrollment.destroy
      render json: {
        message: "Enrollment was successfully deleted.",
        enrollment: {
          id: @enrollment.id,
          course_id: @enrollment.course_id,
          student_id: @enrollment.student_id
        }
      }, status: :ok
    else
      render json: {
        message: "Failed to delete enrollment.",
        errors: @enrollment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :student_id, :grade)
  end

  def format_enrollments(enrollments)
    enrollments.map { |enrollment| format_enrollment(enrollment) }
  end

  def format_enrollment(enrollment)
    {
      id: enrollment.id,
      course_id: enrollment.course_id,
      course_title: enrollment.course.title,
      student_id: enrollment.student_id,
      student_name: enrollment.student.name,
      grade: enrollment.grade,
      created_at: enrollment.created_at.strftime('%B %d, %Y'),
      updated_at: enrollment.updated_at.strftime('%B %d, %Y')
    }
  end
end