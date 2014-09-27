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

  end
end
