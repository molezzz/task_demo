require 'rails_helper'

RSpec.describe "todos/show", :type => :view do
  before(:each) do
    @todo = assign(:todo, Todo.create!(
      :key => "Key",
      :project => nil,
      :creator_id => 1,
      :owner_id => 2,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Key/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end
