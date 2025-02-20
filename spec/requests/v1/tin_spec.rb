require 'rails_helper'

RSpec.describe "V1::Tins", type: :request do
  describe "GET /validator" do
    it "returns http success" do
      get "/v1/tin/validator"
      expect(response).to have_http_status(:success)
    end
  end

end
