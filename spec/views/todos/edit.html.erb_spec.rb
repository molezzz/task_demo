require 'rails_helper'

RSpec.describe "todos/edit", :type => :view do
  before(:each) do
    @todo = assign(:todo, Todo.create!(
      :key => "MyString",
      :project => nil,
      :creator_id => 1,
      :owner_id => 1,
      :content => "MyText"
    ))
  end

  it "renders the edit todo form" do
    
  end
end
