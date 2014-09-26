require 'rails_helper'

RSpec.describe "events/edit", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :kind => "MyString",
      :source_id => 1,
      :target => "MyString",
      :target_id => 1,
      :data => "MyText"
    ))
  end

  it "renders the edit event form" do
   
  end
end
