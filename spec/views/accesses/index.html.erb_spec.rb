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
    
  end
end
