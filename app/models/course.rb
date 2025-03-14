class Course < ApplicationRecord
  enum :week_day, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  belongs_to :teacher
  belongs_to :school_class
  belongs_to :subject
  belongs_to :moment
  has_many :examinations
end
