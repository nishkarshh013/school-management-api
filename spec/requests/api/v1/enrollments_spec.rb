require 'rails_helper'

RSpec.describe "Api::V1::Enrollments", type: :request do
  let!(:school) { create(:school) }
  let!(:other_school) { create(:school) }

  let!(:course) { create(:course, school: school) }
  let!(:batch) { create(:batch, course: course) }

  let!(:other_course) { create(:course, school: other_school) }
  let!(:other_batch) { create(:batch, course: other_course) }

  let(:admin) { create(:user, :admin) }
  let(:school_admin) { create(:user, :school_admin, school: school) }
  let(:other_school_admin) { create(:user, :school_admin, school: other_school) }
  let(:student) { create(:user, :student, school: school) }

  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  describe "POST /api/v1/enrollments" do
    it "allows student to request enrollment" do
      post "/api/v1/enrollments",
           headers: auth_headers(student),
           params: {
             enrollment: {
               batch_id: batch.id
             }
           }.to_json

      expect(response).to have_http_status(:created)
    end

    it "prevents school admin from creating enrollment" do
      post "/api/v1/enrollments",
           headers: auth_headers(school_admin),
           params: {
             enrollment: {
               batch_id: batch.id
             }
           }.to_json

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/enrollments/:id/approve" do
    let!(:enrollment) do
      create(:enrollment, batch: batch, student: student, status: :pending)
    end

    it "allows school admin to approve enrollment of their school" do
      patch "/api/v1/enrollments/#{enrollment.id}/approve",
            headers: auth_headers(school_admin)

      expect(response).to have_http_status(:ok)
      expect(enrollment.reload.status).to eq("approved")
    end

    it "prevents school admin from approving enrollment of other school" do
      patch "/api/v1/enrollments/#{enrollment.id}/approve",
            headers: auth_headers(other_school_admin)

      expect(response).to have_http_status(:forbidden)
    end

    it "prevents student from approving enrollment" do
      patch "/api/v1/enrollments/#{enrollment.id}/approve",
            headers: auth_headers(student)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/enrollments/:id/reject" do
    let!(:enrollment) do
      create(:enrollment, batch: batch, student: student, status: :pending)
    end

    it "allows school admin to reject enrollment of their school" do
      patch "/api/v1/enrollments/#{enrollment.id}/reject",
            headers: auth_headers(school_admin)

      expect(response).to have_http_status(:ok)
      expect(enrollment.reload.status).to eq("rejected")
    end

    it "prevents student from rejecting enrollment" do
      patch "/api/v1/enrollments/#{enrollment.id}/reject",
            headers: auth_headers(student)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
