class SchoolPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || (user.school_admin? && record.id == user.school_id)
  end

  def show?
    user.admin? || (user.school_admin? && record.id == user.school_id)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope.where(id: user.school_id)
      else
        scope.none
      end
    end
  end
end
