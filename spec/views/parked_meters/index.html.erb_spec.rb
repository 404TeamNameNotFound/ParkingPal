require 'rails_helper'

RSpec.describe "parked_meters/index", :type => :view do
  before(:each) do
    assign(:parked_meters, [
      ParkedMeter.create!(
        :parking_meter => nil
      ),
      ParkedMeter.create!(
        :parking_meter => nil
      )
    ])
  end

  it "renders a list of parked_meters" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
