class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.integer :zip
      t.string :town
      t.string :street
      t.string :number

      t.timestamps
    end
  end
end
