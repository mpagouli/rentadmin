# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Group do

  before { @group = Make.new(description: "Example Group") }

  subject { @group }

  it { should respond_to(:description) }
  
end
