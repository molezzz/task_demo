require 'rails_helper'

RSpec.describe "users/edit", :type => :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :key => "MyString",
      :team => nil,
      :name => "MyString",
      :email => "MyString",
      :avatar => "MyText"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_key[name=?]", "user[key]"

      assert_select "input#user_team_id[name=?]", "user[team_id]"

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "textarea#user_avatar[name=?]", "user[avatar]"
    end
  end
end
