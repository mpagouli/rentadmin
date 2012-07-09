# == Schema Information
#
# Table name: reservations
#
#  id         :integer         not null, primary key
#  startDate  :datetime
#  endDate    :datetime
#  duration   :decimal(, )
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Reservation do

  before { @res = Reservation.new(startDate: Date.new(2012, 7, 9), endDate:Date.new(2012,7,19), duration:11) }

  subject { @res }

  it { should respond_to(:startDate) }
  it { should respond_to(:endDate) }
  it { should respond_to(:duration) }

end
