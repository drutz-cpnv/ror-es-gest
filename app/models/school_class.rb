class SchoolClass < ApplicationRecord
  has_and_belongs_to_many :students, 
    join_table: "people_school_classes", 
    class_name: "Student", 
    foreign_key: "school_class_id",
    association_foreign_key: "person_id"
  belongs_to :moment
  belongs_to :room
  belongs_to :teacher, class_name: "Teacher", foreign_key: "teacher_id"
  belongs_to :sector
end
