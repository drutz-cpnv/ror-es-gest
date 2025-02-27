class CreateStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :statuses do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
