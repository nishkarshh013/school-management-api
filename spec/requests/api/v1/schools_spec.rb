def auth_headers(user)
  token = JsonWebToken.encode(user_id: user.id)
  {
    "Authorization" => "Bearer #{token}",
    "Content-Type" => "application/json"
  }
end

require 'rails_helper'

RSpec.describe "Api::V1::Schools", type: :request do
  let!(:school_a) { create(:school, name: "School A") }
  let!(:school_b) { create(:school, name: "School B") }

  let(:admin) { create(:user, :admin) }
  let(:school_admin_a) { create(:user, :school_admin, school: school_a) }
  let(:student) { create(:user, :student, school: school_a) }

  describe "GET /api/v1/schools" do
    it "allows admin to list schools" do
      get "/api/v1/schools", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "prevents school admin from listing schools" do
      get "/api/v1/schools", headers: auth_headers(school_admin_a)
      expect(response).to have_http_status(:forbidden)
    end

    it "prevents student from listing schools" do
      get "/api/v1/schools", headers: auth_headers(student)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/v1/schools/:id" do
    it "allows admin to view any school" do
      get "/api/v1/schools/#{school_b.id}", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "allows school admin to view own school" do
      get "/api/v1/schools/#{school_a.id}", headers: auth_headers(school_admin_a)
      expect(response).to have_http_status(:ok)
    end

    it "prevents school admin from viewing other school" do
      get "/api/v1/schools/#{school_b.id}", headers: auth_headers(school_admin_a)
      expect(response).to have_http_status(:forbidden)
    end

    it "prevents student from viewing school" do
      get "/api/v1/schools/#{school_a.id}", headers: auth_headers(student)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/schools" do
    it "allows admin to create school" do
      expect {
        post "/api/v1/schools",
         headers: auth_headers(admin),
         params: { school: { name: "New School" } },
         as: :json
      }.to change(School, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "prevents non-admin from creating school" do
      post "/api/v1/schools",
           headers: auth_headers(student),
           params: { school: { name: "Hack School" } },
           as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/schools/:id" do
    it "allows admin to update any school" do
      patch "/api/v1/schools/#{school_b.id}",
            headers: auth_headers(admin),
            params: { school: { name: "Updated" } },
            as: :json

      expect(response).to have_http_status(:ok)
    end

    it "allows school admin to update own school" do
      patch "/api/v1/schools/#{school_a.id}",
            headers: auth_headers(school_admin_a),
            params: { school: { name: "Updated" } },
            as: :json

      expect(response).to have_http_status(:ok)
    end

    it "prevents school admin from updating other school" do
      patch "/api/v1/schools/#{school_b.id}",
            headers: auth_headers(school_admin_a),
            params: { school: { name: "Hack" } },
            as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end
end
