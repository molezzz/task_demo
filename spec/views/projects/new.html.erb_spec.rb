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
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_key[name=?]", "project[key]"

      assert_select "input#project_title[name=?]", "project[title]"

      assert_select "input#project_team_id[name=?]", "project[team_id]"
    end
  end
end
