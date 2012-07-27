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
