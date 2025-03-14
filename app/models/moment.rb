class Moment < ApplicationRecord
  enum :moment_type, { year: 0, semester: 1, quarter: 2 }

  has_many :courses
  has_many :school_classes

  def parent_moment
    case moment_type
    when :moment_type[:semester] || :moment_type[:quarter]
      Moment.find_by uid: uid[0..-2]
    else
      nil
    end
  end

  def children_moments
    case moment_type
    when :moment_type[:year]
      Moment.where("uid LIKE ?", "#{uid}%").where.not(uid: uid).where("type != ?", :moment_type[:quarter])
    when :moment_type[:semester]
      Moment.where("uid LIKE ?", "#{uid}T%")
    else
      []
    end
  end

  def display_name
    "#{moment_type.titleize} (#{start_on.strftime('%B %Y')} - #{end_on.strftime('%B %Y')})"
  end
end
