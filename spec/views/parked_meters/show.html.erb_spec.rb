require 'rails_helper'

RSpec.describe "parked_meters/show", :type => :view do
  before(:each) do
    @parked_meter = assign(:parked_meter, ParkedMeter.create!(
      :parking_meter => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
