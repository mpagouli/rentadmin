# == Schema Information
#
# Table name: clients
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Client < ActiveRecord::Base
  attr_accessible :email, :name, :surname, :identity_number

  before_save do |user|
  	user.email = email.downcase
  end
  has_many :reservations, :dependent => :restrict
  validates_associated :reservations
  validates :identity_number, :presence => { :message => "Customer identification is required" }
  validates :name, :presence => { :message => "Customer name is required" }
  validates :surname, :presence => { :message => "Customer surname is required" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { :message => "Customer email is required" }, format: { with: VALID_EMAIL_REGEX, message: "Customer email is invalid" }, uniqueness: { case_sensitive: false }
end
