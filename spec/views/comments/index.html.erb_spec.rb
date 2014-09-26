require 'rails_helper'

RSpec.describe "comments/index", :type => :view do
  before(:each) do
    assign(:comments, [
      Comment.create!(
        :key => "Key",
        :user => nil,
        :todo => nil,
        :content => "MyText"
      ),
      Comment.create!(
        :key => "Key",
        :user => nil,
        :todo => nil,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of comments" do
    
  end
end
