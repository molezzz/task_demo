require 'rails_helper'

RSpec.describe "accesses/edit", :type => :view do
  before(:each) do
    @access = assign(:access, Access.create!(
      :user => nil,
      :project => nil
    ))
  end

  it "renders the edit access form" do
    render

    assert_select "form[action=?][method=?]", access_path(@access), "post" do

      assert_select "input#access_user_id[name=?]", "access[user_id]"

      assert_select "input#access_project_id[name=?]", "access[project_id]"
    end
  end
end
