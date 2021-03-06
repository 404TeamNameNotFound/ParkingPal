class ParkedMeter < ActiveRecord::Base
  has_one :parking_meter
  belongs_to :user

  def reset
  	meter = ParkingMeter.find(self.parking_meter_id)
  	if meter.unoccupy
	  	self.set_attrs_to_nil
	  end
  end

  def set_attrs_to_nil
    self.time_left = nil
    self.parking_meter_id = nil
    if self.save
      puts 'Reset successful.'
    else
      puts 'Reset failed.'
    end
  end
end
