require 'rails_helper'

RSpec.describe "teams/index", :type => :view do
  before(:each) do
    assign(:teams, [
      Team.create!(
        :key => "Key",
        :name => "Name"
      ),
      Team.create!(
        :key => "Key",
        :name => "Name"
      )
    ])
  end

  it "renders a list of teams" do
    
  end
end
