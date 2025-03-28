class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Person.new # guest user (not logged in)

    if user.dean?
      # Dean can manage everything
      can :manage, :all
    elsif user.teacher?
      # Teacher can manage grades and examinations
      can :manage, Grade
      can :manage, Examination
      can :read, Student
      can :read, Course
      can :read, SchoolClass
    elsif user.student?
      # Student can only read their own grades and courses
      can :read, Grade, student_id: user.id
      can :read, Course
      can :read, Examination
    end
    
    # Tous les utilisateurs connectés peuvent voir la liste des étudiants
    if user.persisted?
      can :read, Student
    end
  end
end 