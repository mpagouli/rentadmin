# == Schema Information
#
# Table name: models
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  make_id     :integer
#  model_id    :integer
#  group_id    :integer
#

class Model < ActiveRecord::Base
  attr_accessible :description
  belongs_to :make
  belongs_to :group
  has_many :vehicles
end
