require 'rails_helper'

RSpec.describe "parked_meters/edit", :type => :view do
  before(:each) do
    @parked_meter = assign(:parked_meter, ParkedMeter.create!(
      :parking_meter => nil
    ))
  end

  it "renders the edit parked_meter form" do
    render

    assert_select "form[action=?][method=?]", parked_meter_path(@parked_meter), "post" do

      assert_select "input#parked_meter_parking_meter_id[name=?]", "parked_meter[parking_meter_id]"
    end
  end
end
