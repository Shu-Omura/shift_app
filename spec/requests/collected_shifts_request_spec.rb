require 'rails_helper'

RSpec.describe "CollectedShifts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/collected_shifts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/collected_shifts/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/collected_shifts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/collected_shifts/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
