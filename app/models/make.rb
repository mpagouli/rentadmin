# == Schema Information
#
# Table name: makes
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Make < ActiveRecord::Base
  attr_accessible :description
  has_many :models
end
