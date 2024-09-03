class WeeklyReportJob < ApplicationJob
  queue_as :default

  def perform
    User.with_role(:student).find_each do |student|
      UserMailer.weekly_report(student).deliver_now
    end
  end
end

