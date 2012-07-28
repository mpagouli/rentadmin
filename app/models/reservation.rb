# == Schema Information
#
# Table name: reservations
#
#  id         :integer         not null, primary key
#  startDate  :datetime
#  endDate    :datetime
#  duration   :decimal(, )
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Reservation < ActiveRecord::Base
  attr_accessible :duration, :endDate, :startDate
  #has_many :reservation_vehicles, :dependent => :restrict
  #has_many :vehicles, :through => :reservation_vehicles, :source => :vehicle
  #validates_associated :vehicles
  #validates :vehicles, :presence => { :message => "At least one vehicle is required" }
  belongs_to :vehicle
  belongs_to :client
  validates :vehicle, :presence => { :message => "Vehicle is required" }
  validates :client, :presence => { :message => "Client is required" }
  #def vehicLess?
  #	if self.vehicles.empty? 
  #		self.errors.add(:vehicles, msg = "At least one vehicle is required")
  #	end
  #	self.vehicles.empty?
  #end 

end
