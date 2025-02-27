class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.time :start_at
      t.time :end_at
      t.integer :week_day
      t.references :teacher, foreign_key: { to_table: :people }, null: true
      t.references :school_class, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :moment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
