require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:school) { create(:school) }

  let(:admin) { create(:user, :admin) }
  let(:school_admin) { create(:user, :school_admin, school: school) }
  let(:student) { create(:user, :student, school: school) }

  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  describe "POST /api/v1/users" do
    context "as admin" do
      it "allows admin to create school admin" do
        post "/api/v1/users",
             headers: auth_headers(admin),
             params: {
               user: {
                 email: "new_school_admin@test.com",
                 password: "password",
                 password_confirmation: "password",
                 role: 1,
                 name: "School 1",
                 school_id: school.id
               }
             }, as: :json

        expect(response).to have_http_status(:created)
        expect(User.last.role).to eq("school_admin")
      end

      it "prevents admin from creating student" do
        post "/api/v1/users",
             headers: auth_headers(admin),
             params: {
               user: {
                 email: "student@test.com",
                 password: "password",
                 password_confirmation: "password",
                 role: "student",
                 school_id: school.id
               }
             }, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as school admin" do
      it "prevents school admin from creating users" do
        post "/api/v1/users",
             headers: auth_headers(school_admin),
             params: {
               user: {
                 email: "hack@test.com",
                 password: "password",
                 password_confirmation: "password",
                 role: "school_admin",
                 school_id: school.id
               }
             }, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as student" do
      it "prevents student from creating users" do
        post "/api/v1/users",
             headers: auth_headers(student),
             params: {
               user: {
                 email: "hack@test.com",
                 password: "password",
                 password_confirmation: "password",
                 role: "school_admin",
                 school_id: school.id
               }
             }, as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
