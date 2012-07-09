# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Group < ActiveRecord::Base
  attr_accessible :description
  has_many :models
end
