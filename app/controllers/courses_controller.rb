class CoursesController < ApplicationController
  before_action :authorize_request
  load_and_authorize_resource

  def index
    @courses = case current_user_role
               when :teacher
                 Course.where(teacher_id: current_user.id)
               when :student
                 Course.joins(:enrollments).where(enrollments: { student_id: current_user.id })
               else
                 Course.all
               end

    render json: {
      message: "List of all courses retrieved successfully.",
      total_courses: @courses.size,
      courses: format_courses(@courses)
    }, status: :ok
  end

  def show
    render json: {
      message: "Course details retrieved successfully.",
      course: format_course(@course)
    }, status: :ok
  end

  def create
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
    @course.teacher = current_user
    if @course.save
      render json: {
        message: "Course created successfully!",
        course: format_course(@course)
      }, status: :created
    else
      render json: {
        message: "Failed to create course",
        errors: @course.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
    if @course.update(course_params)
      render json: {
        message: "Course successfully updated.",
        course: format_course(@course)
      }, status: :ok
    else
      render json: {
        message: "Failed to update course.",
        errors: @course.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      render json: {
        message: "Course deleted successfully.",
        course: format_course(@course)
      }, status: :ok
    else
      render json: {
        message: "Failed to delete course.",
        errors: @course.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :teacher_id)
  end

  def extra_params_present?
    permitted_keys = course_params.keys.map(&:to_s)
    course_params_keys = params[:course].keys.map(&:to_s) if params[:course].present?
    top_level_keys = params.keys.map(&:to_s) - ['controller', 'action', 'course','id']
    all_keys = (course_params_keys || []) + top_level_keys
    extra_keys = all_keys - permitted_keys
    extra_keys.any?
  end
  

  def format_course(course)
    {
      id: course.id,
      title: course.title,
      description: course.description,
      teacher_id: course.teacher_id,
      teacher_name: course.teacher&.name,
      created_at: course.created_at.strftime('%B %d, %Y'),
      updated_at: course.updated_at.strftime('%B %d, %Y')
    }
  end

  def format_courses(courses)
    teachers = User.where(id: courses.pluck(:teacher_id)).index_by(&:id)
    courses.map do |course|
      course_info = format_course(course)
      course_info[:teacher_name] = teachers[course.teacher_id]&.name
      course_info
    end
  end

  def current_user_role
    return :guest if current_user.nil?
    return :admin if current_user.has_role?(:admin)
    return :teacher if current_user.has_role?(:teacher)
    return :student if current_user.has_role?(:student)
    :guest
  end
end

