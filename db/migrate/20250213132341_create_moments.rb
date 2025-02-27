class CreateMoments < ActiveRecord::Migration[8.0]
  def change
    create_table :moments do |t|
      t.string :uid
      t.date :start_on
      t.date :end_on
      t.integer :moment_type

      t.timestamps
    end
  end
end
