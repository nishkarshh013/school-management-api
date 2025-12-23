require 'rails_helper'

RSpec.describe CoursePolicy do
  describe '#create?' do
    it "allows school admin to create course" do
      school_admin = create(:user, :school_admin)
      course = Course.new(school: school_admin.school)
      policy = CoursePolicy.new(school_admin, course)
      expect(policy.create?).to be true
    end

    it 'prevents student from creating a course' do
      student = create(:user, :student)
      course = Course.new(school: student.school)

      policy = CoursePolicy.new(student, course)

      expect(policy.create?).to be false
    end
  end

  describe '#update?' do
    let(:school_a) { create(:school) }
    let(:school_b) { create(:school) }

    let(:school_admin) { create(:user, :school_admin, school: school_a) }

    let(:course_a) { create(:course, school: school_a) }
    let(:course_b) { create(:course, school: school_b) }

    it 'allows school admin to update their own school course' do
      policy = CoursePolicy.new(school_admin, course_a)
      expect(policy.update?).to be true
    end

    it 'prevents school admin from updating other school course' do
      policy = CoursePolicy.new(school_admin, course_b)
      expect(policy.update?).to be false
    end
  end

  describe 'Scope' do
    subject(:resolved_scoped) do
      CoursePolicy::Scope.new(current_user, Course).resolve
    end

    let(:school) { create(:school) }

    context 'as_admin' do
      let(:current_user) { create(:user, :admin, school: school) }

      it "returns all courses" do
        course_a = create(:course)
        course_b = create(:course)

        expect(resolved_scoped).to match_array([ course_a, course_b ])
      end
    end

    context 'as school admin' do
      let(:school) { create(:school) }
      let(:current_user) { create(:user, :school_admin, school: school) }

      it 'returns only courses from their school' do
        own_course = create(:course, school: school)
        other_course = create(:course)

        expect(resolved_scoped).to contain_exactly(own_course)
      end
    end

    context 'as student' do
      let(:current_user) { create(:user, :student) }

      it 'returns no courses' do
        create(:course)
        expect(resolved_scoped).to be_empty
      end
    end
  end
end
