class ParkedMeter < ActiveRecord::Base
  belongs_to :parking_meter
  has_one :user
end
