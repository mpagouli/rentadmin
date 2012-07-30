# == Schema Information
#
# Table name: reservations
#
#  id               :integer         not null, primary key
#  startDate        :datetime
#  endDate          :datetime
#  duration         :decimal(, )
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  vehicle_id       :integer
#  client_id        :integer
#  reservation_code :string(255)
#
class ReservationStatus < ActiveEnum::Base
  value :id => 1, :name => 'PENDING'
  value :id => 2, :name => 'CONFIRMED'
  value :id => 3, :name => 'CANCELLED'
  value :id => 4, :name => 'RUNNING'
  value :id => 5, :name => 'COMPLETED'
end

class Reservation < ActiveRecord::Base
  attr_accessible :duration, :drop_off_date, :pick_up_date, :reservation_code, :status
  enumerate :status, :with => ReservationStatus
  before_save do |reservation|
    reservation.duration = drop_off_date - pick_up_date
  end
  #has_many :reservation_vehicles, :dependent => :restrict
  #has_many :vehicles, :through => :reservation_vehicles, :source => :vehicle
  #validates_associated :vehicles
  #validates :vehicles, :presence => { :message => "At least one vehicle is required" }
  belongs_to :vehicle
  belongs_to :client
  validates :pick_up_date, :presence => { :message => "Pick-up date is required" }
  validates :drop_off_date, :presence => { :message => "Drop-off date is required" }
  validates :vehicle, :presence => { :message => "Vehicle is required" }
  validates :client, :presence => { :message => "Customer is required" }
  validates :reservation_code, :presence => { :message => "Reservation code is required" }
  validates_inclusion_of :status, :in => ReservationStatus

end
