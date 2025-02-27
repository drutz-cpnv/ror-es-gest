class Person < ApplicationRecord
  belongs_to :address
  belongs_to :status

  def self.types
    %w[Teacher Student Dean]
  end
end
