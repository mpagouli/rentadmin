# == Schema Information
#
# Table name: reservation_vehicles
#
#  id             :integer         not null, primary key
#  reservation_id :integer
#  vehicle_id     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class ReservationVehicle < ActiveRecord::Base
  attr_accessible :reservation_id, :vehicle_id
  belongs_to :reservation
  belongs_to :vehicle
end
