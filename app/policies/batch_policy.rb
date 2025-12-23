class BatchPolicy < ApplicationPolicy
  def create?
    user.school_admin?
  end

  def update?
    user.school_admin? && same_school?
  end

  def show?
    user.admin? || school_admin_can_access? || student_can_access? 
  end

  def index?
    user.admin? || user.school_admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.school_admin?
        scope
          .joins(course: :school)
          .where(schools: { id: user.school_id })
      else
        scope
          .joins(:enrollments)
          .where(enrollments: { student_id: user.id, status: "approved" })
      end
    end
  end

  private

  def same_school?
    record.course.school_id == user.school_id
  end

  def school_admin_can_access?
    user.school_admin? && same_school?
  end

  def student_can_access?
    user.student? &&
      record.enrollments.exists?(student_id: user.id, status: "approved")
  end
end