require 'rails_helper'

RSpec.describe "Batch students progress", type: :request do
  let(:school) { create(:school) }
  let(:course) { create(:course, school: school) }
  let(:batch) { create(:batch, course: course) }

  let(:student1) { create(:user, :student, school: school) }
  let(:student2) { create(:user, :student, school: school) }
  let(:other_student) { create(:user, :student) }

  before do
    create(:enrollment, batch: batch, student: student1, status: :approved, progress: 40)
    create(:enrollment, batch: batch, student: student2, status: :approved, progress: 70)
  end

  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  end

  it "allows student to see classmates and their progress" do
    get "/api/v1/batches/#{batch.id}/students",
        headers: auth_headers(student1)

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)

    expect(body.size).to eq(2)
    expect(body.map { |s| s["progress"] }).to contain_exactly(40, 70)
  end

  it "prevents student from another batch" do
    get "/api/v1/batches/#{batch.id}/students",
        headers: auth_headers(other_student)

    expect(response).to have_http_status(:forbidden)
  end

  it "returns classmates with their progress" do
    get "/api/v1/batches/#{batch.id}/students",
        headers: auth_headers(student1)

    body = JSON.parse(response.body)

    expect(body.size).to eq(2)

    expect(body).to include(
      hash_including("email" => student2.email, "progress" => 70),
      hash_including("email" => student1.email, "progress" => 40)
    )
  end
end
