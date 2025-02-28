class Address < ApplicationRecord
  validates :zip, presence: true
  validates :town, presence: true
  validates :street, presence: true
  validates :number, presence: true

  def full_address
    "#{street} #{number}, #{zip} #{town}"
  end
end
