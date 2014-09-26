require 'rails_helper'

RSpec.describe "todos/new", :type => :view do
  before(:each) do
    assign(:todo, Todo.new(
      :key => "MyString",
      :project => nil,
      :creator_id => 1,
      :owner_id => 1,
      :content => "MyText"
    ))
  end

  it "renders new todo form" do
    
  end
end
