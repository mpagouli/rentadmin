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

  before_save do |make|
  	make.make_name = make_name.downcase
  end

  has_many :models, :dependent => :restrict
  validates_associated :models
  validates :make_name, :presence => { :message => "Make name is required" }, :uniqueness => { case_sensitive: false }
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }
end
