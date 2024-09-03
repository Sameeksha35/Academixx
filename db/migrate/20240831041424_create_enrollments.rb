class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.references :course,foreign_key: true
      t.references :student, foreign_key: { to_table: :users }
      t.string :grade

      t.timestamps
    end
  end
end
