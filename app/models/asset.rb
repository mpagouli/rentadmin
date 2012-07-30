# == Schema Information
#
# Table name: assets
#
#  id                :integer         not null, primary key
#  filename          :string(255)
#  description       :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  model_id          :integer
#  asset_category_id :integer
#

class Asset < ActiveRecord::Base
  attr_accessible :description, :filename

  belongs_to :asset_category

  validates :filename, :presence => { :message => "Filename is required" }, :uniqueness => true
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }


end
