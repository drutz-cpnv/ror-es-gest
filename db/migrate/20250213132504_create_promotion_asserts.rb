class CreatePromotionAsserts < ActiveRecord::Migration[8.0]
  def change
    create_table :promotion_asserts do |t|
      t.string :description
      t.string :function
      t.references :moment, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true

      t.timestamps
    end
  end
end
