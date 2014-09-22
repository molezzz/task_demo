require 'rails_helper'

RSpec.describe "accesses/index", :type => :view do
  before(:each) do
    assign(:accesses, [
      Access.create!(
        :user => nil,
        :project => nil
      ),
      Access.create!(
        :user => nil,
        :project => nil
      )
    ])
  end

  it "renders a list of accesses" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
