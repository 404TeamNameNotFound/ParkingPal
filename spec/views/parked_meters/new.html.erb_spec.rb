require 'rails_helper'

RSpec.describe "parked_meters/new", :type => :view do
  before(:each) do
    assign(:parked_meter, ParkedMeter.new(
      :parking_meter => nil
    ))
  end

  it "renders new parked_meter form" do
    render

    assert_select "form[action=?][method=?]", parked_meters_path, "post" do

      assert_select "input#parked_meter_parking_meter_id[name=?]", "parked_meter[parking_meter_id]"
    end
  end
end
