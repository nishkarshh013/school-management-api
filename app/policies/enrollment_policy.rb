class EnrollmentPolicy < ApplicationPolicy
  def create?
    user.student?
  end

  def approve?
    user.school_admin? && record.batch.course.school_id == user.school_id
  end

  def reject?
    user.school_admin? && record.batch.course.school_id == user.school_id
  end

  # scope auth

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope
          .joins(batch: { course: :school })
          .where(school: { id: user.school_id })
      else
        scope.where(student: user)
      end
    end
  end
end
