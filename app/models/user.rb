class User < ActiveRecord::Base
  has_secure_password
  belongs_to :parked_meter
  has_many :parking_meters

  def admin?
    self.role == 'admin'
  end
end
