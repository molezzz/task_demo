require 'rails_helper'

RSpec.describe "accesses/new", :type => :view do
  before(:each) do
    assign(:access, Access.new(
      :user => nil,
      :project => nil
    ))
  end

  it "renders new access form" do
    render

    assert_select "form[action=?][method=?]", accesses_path, "post" do

      assert_select "input#access_user_id[name=?]", "access[user_id]"

      assert_select "input#access_project_id[name=?]", "access[project_id]"
    end
  end
end
