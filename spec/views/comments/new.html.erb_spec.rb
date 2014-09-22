require 'rails_helper'

RSpec.describe "comments/new", :type => :view do
  before(:each) do
    assign(:comment, Comment.new(
      :key => "MyString",
      :user => nil,
      :todo => nil,
      :content => "MyText"
    ))
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do

      assert_select "input#comment_key[name=?]", "comment[key]"

      assert_select "input#comment_user_id[name=?]", "comment[user_id]"

      assert_select "input#comment_todo_id[name=?]", "comment[todo_id]"

      assert_select "textarea#comment_content[name=?]", "comment[content]"
    end
  end
end
