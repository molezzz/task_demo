require 'rails_helper'

RSpec.describe "todos/index", :type => :view do
  before(:each) do
    assign(:todos, [
      Todo.create!(
        :key => "Key",
        :project => nil,
        :creator_id => 1,
        :owner_id => 2,
        :content => "MyText"
      ),
      Todo.create!(
        :key => "Key",
        :project => nil,
        :creator_id => 1,
        :owner_id => 2,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of todos" do
    render
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
