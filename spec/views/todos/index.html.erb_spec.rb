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
    
  end
end
