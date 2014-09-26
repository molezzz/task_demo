require 'rails_helper'

RSpec.describe "users/edit", :type => :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :key => "MyString",
      :team => nil,
      :name => "MyString",
      :email => "MyString1@aa.cc",
      :avatar => "MyText.jpg"
    ))
  end

  it "renders the edit user form" do
    
  end
end
