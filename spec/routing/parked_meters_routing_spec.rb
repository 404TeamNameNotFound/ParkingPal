require "rails_helper"

RSpec.describe ParkedMetersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/parked_meters").to route_to("parked_meters#index")
    end

    it "routes to #new" do
      expect(:get => "/parked_meters/new").to route_to("parked_meters#new")
    end

    it "routes to #show" do
      expect(:get => "/parked_meters/1").to route_to("parked_meters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/parked_meters/1/edit").to route_to("parked_meters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/parked_meters").to route_to("parked_meters#create")
    end

    it "routes to #update" do
      expect(:put => "/parked_meters/1").to route_to("parked_meters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/parked_meters/1").to route_to("parked_meters#destroy", :id => "1")
    end

  end
end
