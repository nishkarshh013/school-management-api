# spec/policies/batch_policy_spec.rb
require 'rails_helper'

RSpec.describe BatchPolicy do

  let(:school_a) { create(:school) }
  let(:school_b) { create(:school) }

  let(:admin) { create(:user, :admin, school: school_a) }
  let(:school_admin_a) { create(:user, :school_admin, school: school_a) }
  let(:school_admin_b) { create(:user, :school_admin, school: school_b) }
  let(:student) { create(:user, :student, school: school_a) }

  let(:course_a) { create(:course, school: school_a) }
  let(:course_b) { create(:course, school: school_b) }

  let(:batch_a) { create(:batch, course: course_a) }
  let(:batch_b) { create(:batch, course: course_b) }


  describe '#create?' do
    it 'allows school admin to create batch for their school course' do
      policy = BatchPolicy.new(school_admin_a, batch_a)
      expect(policy.create?).to be true
    end

    it 'prevents student from creating batch' do
      policy = BatchPolicy.new(student, batch_a)
      expect(policy.create?).to be false
    end
  end

  describe '#update?' do
    it 'allows school admin to update batch from same school' do
      policy = BatchPolicy.new(school_admin_a, batch_a)
      expect(policy.update?).to be true
    end

    it 'prevents school admin from updating batch from other school' do
      policy = BatchPolicy.new(school_admin_b, batch_a)
      expect(policy.update?).to be false
    end
  end

  describe '#show?' do
    it 'allows admin to view any batch' do
      policy = BatchPolicy.new(admin, batch_b)
      expect(policy.show?).to be true
    end

    it 'allows student to view batch only if enrolled and approved' do
      policy = BatchPolicy.new(school_admin_a, batch_a)
      expect(policy.show?).to be true
    end
  end

  describe 'Scope' do

    subject(:resolved_scope) do
      BatchPolicy::Scope.new(current_user, Batch).resolve
    end

    context 'as admin' do
      let(:current_user) { admin }

      it 'returns all batches' do
        expect(resolved_scope).to match_array([batch_a, batch_b])
      end
    end

    context 'as school admin' do
      let(:current_user) { school_admin_a }

      it 'returns only batches from their school' do
        expect(resolved_scope).to match_array([batch_a])
      end
    end

    context 'as student' do
      let!(:enrollment) { create(:enrollment, batch: batch_a, student: student, status: :approved) }
      let(:current_user) { student }

      it 'returns only batches the student is approved for' do
        expect(resolved_scope).to match_array([batch_a])
      end
    end
  end
end
