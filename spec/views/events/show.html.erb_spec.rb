require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :kind => "Kind",
      :source_id => 1,
      :target => "Target",
      :target_id => 2,
      :data => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Kind/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Target/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end
