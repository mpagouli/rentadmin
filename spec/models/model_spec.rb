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

require 'spec_helper'

describe Model do

  before { @model = Make.new(description: "Example Model") }

  subject { @model }

  it { should respond_to(:description) }

end
