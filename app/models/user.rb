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

end
