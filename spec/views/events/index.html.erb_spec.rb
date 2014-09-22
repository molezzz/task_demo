require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :kind => "Kind",
        :source_id => 1,
        :target => "Target",
        :target_id => 2,
        :data => "MyText"
      ),
      Event.create!(
        :kind => "Kind",
        :source_id => 1,
        :target => "Target",
        :target_id => 2,
        :data => "MyText"
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Target".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
