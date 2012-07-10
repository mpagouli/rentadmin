# == Schema Information
#
# Table name: makes
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  make_name   :string(255)
#

class Make < ActiveRecord::Base
  attr_accessible :make_name, :description
  has_many :models
  validates_associated :models
  validates :make_name, :presence => { :message => "Make name is required" }, :uniqueness => true
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }
end
