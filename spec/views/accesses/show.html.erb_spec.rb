require 'rails_helper'

RSpec.describe "accesses/show", :type => :view do
  before(:each) do
    @access = assign(:access, Access.create!(
      :user => nil,
      :project => nil
    ))
  end

  it "renders attributes in <p>" do
    
  end
end
