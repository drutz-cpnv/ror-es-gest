class AddTrackableColumnsToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :sign_in_count, :integer
    add_index :people, :sign_in_count
    add_column :people, :current_sign_in_at, :datetime
  end
end
