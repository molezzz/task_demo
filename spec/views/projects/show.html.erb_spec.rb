require 'rails_helper'

RSpec.describe "projects/show", :type => :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :key => "Key",
      :title => "Title",
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    
  end
end
