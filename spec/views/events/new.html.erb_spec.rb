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
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_kind[name=?]", "event[kind]"

      assert_select "input#event_source_id[name=?]", "event[source_id]"

      assert_select "input#event_target[name=?]", "event[target]"

      assert_select "input#event_target_id[name=?]", "event[target_id]"

      assert_select "textarea#event_data[name=?]", "event[data]"
    end
  end
end
