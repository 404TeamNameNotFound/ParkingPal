class User < ActiveRecord::Base
  has_secure_password
  has_one :parked_meter
  has_many :recent_meters
  has_many :parking_meters, :through => :recent_meters

  def admin?
    self.role == 'admin'
  end

  def get_recents
  	recent_associations = self.recent_meters.order("updated_at desc").limit(10)
  	recent_associations.map { |a| ParkingMeter.find(a.parking_meter_id).name }
  end

  def reset_parked_meter
  	now = Time.new
  	expire_time = self.parked_meter.time_left
  	puts 'Checking user #' + self.id.to_s
  	if expire_time.nil?
  		puts 'No parked meter for user #' + self.id.to_s
  	elsif now.to_f > expire_time.to_f
  		puts expire_time.to_s + ' is before now; resetting ParkedMeter object.'
  		self.parked_meter.reset
	else
		puts expire_time.to_s + ' is after now; not resetting.'
	end
  end
end
