require 'rails_helper'

RSpec.describe "teams/edit", :type => :view do
  before(:each) do
    @team = assign(:team, Team.create!(
      :key => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit team form" do
    
  end
end
