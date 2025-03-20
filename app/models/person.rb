class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :lockable,
         :recoverable, :rememberable, :validatable

  belongs_to :address
  belongs_to :status

  validates :type, presence: true
  validates :email, presence: true, uniqueness: true

  def self.types
    %w[Teacher Student Dean]
  end

  def fullname
    "#{firstname} #{lastname}"
  end

  # Ensure subclasses can use Devise
  def self.inherited(child)
    child.include Devise::Models::DatabaseAuthenticatable
    super
  end

  # Authorization methods
  def dean?
    type == 'Dean'
  end

  def teacher?
    type == 'Teacher'
  end

  def student?
    type == 'Student'
  end
end
