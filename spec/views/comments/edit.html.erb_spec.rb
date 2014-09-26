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
  
  end
end
