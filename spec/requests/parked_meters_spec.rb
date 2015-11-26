require 'rails_helper'

RSpec.describe "ParkedMeters", :type => :request do
  describe "GET /parked_meters" do
    it "works! (now write some real specs)" do
      get parked_meters_path
      expect(response).to have_http_status(200)
    end
  end
end
