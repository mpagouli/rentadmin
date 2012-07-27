class Asset < ActiveRecord::Base
  attr_accessible :description, :filename

  belongs_to :asset_category

  validates :filename, :presence => { :message => "Filename is required" }, :uniqueness => true
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }


end
