# == Schema Information
#
# Table name: asset_categories
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class AssetCategory < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :assets, :dependent => :restrict
  validates_associated :assets

  validates :name, :presence => { :message => "Asset Category name is required" }, :uniqueness => { case_sensitive: false }
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }
end
