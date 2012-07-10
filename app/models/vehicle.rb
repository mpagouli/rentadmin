# == Schema Information
#
# Table name: vehicles
#
#  id         :integer         not null, primary key
#  reg_no     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  model_id   :integer
#

class Vehicle < ActiveRecord::Base

  attr_accessible :reg_no
  belongs_to :model
  has_many :reservation_vehicles
  has_many :reservations, :through => :reservation_vehicles, :source => :reservation
  validates :model, :presence => { :message => "Model is required" }
  #validates_associated :reservations
  validates :reg_no, :presence => { :message => "Registration number is required" }, :uniqueness => true

end
