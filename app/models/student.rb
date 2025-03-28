class Student < Person
  has_and_belongs_to_many :school_classes, 
    join_table: "people_school_classes", 
    foreign_key: "person_id",
    association_foreign_key: "school_class_id"

  def is_promoted(moment)
    true
  end
end
