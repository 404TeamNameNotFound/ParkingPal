class User < ActiveRecord::Base
  has_secure_password
  has_one :parked_meter
  has_many :recent_meters
  has_many :parking_meters, :through => :recent_meters

  def admin?
    self.role == 'admin'
  end
end
