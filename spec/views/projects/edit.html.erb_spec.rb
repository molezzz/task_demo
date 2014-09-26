require 'rails_helper'

RSpec.describe "projects/edit", :type => :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :key => "MyString",
      :title => "MyString",
      :team => nil
    ))
  end

  it "renders the edit project form" do
    
  end
end
