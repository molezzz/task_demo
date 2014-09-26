require 'rails_helper'

RSpec.describe "users/new", :type => :view do
  before(:each) do
    assign(:user, User.new(
      :key => "MyString",
      :team => nil,
      :name => "MyString",
      :email => "MyString@aa.cc",
      :avatar => "MyText.jpg"
    ))
  end

  it "renders new user form" do
    
  end
end
