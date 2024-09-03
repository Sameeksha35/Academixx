class UserMailer < ApplicationMailer
    default from: 'no-reply@gmail.com'

    def registration_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Academix')
    end
  
    def weekly_report(user)
      @user = user
      @enrollments = @user.enrollments.includes(:course) # Assuming you want to include course data as well
      @grades = @user.grades.includes(:course) # Adjust as needed
      # @report_data = user.generate_weekly_report
      mail(to: @user.email, subject: 'Weekly Progress Report')
    end
end
  

# class UserMailer
#     include Sidekiq::jobs
  
#     def perform(user_id)
#       user = User.find(user_id)
#       UserMailer.registration_email(user).deliver_now
#       UserMailer.weekly_report(user).deliver_now
#     end
# end