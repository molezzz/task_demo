require 'rails_helper'

RSpec.describe "projects/new", :type => :view do
  before(:each) do
    assign(:project, Project.new(
      :key => "MyString",
      :title => "MyString",
      :team => nil
    ))
  end

  it "renders new project form" do
    
  end
end
