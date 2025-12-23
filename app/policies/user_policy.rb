class UserPolicy < ApplicationPolicy
  def create?
    user.admin? && record.school_admin?
  end
end
