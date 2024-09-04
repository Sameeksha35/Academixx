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
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
    # unless Course.exists?(params[:enrollment][:course_id])
    #   render json: { error: "Course not found" }, status: :unprocessable_entity
    #   return
    # end

    # unless User.exists?(params[:enrollment][:student_id])
    #   render json: { error: "Student not found" }, status: :unprocessable_entity
    #   return
    # end

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
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
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
    params.require(:enrollment).permit(:course_id, :student_id)#:grade removed
  end

  def format_enrollments(enrollments)
    enrollments.map { |enrollment| format_enrollment(enrollment) }
  end

  def extra_params_present?
    permitted_keys = enrollment_params.keys.map(&:to_s)
    enrollment_params_keys = params[:enrollment].keys.map(&:to_s) if params[:enrollment].present?
    top_level_keys = params.keys.map(&:to_s) - ['controller', 'action', 'enrollment','id']
    all_keys = (enrollment_params_keys || []) + top_level_keys
    extra_keys = all_keys - permitted_keys
    extra_keys.any?
  end

  def format_enrollment(enrollment)
    {
      id: enrollment.id,
      course_id: enrollment.course_id,
      course_title: enrollment.course.title,
      student_id: enrollment.student_id,
      student_name: enrollment.student.name,
      created_at: enrollment.created_at.strftime('%B %d, %Y'),
      updated_at: enrollment.updated_at.strftime('%B %d, %Y')
    }
  end
end
