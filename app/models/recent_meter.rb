class RecentMeter < ActiveRecord::Base
	belongs_to :user
	belongs_to :parking_meter
end
