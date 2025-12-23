# spec/policies/enrollment_policy_spec.rb
require 'rails_helper'

RSpec.describe EnrollmentPolicy do

  let(:school_a) { create(:school) }
  let(:school_b) { create(:school) }

  let(:admin) { create(:user, :admin) }
  let(:school_admin_a) { create(:user, :school_admin, school: school_a) }
  let(:school_admin_b) { create(:user, :school_admin, school: school_b) }
  let(:student_a) { create(:user, :student, school: school_a) }
  let(:student_b) { create(:user, :student, school: school_b) }

  let(:course_a) { create(:course, school: school_a) }
  let(:course_b) { create(:course, school: school_b) }

  let(:batch_a) { create(:batch, course: course_a) }
  let(:batch_b) { create(:batch, course: course_b) }

  let(:enrollment_a) { create(:enrollment, batch: batch_a, student: student_a) }
  let(:enrollment_b) { create(:enrollment, batch: batch_b, student: student_b) }

  describe '#create?' do
    it 'allows student to create enrollment request' do
      policy = EnrollmentPolicy.new(student_a, enrollment_a)
      expect(policy.create?).to be true
    end

    it 'prevents school admin from creating enrollment' do
      policy = EnrollmentPolicy.new(school_admin_a, enrollment_a)
      expect(policy.create?).to be false
    end
  end

  describe '#approve?' do
    it 'allows school admin to approve enrollment from their school' do
      policy = EnrollmentPolicy.new(school_admin_a, enrollment_a)
      expect(policy.approve?).to be true
    end

    it 'prevents school admin from approving enrollment from another school' do
      policy = EnrollmentPolicy.new(school_admin_a, enrollment_b)
      expect(policy.approve?).to be false
    end

    it 'prevents student from approving enrollment' do
      policy = EnrollmentPolicy.new(student_a, enrollment_a)
      expect(policy.approve?).to be false
    end
  end

  describe '#reject?' do
    it 'allows school admin to reject enrollment from their school' do
      policy = EnrollmentPolicy.new(school_admin_a, enrollment_a)
      expect(policy.reject?).to be true
    end

    it 'prevents student from rejecting enrollment' do
      policy = EnrollmentPolicy.new(school_admin_a, enrollment_b)
      expect(policy.reject?).to be false
    end
  end

  describe 'Scope' do
    subject(:resolved_scope) do
      EnrollmentPolicy::Scope.new(current_user, Enrollment).resolve
    end

    context 'as admin' do
      let(:current_user) { admin }

      it 'returns all enrollments' do
        expect(resolved_scope).to match_array([enrollment_a, enrollment_b])
      end
    end

    context 'as school admin' do
      let(:current_user) { school_admin_a }

      it 'returns only enrollments belonging to their school' do
        expect(resolved_scope).to match_array([enrollment_a])
      end
    end

    context 'as student' do
      let(:current_user) { student_a }

      it 'returns only their own enrollments' do
        expect(resolved_scope).to match_array([enrollment_a])
      end
    end
  end
end
