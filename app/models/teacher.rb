class Teacher < Person
  has_many :courses, foreign_key: :teacher_id
end
