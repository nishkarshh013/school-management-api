class CoursePolicy < ApplicationPolicy
  def create?
    user.school_admin?
  end

  def update?
    user.school_admin? && same_school?
  end

  def show?
    user.admin? || (user.school_admin? && same_school?)
  end

  def index?
    user.admin? || user.school_admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope.where(school_id: user.school_id)
      else
        scope.none
      end
    end
  end

  private

  def same_school?
    record.school_id == user.school_id
  end
end