# spec/policies/school_policy_spec.rb
require 'rails_helper'

RSpec.describe SchoolPolicy do
  let(:school_a) { create(:school) }
  let(:school_b) { create(:school) }

  let(:admin) { create(:user, :admin) }
  let(:school_admin_a) { create(:user, :school_admin, school: school_a) }
  let(:school_admin_b) { create(:user, :school_admin, school: school_b) }
  let(:student) { create(:user, :student, school: school_a) }

  # ------------------------------------------------
  # CREATE
  # ------------------------------------------------

  describe '#create?' do
    it 'allows admin to create school' do
      policy = SchoolPolicy.new(admin, School.new)
      expect(policy.create?).to be true
    end

    it 'prevents school admin from creating school' do
      policy = SchoolPolicy.new(school_admin_a, School.new)
      expect(policy.create?).to be false
    end

    it 'prevents student from creating school' do
      policy = SchoolPolicy.new(student, School.new)
      expect(policy.create?).to be false
    end
  end

  # ------------------------------------------------
  # SHOW
  # ------------------------------------------------

  describe '#show?' do
    it 'allows admin to view any school' do
      policy = SchoolPolicy.new(admin, school_b)
      expect(policy.show?).to be true
    end

    it 'allows school admin to view their own school' do
      policy = SchoolPolicy.new(school_admin_a, school_a)
      expect(policy.show?).to be true
    end

    it 'prevents school admin from viewing another school' do
      policy = SchoolPolicy.new(school_admin_a, school_b)
      expect(policy.show?).to be false
    end

    it 'prevents student from viewing school' do
      policy = SchoolPolicy.new(student, school_a)
      expect(policy.show?).to be false
    end
  end

  # ------------------------------------------------
  # UPDATE
  # ------------------------------------------------

  describe '#update?' do
    it 'allows admin to update any school' do
      policy = SchoolPolicy.new(admin, school_b)
      expect(policy.update?).to be true
    end

    it 'allows school admin to update their own school' do
      policy = SchoolPolicy.new(school_admin_a, school_a)
      expect(policy.update?).to be true
    end

    it 'prevents school admin from updating another school' do
      policy = SchoolPolicy.new(school_admin_a, school_b)
      expect(policy.update?).to be false
    end

    it 'prevents student from updating school' do
      policy = SchoolPolicy.new(student, school_a)
      expect(policy.update?).to be false
    end
  end

  # ------------------------------------------------
  # INDEX
  # ------------------------------------------------

  describe '#index?' do
    it 'allows admin to list schools' do
      policy = SchoolPolicy.new(admin, School)
      expect(policy.index?).to be true
    end

    it 'prevents school admin from listing schools' do
      policy = SchoolPolicy.new(school_admin_a, School)
      expect(policy.index?).to be false
    end

    it 'prevents student from listing schools' do
      policy = SchoolPolicy.new(student, School)
      expect(policy.index?).to be false
    end
  end

  # ------------------------------------------------
  # SCOPE
  # ------------------------------------------------

  describe 'Scope' do
    subject(:resolved_scope) do
      SchoolPolicy::Scope.new(current_user, School).resolve
    end

    context 'as admin' do
      let(:current_user) { admin }

      it 'returns all schools' do
        expect(resolved_scope).to match_array([ school_a, school_b ])
      end
    end

    context 'as school admin' do
      let(:current_user) { school_admin_a }

      it 'returns only their own school' do
        expect(resolved_scope).to match_array([ school_a ])
      end
    end

    context 'as student' do
      let(:current_user) { student }

      it 'returns no schools' do
        expect(resolved_scope).to be_empty
      end
    end
  end
end
