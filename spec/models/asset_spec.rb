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

require 'spec_helper'

describe Asset do
  
end
