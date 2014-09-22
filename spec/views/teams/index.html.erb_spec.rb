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
    render
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
