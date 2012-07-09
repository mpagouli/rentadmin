# == Schema Information
#
# Table name: makes
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Make do
  
  before { @make = Make.new(description: "Example Make") }

  subject { @make }

  it { should respond_to(:description) }

end
