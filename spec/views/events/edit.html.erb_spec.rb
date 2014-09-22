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
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_kind[name=?]", "event[kind]"

      assert_select "input#event_source_id[name=?]", "event[source_id]"

      assert_select "input#event_target[name=?]", "event[target]"

      assert_select "input#event_target_id[name=?]", "event[target_id]"

      assert_select "textarea#event_data[name=?]", "event[data]"
    end
  end
end
