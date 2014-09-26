require 'rails_helper'

RSpec.describe "comments/show", :type => :view do
  before(:each) do
    @comment = assign(:comment, Comment.create!(
      :key => "Key",
      :user => nil,
      :todo => nil,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    
  end
end
