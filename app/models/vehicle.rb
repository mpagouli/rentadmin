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
  has_many :reservation_vehicles, :dependent => :restrict
  has_many :reservations, :through => :reservation_vehicles, :source => :reservation
  validates :model, :presence => { :message => "Model is required" }
  #validates_associated :reservations
  VALID_PlATE_REGEX = /\A[A-Z]+\s?[\d+\s?]+[\d]+\z/
  validates :reg_no, :presence => { :message => "Plate number is required" },
  			format: { with: VALID_PlATE_REGEX, message: "Plate number is invalid" }, :uniqueness => true

end
