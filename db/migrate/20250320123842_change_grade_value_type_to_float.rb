class ChangeGradeValueTypeToFloat < ActiveRecord::Migration[8.0]
  def change
    change_column :grades, :value, :float
  end
end
