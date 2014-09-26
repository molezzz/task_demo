require 'rails_helper'

RSpec.describe "users/show", :type => :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :key => "Key",
      :team => nil,
      :name => "Name",
      :email => "Email@aa.cc",
      :avatar => "MyText.jpg"
    ))
  end

  it "renders attributes in <p>" do
    
  end
end
