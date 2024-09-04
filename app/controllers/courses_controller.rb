#not optimise working
# class CoursesController < ApplicationController
#     before_action :authorize_request
#     load_and_authorize_resource except: [:index]
  
#     # def index
#     #   if current_user.has_role?(:teacher)
#     #     # Filter courses to only those owned by the current teacher
#     #     @courses = Course.where(teacher_id: current_user.id)
#     #   else
#     #     # Handle other roles or unauthorized access
#     #     @courses = Course.all
#     #   end
  
#     #   render json: @courses
#     # end

#     # def index
#     #   if current_user&.has_role?(:teacher)
#     #     # Filter courses to only those owned by the current teacher
#     #     @courses = Course.where(teacher_id: current_user.id)
#     #   elsif current_user&.has_role?(:student)
#     #     # Filter courses to only those the student is enrolled in
#     #     @courses = Course.joins(:enrollments).where(enrollments: { student_id: current_user.id })
#     #   else
#     #     # For non-authenticated users or other roles, display all courses
#     #     @courses = Course.all
#     #   end
    
#     #   render json: @courses
#     # end
#     # def index
#     #   @courses = if current_user&.has_role?(:teacher)
#     #                # Filter courses to only those owned by the current teacher
#     #                Course.where(teacher_id: current_user.id)
#     #              elsif current_user&.has_role?(:student)
#     #                # Filter courses to only those the student is enrolled in
#     #                Course.joins(:enrollments).where(enrollments: { student_id: current_user.id })
#     #              else
#     #                # Handle other roles or for unauthenticated users
#     #                Course.all
#     #              end
    
#     #   teachers = User.where(id: @courses.pluck(:teacher_id)).index_by(&:id)
    
#     #   render json: {
#     #     message: "List of all courses retrieved successfully.",
#     #     total_courses: @courses.size,
#     #     courses: @courses.map do |course|
#     #       course_info = {
#     #         id: course.id,
#     #         title: course.title,
#     #         description: course.description,
#     #         created_at: course.created_at.strftime('%B %d, %Y'),
#     #         updated_at: course.updated_at.strftime('%B %d, %Y')
#     #       }
    
#     #       if current_user&.has_role?(:teacher) || current_user&.has_role?(:student)
#     #         course_info[:teacher] = {
#     #           id: course.teacher_id,
#     #           name: teachers[course.teacher_id]&.name # Efficient lookup
#     #         }
#     #       else
#    #         course_info[:teacher] = {
#     #           name: teachers[course.teacher_id]&.name # Only show name
#     #         }
#     #       end
    
#     #       course_info
#     #     end
#     #   }, status: :ok
#     # end
    
    
    
#     # def index
#     #   @courses = if current_user&.has_role?(:teacher)
#     #                # Filter courses to only those owned by the current teacher
#     #               Course.where(teacher_id: current_user.id)
#     #              elsif current_user&.has_role?(:student)
#     #                # Filter courses to only those the student is enrolled in
#     #               Course.joins(:enrollments).where(enrollments: { student_id: current_user.id })
#     #              else
#     #                # For unauthenticated users or other roles, display all courses
#     #               Course.all
#     #              end
    
#     #   teachers = User.where(id: @courses.pluck(:teacher_id)).index_by(&:id)
    
#     #   render json: {
#     #     message: "List of all courses retrieved successfully.",
#     #     total_courses: @courses.size,
#     #     courses: @courses.map do |course|
#     #       course_info = {
#     #         id: course.id,
#     #         title: course.title,
#     #         description: course.description,
#     #         created_at: course.created_at.strftime('%B %d, %Y'),
#     #         updated_at: course.updated_at.strftime('%B %d, %Y')
#     #       }
    
#     #       if current_user&.has_role?(:teacher) || current_user&.has_role?(:student)
#     #         course_info[:teacher] = {
#     #           id: course.teacher_id,
#     #           name: teachers[course.teacher_id]&.name
#     #         }
#     #       else
#     #         course_info[:teacher] = {
#     #           name: teachers[course.teacher_id]&.name
#     #         }
#     #       end
    
#     #       course_info
#     #     end
#     #   }, status: :ok
#     # end 
    
#     def index
#       @courses = if current_user&.has_role?(:teacher)
#                    # Filter courses to only those owned by the current teacher
#                    Course.where(teacher_id: current_user.id)
#                  elsif current_user&.has_role?(:student)
#                    # Filter courses to only those the student is enrolled in
#                    Course.joins(:enrollments).where(enrollments: { student_id: current_user.id })
#                  else
#                    # Handle other roles or for unauthenticated users
#                    Course.all
#                  end
    
#       teachers = User.where(id: @courses.pluck(:teacher_id)).index_by(&:id)
    
#       render json: {
#         message: "List of all courses retrieved successfully.",
#         total_courses: @courses.size,
#         courses: @courses.map do |course|
#           course_info = {
#             id: course.id,
#             title: course.title,
#             description: course.description,
#             created_at: course.created_at.strftime('%B %d, %Y'),
#             updated_at: course.updated_at.strftime('%B %d, %Y')
#           }
    
#           if current_user&.has_role?(:teacher) || current_user&.has_role?(:student)
#             course_info[:teacher] = {
#               id: course.teacher_id,
#               name: teachers[course.teacher_id]&.name # Efficient lookup
#             }
#           else
#            course_info[:teacher] = {
#               name: teachers[course.teacher_id]&.name # Only show name
#             }
#           end
    
#           course_info
#         end
#       }, status: :ok
#     end
    
    
#     # def show
#     #   @course = Course.find(params[:id])
#     #   # Ensure the teacher is authorized to view the specific course
#     #   if current_user.has_role?(:teacher) && @course.teacher_id != current_user.id
#     #     render json: { error: 'You are not authorized to view this course' }, status: :forbidden
#     #   else
#     #     render json: @course
#     #   end
#     # end

#     def show
#       @course = Course.find(params[:id])
    
#       # Authorize the current user based on the Ability class
#       authorize! :read, @course
    
#       # Fetch the teacher's name
#       teacher_name = @course.teacher.name if @course.teacher.present?
    
#       render json: {
#         message: "Course details retrieved successfully.",
#         course: {
#           id: @course.id,
#           title: @course.title,
#           description: @course.description,
#           teacher_id: @course.teacher_id,
#           teacher_name: teacher_name,
#           created_at: @course.created_at.strftime('%B %d, %Y'),
#           updated_at: @course.updated_at.strftime('%B %d, %Y')
#         }
#       }, status: :ok
#     end
    
  
#     def create
#       @course = Course.new(course_params)
      
#       # If teacher_id is not provided, use current_user as default
#       @course.teacher_id ||= current_user.id
      
#       if @course.save
#         render json: {
#           message: "Course created successfully!",
#           course: {
#             id: @course.id,
#             title: @course.title,
#             description: @course.description,
#             teacher_id: @course.teacher_id,
#             teacher_name: @course.teacher.name, # Assuming `name` is an attribute in the `User` model
#             created_at: @course.created_at.strftime('%B %d, %Y'),
#             updated_at: @course.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :created
#       else
#         render json: {
#           message: "Failed to create course",
#           errors: @course.errors
#         }, status: :unprocessable_entity
#       end
#     end
    
    
  
#     def update
#       if @course.update(course_params)
#         # Fetch the teacher's name
#         teacher_name = @course.teacher.name if @course.teacher.present?
        
#         render json: {
#           message: "Course successfully updated.",
#           course: {
#             id: @course.id,
#             title: @course.title,
#             description: @course.description,
#             teacher_id: @course.teacher_id,
#             teacher_name: teacher_name,
#             created_at: @course.created_at.strftime('%B %d, %Y'),
#             updated_at: @course.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to update course.",
#           errors: @course.errors
#         }, status: :unprocessable_entity
#       end
#     end
    
  
#     def destroy
#       if @course.destroy
#         render json: {
#           message: "Course deleted successfully.",
#           course: {
#             id: @course.id,
#             title: @course.title,
#             description: @course.description,
#             teacher_id: @course.teacher_id,
#             teacher_name: @course.teacher.name,
#             created_at: @course.created_at.strftime('%B %d, %Y'),
#             updated_at: @course.updated_at.strftime('%B %d, %Y')
#           }
#         }, status: :ok
#       else
#         render json: {
#           message: "Failed to delete course.",
#           errors: @course.errors
#         }, status: :unprocessable_entity
#       end
#     end
    
    
  
#     private
  
#     def course_params
#       params.require(:course).permit(:title, :description,:teacher_id)
#     end

# end

#not optimise working


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

