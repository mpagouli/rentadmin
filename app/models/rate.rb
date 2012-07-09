# == Schema Information
#
# Table name: rates
#
#  id          :integer         not null, primary key
#  type        :string(255)
#  description :string(255)
#  price       :decimal(, )
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Rate < ActiveRecord::Base
  attr_accessible :description, :price, :type
end
