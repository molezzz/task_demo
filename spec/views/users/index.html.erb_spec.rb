require 'rails_helper'

RSpec.describe "users/index", :type => :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :key => "Key",
        :team => nil,
        :name => "Name",
        :email => "Email2@aa.cc",
        :avatar => "MyText.jpg"
      ),
      User.create!(
        :key => "Key",
        :team => nil,
        :name => "Name",
        :email => "Email@aa.cc",
        :avatar => "MyText.jpg"
      )
    ])
  end

  it "renders a list of users" do
    
  end
end
