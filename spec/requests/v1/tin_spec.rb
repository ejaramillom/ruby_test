require 'rails_helper'

RSpec.describe "V1::Tins", type: :request do
  describe "POST /validator" do
    it "returns http failed with code 422" do
      post v1_tin_validator_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns http success with country and number params" do
      post  v1_tin_validator_path, params: { country: 'ca', number: '123456789' }
      expect(response).to have_http_status(:success)
    end
  end
end
