class UpdateForeignKeyConstraintsInGrades < ActiveRecord::Migration[7.2]
  def change
    # # Add new foreign key constraints with ON DELETE CASCADE and ON UPDATE CASCADE
    # add_foreign_key :grades, :courses, on_delete: :cascade, on_update: :cascade
    # add_foreign_key :grades, :users, column: :teacher_id, on_delete: :cascade, on_update: :cascade
    # add_foreign_key :grades, :users, column: :student_id, on_delete: :cascade, on_update: :cascade
  end
end
