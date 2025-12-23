# spec/requests/api/v1/auth_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  let(:password) { "password123" }
  let!(:user) do
    create(
      :user,
      email: "test@example.com",
      password: password,
      password_confirmation: password
    )
  end

  describe "POST /api/v1/login" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post "/api/v1/login", params: {
          email: user.email,
          password: password
        }

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body["token"]).to be_present
      end

      it "returns a token that decodes to the correct user" do
        post "/api/v1/login", params: {
          email: user.email,
          password: password
        }

        token = JSON.parse(response.body)["token"]
        decoded = JsonWebToken.decode(token)

        expect(decoded[:user_id]).to eq(user.id)
      end
    end

    context "with invalid password" do
      it "returns unauthorized" do
        post "/api/v1/login", params: {
          email: user.email,
          password: "wrongpassword"
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid email" do
      it "returns unauthorized" do
        post "/api/v1/login", params: {
          email: "wrong@example.com",
          password: password
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with missing params" do
      it "returns unauthorized" do
        post "/api/v1/login", params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
