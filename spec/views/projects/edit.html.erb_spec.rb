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
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input#project_key[name=?]", "project[key]"

      assert_select "input#project_title[name=?]", "project[title]"

      assert_select "input#project_team_id[name=?]", "project[team_id]"
    end
  end
end
