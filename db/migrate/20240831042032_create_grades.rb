class CreateGrades < ActiveRecord::Migration[7.2]
  def change
    create_table :grades do |t|
      t.references :student, foreign_key: { to_table: :users }  # Reference to users table for students
      t.references :course, foreign_key: true
      t.references :teacher,foreign_key: {to_table: :users}
      t.string :grade

      t.timestamps
    end
  end
end
