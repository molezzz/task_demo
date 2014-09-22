require 'rails_helper'

RSpec.describe "users/new", :type => :view do
  before(:each) do
    assign(:user, User.new(
      :key => "MyString",
      :team => nil,
      :name => "MyString",
      :email => "MyString",
      :avatar => "MyText"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_key[name=?]", "user[key]"

      assert_select "input#user_team_id[name=?]", "user[team_id]"

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "textarea#user_avatar[name=?]", "user[avatar]"
    end
  end
end
