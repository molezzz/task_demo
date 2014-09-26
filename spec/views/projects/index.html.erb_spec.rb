require 'rails_helper'

RSpec.describe "projects/index", :type => :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        :key => "Key",
        :title => "Title",
        :team => nil
      ),
      Project.create!(
        :key => "Key",
        :title => "Title",
        :team => nil
      )
    ])
  end

  it "renders a list of projects" do
    
  end
end
