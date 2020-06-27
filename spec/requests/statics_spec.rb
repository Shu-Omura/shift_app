require 'rails_helper'

RSpec.describe "Statics", type: :request do
  describe "GET /" do
    it "returns http 200" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end
end
