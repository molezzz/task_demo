require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(
      :kind => "MyString",
      :source_id => 1,
      :target => "MyString",
      :target_id => 1,
      :data => "MyText"
    ))
  end

  it "renders new event form" do

  end
end
