# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  group_name  :string(255)
#

class Group < ActiveRecord::Base
  attr_accessible :group_name, :description
  has_many :models
  validates_associated :models
  validates :group_name, :presence => { :message => "Group name is required" }, :uniqueness => true
  validates :description, :length => {
									    :maximum   => 1000,
									    :too_long  => "Description must not exceed 1000 characters"
									  }
end
