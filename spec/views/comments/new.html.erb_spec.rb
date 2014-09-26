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
    
  end
end
