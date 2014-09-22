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
    render

    assert_select "form[action=?][method=?]", todos_path, "post" do

      assert_select "input#todo_key[name=?]", "todo[key]"

      assert_select "input#todo_project_id[name=?]", "todo[project_id]"

      assert_select "input#todo_creator_id[name=?]", "todo[creator_id]"

      assert_select "input#todo_owner_id[name=?]", "todo[owner_id]"

      assert_select "textarea#todo_content[name=?]", "todo[content]"
    end
  end
end
