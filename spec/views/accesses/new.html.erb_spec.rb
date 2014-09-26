require 'rails_helper'

RSpec.describe "accesses/new", :type => :view do
  before(:each) do
    assign(:access, Access.new(
      :user => nil,
      :project => nil
    ))
  end

  it "renders new access form" do
    
  end
end
