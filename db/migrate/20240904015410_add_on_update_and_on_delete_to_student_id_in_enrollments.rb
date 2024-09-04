class AddOnUpdateAndOnDeleteToStudentIdInEnrollments < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :enrollments, column: :student_id
    add_foreign_key :enrollments, :users, column: :student_id, on_update: :cascade, on_delete: :cascade
  end
end
