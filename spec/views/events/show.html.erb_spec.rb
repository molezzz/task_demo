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
    
  end
end
