require 'rails_helper'

RSpec.describe "teams/new", :type => :view do
  before(:each) do
    assign(:team, Team.new(
      :key => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new team form" do
    
  end
end
