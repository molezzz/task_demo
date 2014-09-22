require 'rails_helper'

RSpec.describe "comments/edit", :type => :view do
  before(:each) do
    @comment = assign(:comment, Comment.create!(
      :key => "MyString",
      :user => nil,
      :todo => nil,
      :content => "MyText"
    ))
  end

  it "renders the edit comment form" do
    render

    assert_select "form[action=?][method=?]", comment_path(@comment), "post" do

      assert_select "input#comment_key[name=?]", "comment[key]"

      assert_select "input#comment_user_id[name=?]", "comment[user_id]"

      assert_select "input#comment_todo_id[name=?]", "comment[todo_id]"

      assert_select "textarea#comment_content[name=?]", "comment[content]"
    end
  end
end
