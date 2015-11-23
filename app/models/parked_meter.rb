class ParkedMeter < ActiveRecord::Base
  has_one :parking_meter
  belongs_to :user
end
