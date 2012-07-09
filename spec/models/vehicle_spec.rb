# == Schema Information
#
# Table name: vehicles
#
#  id         :integer         not null, primary key
#  reg_no     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  model_id   :integer
#

require 'spec_helper'

describe Vehicle do
  before { @veh = Vehicle.new(reg_no: "Example Reg No") }

  subject { @veh }

  it { should respond_to(:reg_no) }
end
