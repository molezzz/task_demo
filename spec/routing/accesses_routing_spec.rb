require "rails_helper"

RSpec.describe AccessesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/accesses").to route_to("accesses#index")
    end

    it "routes to #new" do
      expect(:get => "/accesses/new").to route_to("accesses#new")
    end

    it "routes to #show" do
      expect(:get => "/accesses/1").to route_to("accesses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/accesses/1/edit").to route_to("accesses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/accesses").to route_to("accesses#create")
    end

    it "routes to #update" do
      expect(:put => "/accesses/1").to route_to("accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/accesses/1").to route_to("accesses#destroy", :id => "1")
    end

  end
end
