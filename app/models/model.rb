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
#  model_name  :string(255)
#

class Model < ActiveRecord::Base
  attr_accessible :model_name, :description

  before_save do |model|
    model.model_name = model_name.downcase
  end

  belongs_to :make
  belongs_to :group
  has_many :vehicles, :dependent => :restrict
  has_many :assets, :dependent => :restrict
  validates_associated :vehicles
  validates_associated :assets
  validates :make, :presence => { :message => "Make is required" }
  #validates :group, :presence => true
  validates :model_name, :presence => { :message => "Model name is required" }, :uniqueness => { case_sensitive: false }
  validates :description, :length => {
									    :maximum   => 400,
									    :too_long  => "Description must not exceed 400 characters"
									  }
end
