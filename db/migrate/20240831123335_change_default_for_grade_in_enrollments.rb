class ChangeDefaultForGradeInEnrollments < ActiveRecord::Migration[7.0]
  def change
    change_column_default :enrollments, :grade, 'Not Graded'
  end
end
