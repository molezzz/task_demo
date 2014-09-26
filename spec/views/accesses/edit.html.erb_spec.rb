require 'rails_helper'

RSpec.describe "accesses/edit", :type => :view do
  before(:each) do
    @access = assign(:access, Access.create!(
      :user => nil,
      :project => nil
    ))
  end

  it "renders the edit access form" do
    
  end
end
