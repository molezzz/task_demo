require 'rails_helper'

RSpec.describe "teams/show", :type => :view do
  before(:each) do
    @team = assign(:team, Team.create!(
      :key => "Key",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    
  end
end
